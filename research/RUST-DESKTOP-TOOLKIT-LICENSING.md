# Rust desktop toolkits — licensing and tooling (Slint, egui, GPUI)

**Last Updated**: 24/11/2026

## Question

For a native Rust desktop application that syntek-base generates — an app built for a client, or a
Syntek app the public downloads — what do Slint, egui and GPUI each oblige under their licences,
and how does their tooling compare?

## Verdict

**Licensing does not force egui, but egui carries the fewest strings.** All three can ship a
closed-source, sold desktop application free of charge:

- **egui** (MIT or Apache-2.0) and **GPUI** (Apache-2.0) need only their licence notices shipped.
- **Slint** is free for the same two cases only under its Royalty-free 2.0 licence, and that
  licence has conditions. The app must show Slint attribution. It may not be an embedded system.
  It may not expose Slint's APIs as a library for others. Breaking a condition means the paid
  Commercial licence or GPLv3.

**Tooling points the other way.** Slint is the only one with a stable 1.x line, a designer
language, a language server with live preview, and mobile and embedded targets. egui is pre-1.0,
immediate-mode, and has no native look by design. GPUI's crates.io release is a year stale and
cannot be consumed at its current state, so it is not yet a candidate outside Zed.

**For this template**, the choice is less "which one" than "which is the default". D9 lets a
developer bring their preferred framework, so the desktop directory can offer more than one
toolkit. That is N-043 on MAP-FRAMEWORK-NEUTRAL-FOUNDATION; this note settles nothing.

## Claims

### Licensing

| #   | Claim                                                                                                                                                                                                                                                                                   | Source                                                                                                                                                                                                                                                 |
| --- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| L1  | Slint offers three licences, the user's choice: GPL-3.0-only, Slint Royalty-free 2.0, or the paid Slint Software 3.0 (commercial). Every published `slint` and `i-slint-*` crate at 1.19.1 carries that expression.                                                                     | [LICENSE.md](https://raw.githubusercontent.com/slint-ui/slint/master/LICENSE.md); [workspace Cargo.toml](https://raw.githubusercontent.com/slint-ui/slint/master/Cargo.toml); [crates.io slint](https://crates.io/api/v1/crates/slint)                 |
| L2  | Royalty-free 2.0 covers desktop, mobile and web applications. A desktop application means a program for a general-purpose PC or notebook. Selling the application is allowed, and your own code may keep any licence.                                                                   | [Royalty-free 2.0](https://raw.githubusercontent.com/slint-ui/slint/master/LICENSES/LicenseRef-Slint-Royalty-free-2.0.md); [FAQ](https://raw.githubusercontent.com/slint-ui/slint/master/FAQ.md)                                                       |
| L3  | Royalty-free 2.0 requires attribution in one of two ways: the `AboutSlint` widget on an About screen (or splash screen), or a "Made with Slint" badge on a public web page such as the download page.                                                                                   | [Royalty-free 2.0](https://raw.githubusercontent.com/slint-ui/slint/master/LICENSES/LicenseRef-Slint-Royalty-free-2.0.md) section 2                                                                                                                    |
| L4  | Royalty-free 2.0 excludes embedded systems: a device built for one task inside a larger machine, such as an appliance controller or a kiosk-style terminal. It also forbids distributing Slint on its own, shipping an application that exposes Slint's APIs, and removing its notices. | [Royalty-free 2.0](https://raw.githubusercontent.com/slint-ui/slint/master/LICENSES/LicenseRef-Slint-Royalty-free-2.0.md) section 3                                                                                                                    |
| L5  | Slint sells seat plans (Startup and Individual, Small Enterprise, Enterprise), and charges per-device royalties for commercial embedded use, starting at USD 1 per device. Paid plans make attribution optional and cover embedded.                                                     | [slint.dev/pricing](https://slint.dev/pricing)                                                                                                                                                                                                         |
| L6  | This repository already takes the Royalty-free tier, and `package.sh` refuses a release build that lacks an `AboutSlint` instantiation.                                                                                                                                                 | [`code/docs/desktop/LICENSING.md`](../code/docs/desktop/LICENSING.md)                                                                                                                                                                                  |
| L7  | egui and eframe are MIT OR Apache-2.0. There is no NOTICE file at the root or in the egui or eframe crates, so Apache-2.0 section 4(d) adds nothing for them.                                                                                                                           | [workspace Cargo.toml](https://raw.githubusercontent.com/emilk/egui/main/Cargo.toml); [LICENSE-MIT](https://raw.githubusercontent.com/emilk/egui/main/LICENSE-MIT); [LICENSE-APACHE](https://raw.githubusercontent.com/emilk/egui/main/LICENSE-APACHE) |
| L8  | egui's default fonts crate adds OFL-1.1 and the Ubuntu Font Licence 1.0, whose texts must travel with the fonts. eframe turns that crate on by default (`default_fonts`).                                                                                                               | [epaint_default_fonts Cargo.toml](https://raw.githubusercontent.com/emilk/egui/main/crates/epaint_default_fonts/Cargo.toml); [eframe Cargo.toml](https://raw.githubusercontent.com/emilk/egui/main/crates/eframe/Cargo.toml)                           |
| L9  | egui's own cargo-deny allow-list admits MPL-2.0 (file-level copyleft) and the OpenSSL licence for parts of the tree, alongside permissive licences.                                                                                                                                     | [deny.toml](https://raw.githubusercontent.com/emilk/egui/main/deny.toml)                                                                                                                                                                               |
| L10 | GPUI is Apache-2.0, and so are its platform crates. The rest of the Zed repository carries a GPL licence, so only the `gpui*` crates are safe to depend on. The published 0.2.2 tarball has no NOTICE file.                                                                             | [gpui Cargo.toml](https://raw.githubusercontent.com/zed-industries/zed/main/crates/gpui/Cargo.toml); [repo root](https://api.github.com/repos/zed-industries/zed/contents/); [gpui 0.2.2 crate](https://crates.io/api/v1/crates/gpui/0.2.2/download)   |
| L11 | Neither egui nor GPUI has a paid tier, commercial licence or royalty.                                                                                                                                                                                                                   | [egui README](https://raw.githubusercontent.com/emilk/egui/main/README.md); [crates.io gpui](https://crates.io/api/v1/crates/gpui)                                                                                                                     |

### Tooling

| #   | Claim                                                                                                                                                                                                                                        | Source                                                                                                                                                                                                                                                                                   |
| --- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| T1  | Slint defines UI in a declarative `.slint` language. It is compiled ahead of time to Rust or C++, or interpreted for JavaScript and Python. A language server gives live preview, and there are `slint-viewer`, SlintPad and a Figma plugin. | [README](https://raw.githubusercontent.com/slint-ui/slint/master/README.md); [slint Cargo.toml](https://raw.githubusercontent.com/slint-ui/slint/master/api/rs/slint/Cargo.toml)                                                                                                         |
| T2  | Slint targets Windows, macOS, Linux, Android, iOS, the web, embedded Linux and microcontrollers.                                                                                                                                             | [README](https://raw.githubusercontent.com/slint-ui/slint/master/README.md)                                                                                                                                                                                                              |
| T3  | Slint is stable 1.x, with 1.19.1 published 24/11/2026 and a minor release roughly every two to three months. Its minimum Rust is 1.95.                                                                                                       | [crates.io slint](https://crates.io/api/v1/crates/slint); [CHANGELOG](https://raw.githubusercontent.com/slint-ui/slint/master/CHANGELOG.md)                                                                                                                                              |
| T4  | Slint turns on AccessKit by default, and its testing API, labelled preliminary, finds elements by accessible label.                                                                                                                          | [winit backend Cargo.toml](https://raw.githubusercontent.com/slint-ui/slint/master/internal/backends/winit/Cargo.toml); [testing API](https://docs.slint.dev/latest/docs/rust/i_slint_backend_testing/)                                                                                  |
| T5  | Slint draws its own widgets but offers native-styled themes (fluent, cupertino, material, cosmic, qt). The Qt style needs Qt installed.                                                                                                      | [widget styles](https://docs.slint.dev/latest/docs/slint/reference/std-widgets/style/)                                                                                                                                                                                                   |
| T6  | egui is immediate-mode plain Rust with no markup. It treats a native look as a non-goal, and it warns of breaking changes between releases.                                                                                                  | [egui README](https://raw.githubusercontent.com/emilk/egui/main/README.md)                                                                                                                                                                                                               |
| T7  | eframe targets Linux, macOS, Windows, Android and the web. No primary source lists iOS.                                                                                                                                                      | [eframe README](https://raw.githubusercontent.com/emilk/egui/main/crates/eframe/README.md)                                                                                                                                                                                               |
| T8  | egui turns on AccessKit by default, including AT-SPI on Linux through `accesskit_winit`. `egui_kittest` queries widgets by role or label and supports image snapshots.                                                                       | [accessibility guide](https://raw.githubusercontent.com/emilk/egui/main/docs/accessibility.md); [accesskit_winit 0.34.2](https://crates.io/api/v1/crates/accesskit_winit/0.34.2); [egui_kittest README](https://raw.githubusercontent.com/emilk/egui/main/crates/egui_kittest/README.md) |
| T9  | egui is pre-1.0. Version 0.37.0 was published 15/10/2026, and releases come every one to three months.                                                                                                                                       | [crates.io egui versions](https://crates.io/api/v1/crates/egui/versions?per_page=8)                                                                                                                                                                                                      |
| T10 | GPUI is Rust-only, hybrid immediate and retained mode, laid out with a Tailwind-style builder over taffy. It is pre-1.0 and expects frequent breaking changes.                                                                               | [gpui README](https://raw.githubusercontent.com/zed-industries/zed/main/crates/gpui/README.md)                                                                                                                                                                                           |
| T11 | GPUI's newest crates.io release is 0.2.2 from 22/10/2025. The Zed workspace sets `publish = false`, and `gpui_platform` is not on crates.io, so current GPUI cannot be consumed from crates.io.                                              | [crates.io gpui](https://crates.io/api/v1/crates/gpui); [Zed Cargo.toml](https://raw.githubusercontent.com/zed-industries/zed/main/Cargo.toml); [crates.io gpui_platform](https://crates.io/api/v1/crates/gpui_platform)                                                                 |
| T12 | GPUI's AccessKit support exists only on Zed's main branch, not in the published 0.2.2 crate, and it is opt-in per element.                                                                                                                   | [`_accessibility.rs`](https://raw.githubusercontent.com/zed-industries/zed/main/crates/gpui/src/_accessibility.rs); [gpui 0.2.2 crate](https://crates.io/api/v1/crates/gpui/0.2.2/download)                                                                                              |
| T13 | The fresher `gpui-pre` snapshots are published by the author of `gpui-component` (Longbridge), not by the Zed Industries crates.io team.                                                                                                     | [crates.io gpui-pre](https://crates.io/api/v1/crates/gpui-pre); [crates.io gpui-component](https://crates.io/api/v1/crates/gpui-component)                                                                                                                                               |
| T14 | GPUI targets macOS, Linux, FreeBSD and Windows. iOS and web crates exist on main, of unknown maturity, and there is no Android crate.                                                                                                        | [gpui README](https://raw.githubusercontent.com/zed-industries/zed/main/crates/gpui/README.md); [repo root](https://api.github.com/repos/zed-industries/zed/contents/)                                                                                                                   |

## Unverified

1. Slint's seat-plan prices, which the pricing page renders with JavaScript, and the full Commercial
   licence (Slint Software 3.0) text.
2. Qt's obligations when Slint's Qt backend or style is used.
3. The full transitive licence graph for each toolkit. No `cargo-deny` or `cargo-about` run was made.
4. Whether egui's default desktop build actually pulls in `webpki-roots` (MPL-2.0) or `ring`
   (OpenSSL licence).
5. eframe on iOS, and the maturity of GPUI's iOS and web crates.

## Sources

Primary sources were read on 24/11/2026: licence files, `Cargo.toml` manifests, READMEs and
changelogs at the upstream default branch, the crates.io API, docs.slint.dev and slint.dev/pricing.
An independent pass then re-read them to refute each claim, and its corrections are folded in above.
Perplexity and search results only located sources and are not cited. No third-party text is
quoted verbatim, so no _Influences_ row or third-party notice is owed.

## Feeds

- **N-043 on MAP-FRAMEWORK-NEUTRAL-FOUNDATION** — which desktop toolkits the desktop-app directory
  offers, and which is the default.
- **N-035 on MAP-FRAMEWORK-NEUTRAL-FOUNDATION** — all three draw their own widgets, so the native
  boundary rules on every one of them.
- **N-040 on MAP-FRAMEWORK-NEUTRAL-FOUNDATION** — the desktop directory inside the Rust split.

24/11/2026. No ADR, story or plan cites this note yet.
