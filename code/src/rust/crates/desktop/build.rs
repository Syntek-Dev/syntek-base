//! Compiles the .slint UI files into Rust at build time.
//!
//! slint-build re-runs whenever a .slint file changes, so the generated code and the
//! markup can never drift.
//!
//! Returns Result rather than unwrapping: the crate denies `expect_used`, and cargo
//! prints a returned error far more legibly than a build-script panic.

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // The style is named here because Slint picks one either way: from 1.16 the
    // fallback is Microsoft Fluent on every platform, so saying nothing ships a vendor
    // look on macOS and Linux that nobody chose. Stating it in the build script rather
    // than leaving it to SLINT_STYLE also keeps the app's appearance out of the hands
    // of whichever environment happened to run the build.
    //
    // Fluent is the value on the merits, not by inertia: it is the only built-in style
    // still actively maintained, so Cupertino, Material, Qt and Native would each buy a
    // different default at the cost of a deprecated one. It is the structural substrate
    // only: the project's own look is composed over it from the Palette and StyleMetrics
    // globals in ui/app.slint.
    //
    // Rule and rationale: code/docs/visual-design/DESKTOP.md. Gate:
    // code/src/scripts/desktop/style-check.sh.
    let config = slint_build::CompilerConfiguration::new().with_style("fluent".into());
    slint_build::compile_with_config("ui/app.slint", config)?;
    Ok(())
}
