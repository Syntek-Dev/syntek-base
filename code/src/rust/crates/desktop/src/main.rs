//! Native desktop client for `<%PROJECT_NAME%>`.
//!
//! The desktop app is a **peer of the web surface, not a layer on it** — it talks to the
//! Django Ninja API at `/api/` exactly as any third-party client would, and never renders
//! a Django template.
//!
//! Two rules govern everything added here:
//!
//! 1. **Never panic in hand-written code.** A panic kills the user's window with no error
//!    they can act on. `unwrap`, `expect`, `panic!` and slice indexing are denied at the
//!    lint level — see the `ui` module below for the one scoped exception.
//! 2. **The AboutSlint attribution stays.** It is the disclosure Slint's Royalty-free
//!    licence requires in exchange for free commercial use.

/// The UI generated from `ui/app.slint` by `build.rs`.
///
/// **Why the blanket allow.** `slint::include_modules!()` pastes machine-generated code
/// into this crate, and that code uses `unwrap()` freely — several hundred times in a
/// trivial window. Our crate-level lint table denies exactly that, so the two cannot
/// coexist unless the generated code is walled off.
///
/// Confining the generated code to its own module keeps the allow **scoped to code we did
/// not write**: everything in `main` below is still held to the strict table. Putting the
/// allow at crate root instead would silently disarm the lint for our own code too, which
/// is the failure this arrangement exists to prevent.
// Every restriction lint must be named individually: `clippy::all` does NOT include the
// restriction group, which is where all of these live. Keep this list in step with the
// `[lints.clippy]` table in Cargo.toml — a lint denied there and missing here fails the
// build on code nobody in this repository wrote. `todo` is the live example: `slint-build`
// emits `todo!("Components written in Rust can not get embedded yet.")` into `out/app.rs`.
#[allow(
    clippy::all,
    clippy::pedantic,
    clippy::unwrap_used,
    clippy::expect_used,
    clippy::panic,
    clippy::indexing_slicing,
    clippy::todo,
    clippy::unimplemented,
    clippy::unreachable
)]
mod ui {
    slint::include_modules!();
}

// `ComponentHandle` supplies `new`, `as_weak` and `run`. Confining the generated code to
// a module means its `pub use` no longer reaches this scope, so import it explicitly.
use slint::ComponentHandle;
use ui::AppWindow;

fn main() -> Result<(), slint::PlatformError> {
    let window = AppWindow::new()?;

    // Callbacks hold a weak handle so the closure never keeps the window alive.
    let handle = window.as_weak();
    window.on_refresh(move || {
        if let Some(window) = handle.upgrade() {
            window.set_status(slint::SharedString::from("Refreshed"));
        }
    });

    window.run()
}
