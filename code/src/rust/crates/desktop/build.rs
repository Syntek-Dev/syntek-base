//! Compiles the .slint UI files into Rust at build time.
//!
//! slint-build re-runs whenever a .slint file changes, so the generated code and the
//! markup can never drift.
//!
//! Returns Result rather than unwrapping: the crate denies `expect_used`, and cargo
//! prints a returned error far more legibly than a build-script panic.

fn main() -> Result<(), Box<dyn std::error::Error>> {
    slint_build::compile("ui/app.slint")?;
    Ok(())
}
