//! First-party native primitives for `<%PROJECT_NAME%>`.
//!
//! This is the **baseline** module: two primitives that demonstrate the boundary rules
//! the guides describe, and nothing more. Real functionality arrives with the story that
//! needs it. See `code/docs/RUST.md` and `code/docs/rust/PYO3-BOUNDARY.md`.
//!
//! Two rules govern everything added here:
//!
//! 1. **Never panic across the boundary.** Return `PyResult` and let PyO3 raise. A panic
//!    in a Gunicorn worker is a 500 at best; `unwrap`, `expect`, `panic!` and slice
//!    indexing are denied at the lint level so the compiler enforces it.
//! 2. **Secret material never reaches the allocator unzeroed.** Anything holding key or
//!    plaintext bytes wraps them so `Drop` wipes them — that is the whole reason this
//!    crate exists rather than the equivalent Python.

use pyo3::exceptions::PyValueError;
use pyo3::prelude::*;
use pyo3::types::PyBytes;
use zeroize::Zeroize;

/// Compare two byte strings in time independent of their contents.
///
/// Python's `==` on `bytes` short-circuits at the first differing byte, which leaks the
/// length of the matching prefix to anyone who can time it. Use this for any comparison
/// against a secret: MAC tags, session tokens, password-reset nonces, API keys.
///
/// Returns `False` for differing lengths. Length is not itself secret here — the caller
/// is comparing against a value of known, fixed width.
#[pyfunction]
fn constant_time_eq(left: &[u8], right: &[u8]) -> bool {
    if left.len() != right.len() {
        return false;
    }
    // Fold rather than index: `indexing_slicing` is denied, and the accumulator must not
    // short-circuit or the whole point is lost.
    let differences = left
        .iter()
        .zip(right.iter())
        .fold(0u8, |acc, (a, b)| acc | (a ^ b));
    differences == 0
}

/// A byte buffer whose contents are wiped when it is dropped.
///
/// Python `bytes` are immutable and garbage-collected: once key material is in one, you
/// cannot erase it, and copies linger in the allocator until overwritten by chance. Hold
/// secrets here instead, and let the destructor guarantee the wipe.
///
/// **Honest limit:** this wipes *this* buffer. It cannot retract copies Python already
/// made, and it does not stop the OS paging the page to swap — that needs `mlock`, which
/// is a per-deployment decision (`code/docs/rust/MEMORY-HYGIENE.md`).
#[pyclass(name = "SecretBytes")]
struct SecretBytes {
    inner: Vec<u8>,
}

#[pymethods]
impl SecretBytes {
    #[new]
    fn new(data: &[u8]) -> Self {
        Self {
            inner: data.to_vec(),
        }
    }

    /// Length in bytes. Safe to expose — it is not the secret.
    fn __len__(&self) -> usize {
        self.inner.len()
    }

    /// Deliberately opaque. A secret that renders itself into a log line is the most
    /// common way key material escapes, so neither `repr()` nor `str()` shows contents.
    fn __repr__(&self) -> String {
        format!("<SecretBytes len={}>", self.inner.len())
    }

    /// Copy the contents back into Python.
    ///
    /// Named to be conspicuous in review: the moment you call this, the zeroize guarantee
    /// stops applying to the copy you just made. Call it as late as possible and drop the
    /// result as early as possible.
    fn expose<'py>(&self, py: Python<'py>) -> PyResult<Bound<'py, PyBytes>> {
        if self.inner.is_empty() {
            return Err(PyValueError::new_err("secret has already been consumed"));
        }
        Ok(PyBytes::new(py, &self.inner))
    }

    /// Wipe now rather than waiting for the destructor.
    fn clear(&mut self) {
        self.inner.zeroize();
        self.inner.clear();
    }
}

impl Drop for SecretBytes {
    fn drop(&mut self) {
        self.inner.zeroize();
    }
}

#[pymodule]
fn nativecore(m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(constant_time_eq, m)?)?;
    m.add_class::<SecretBytes>()?;
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn equal_slices_compare_equal() {
        assert!(constant_time_eq(b"correct-horse", b"correct-horse"));
    }

    #[test]
    fn differing_slices_compare_unequal() {
        assert!(!constant_time_eq(b"correct-horse", b"correct-battery"));
    }

    #[test]
    fn differing_lengths_compare_unequal() {
        assert!(!constant_time_eq(b"short", b"considerably-longer"));
    }

    #[test]
    fn a_single_differing_byte_is_detected() {
        assert!(!constant_time_eq(b"aaaaaaaa", b"aaaaaaab"));
    }

    #[test]
    fn empty_slices_compare_equal() {
        assert!(constant_time_eq(b"", b""));
    }

    #[test]
    fn clear_wipes_the_buffer() {
        let mut secret = SecretBytes::new(b"key-material");
        secret.clear();
        assert_eq!(secret.__len__(), 0);
    }
}
