# Image scanning and pinning — what each surface pins, how it moves, and what Grype finds

**Written**: 16/10/2026; **Driver**: the 16/10/2026 pin-detect-move charting (`MAP-PIN-DETECT-MOVE`,
written alongside this note); **Read at**: `73fd24d`

**Method.** Two evidence passes earlier on 16/10/2026 (an image-scanning fact pass and a CHART-step
register and research pass), each checked by an adversarial verifier, served as leads only; where a
verifier corrected a claim the corrected form was the lead, and refuted claims were dropped. The
writer re-opened every load-bearing primary on 16/10/2026. This repository was read at `73fd24d`
with Read and grep; `GAPS.md`, `MAP-UPSTREAM-TRACKING.md` and the 14/10/2026 brief carried
uncommitted edits, so all three were read with `git show HEAD:` and their line numbers are the
committed file's. GitHub records (the ruleset, issues, workflow runs and job logs, releases,
advisories, caches, and source files at the tags and commits named below) were read with
`gh api` and `gh run view`. Web pages were read with the `scrapling` MCP `make_request` and
`bulk_get`, using CSS selectors to isolate sections of GitHub Docs, pnpm.io and docs.astral.sh; the
Expo CLI page's validation section could not be isolated by selector, so it was read from its own
source file in `expo/expo`, and uv's resolution guide likewise from `docs/` at the uv tag. Grype
0.120.0 (the host's `/run/current-system/sw/bin/grype`) was run read-only against `registry:`
images; cosign 3.1.3 verified one release bundle; anonymous `ghcr.io` manifest requests, the
`api.expo.dev` endpoints and npm registry records were fetched with `curl`. The Docker CLI was not
used, nothing was built, and no `pnpm`, `uv` or `expo` command ran. The `context7` and Perplexity
tiers were unauthenticated this session and were **not consulted** (`code/docs/GATE-REPORTING.md`:
could not look, not looked-and-clean); `WebFetch` and `WebSearch` were not used. _(reasoned)_ marks
an inference. **Nothing is quoted**: identifiers, flags, figures and file names appear as facts, and
every sentence is re-authored; the five-gram measurement is in the closing paragraph of _Sources_.
The note is committed, so it is published wherever this repository is; it never reaches a generated
project, because `copier.yml:146` excludes `/research/**` and `:147-148` re-include only
`CONTEXT.md` and `CLAUDE.md`. **This note records facts; the decisions they inform live on the
map.**

**Citation keys.** Other sections cite a claim by its section code and number (GM 2, RE 17): **GM**
Measured, **GI** Grype, **CI**, **PN** pnpm, **UV** uv, **EX** Expo, **RE** the repository, **CO**
Corrections.

- `gr:` is `anchore/grype@v0.120.1:`; `sa:` is `anchore/scan-action@v7.4.2:`; `gdb:` is
  `anchore/grype-db@6775aa0f:` (`main` on 16/10/2026).
- `uv:` is `astral-sh/uv@0.13.1:`; `su:` is `astral-sh/setup-uv@20cfd1bf:` (v10.0.1, the SHA this
  repository pins).
- `pn:` is `pnpm/pnpm@v11.25.0:pnpm11/`.
- `ex:` is `expo/expo@396da464:packages/@expo/cli/src/` (head of the `sdk-57` branch, last
  committed 15/10/2026); `exd:` is `expo/expo@112612b8:docs/pages/` (`main` on 16/10/2026).
- `cin:` is `sigstore/cosign-installer@6f9f1778:` (v4.1.2, the pinned SHA).
- Web keys expand to full URLs: `anc:` is `https://oss.anchore.com/docs/`; `ghd:` is
  `https://docs.github.com/en/actions/reference/`; `pnd:` is `https://pnpm.io/`; `uvd:` is
  `https://docs.astral.sh/uv/`.
- **`G`** is the Grype measurement of 16/10/2026: grype 0.120.0 (Syft 1.54.0), database schema
  v6.1.10 with a build time of `2026-10-16T06:29:51Z`, `--platform linux/amd64`, run from a scratch
  directory with database auto-update off.
- A bare path is this repository at `73fd24d`. A bare workflow file name (`claude.yml`,
  `audit-deps.yml`) is under `.github/workflows/`, a `Dockerfile.*` under `code/src/docker/django/`,
  and `PR-AND-REQUIRED-CHECKS.md` under `project-management/docs/git/`.
- `mut:` is `HEAD:project-management/src/01-FEATURE-MAPS/MAP-UPSTREAM-TRACKING.md`.

---

## Question

For every dependency surface this template ships, where does the repository control an exact pin,
what can scan those pins for published advisories (Grype, for the shipped Django production image),
and what does each toolchain offer for moving a pin only on purpose: a routine move after a
seven-day cooldown, and a security move at once through a named exception?

## Verdict

**Pins.** Exact pins sit almost entirely in lockfiles today. All four Django Dockerfiles take
`python:3.14-slim` and `ghcr.io/astral-sh/uv:latest` by tag, the three service images ride rolling
tags, direct manifests use carets, floors, tildes or nothing, 146 of 150 `uses:` lines are
SHA-pinned, and none of the five MCP servers names a version. **Detection.** No workflow builds or
publishes the production image, so nothing can scan it yet. Against the base it is built from, Grype
finds 161 matches; 159 of them are Debian packages, 112 wont-fix and 47 not-fixed, none with a fix,
and **none at High or above has a fix**; the three Alpine service images each fail that threshold on
one zlib advisory. Grype exits 2 on findings and 1 on errors, the inverse of this repository's audit
convention. Its release checksums are cosign-signed (a sigstore bundle since v0.120.0) and every
release from v0.103.0 is immutable, so checking the bundle and then the archive against the signed
checksums gives archive integrity without a separate hash _(reasoned)_; what the pin file holds is
left to the map. **Moving.** pnpm 11 already applies a one-day, non-strict cooldown. Since v11.1.3
each install re-checks the committed lockfile against the active age, with the result cached while
the lockfile is unchanged; setting a value explicitly also turns strict mode on. uv takes a duration
in `exclude-newer` with a per-package override, an `exact` bound for `uv add` (preview, and advised
against upstream), and a `required-version` guard that `setup-uv` also reads; none of it reaches
`uvx`. Expo's check compares installed versions with remote floors, five of which point at releases
from the last four days, so a strict seven-day cooldown and the current SDK 57 floors cannot both be
met until 19/10/2026 to 22/10/2026 _(reasoned)_.

---

## Measured - Grype against the base and service images

Claims **GM** 1 to 11. Every figure is from `G`. Images were pulled by tag on 16/10/2026; the
digests are what each tag resolved to then (index digest, then the amd64 manifest). **The project's
own images were not scanned**: none is published, and nothing was built. Modes: **(a)**
`--fail-on high --only-fixed`; **(b)** `--fail-on high`; **(c)** `--fail-on low --only-fixed`;
**(d)** `--fail-on low`. Each cell counts what the threshold catches once filters apply; every
non-zero cell exited 2.

| Image                         | Digests (index / amd64)               | Distro        | All | (a) | (b) | (c) | (d) |
| ----------------------------- | ------------------------------------- | ------------- | --: | --: | --: | --: | --: |
| `python:3.14-slim`            | `a2b82f3c...9170` / `cfe2e24a...0ca9` | Debian 13.7   | 161 |   0 |  55 |   2 | 115 |
| `postgres:18-alpine`          | `77f58511...1873` / `d8703cd7...2f66` | Alpine 3.24.2 |  32 |   1 |   9 |   3 |  32 |
| `valkey/valkey:8-alpine`      | `081c2f5c...8507` / `32627109...7119` | Alpine 3.24.2 |  43 |   1 |  13 |   1 |  43 |
| `nginx:alpine`                | `892bb215...d33d` / `138af827...b51b` | Alpine 3.24.2 |   4 |   1 |   1 |   1 |   4 |
| `ghcr.io/astral-sh/uv:latest` | `4a1f3666...a336` / `9a853e40...2edd` | none          |   0 |   0 |   0 |   0 |   0 |

1. **The Debian base is noise of every severity, none of it fixable.** Of the base's 161 matches,
   159 are Debian packages: High 54 wont-fix and 1 not-fixed, Medium 48 wont-fix, Low 10 wont-fix,
   Negligible 46 not-fixed. No Debian match carries a fix and none is Critical. The 55 High matches
   are 14 distinct IDs; four of them land on each of the nine binary packages built from
   `util-linux`, so 36 of the 55 are four advisories. (`G`, `-o json`)
2. **The base's two fixable matches are the interpreter, not the OS.** CVE-2025-15367 and
   CVE-2026-12345, both Medium, match `/usr/local/bin/python3.14` (CPython 3.14.8) through NVD CPE
   matching (namespace `nvd:cpe`, match type `cpe-match`). Their fix versions are 3.15.0a6 and
   3.15.0rc3, pre-releases of the next minor, with no 3.14.x fix listed. The second ID looks like a
   placeholder; it is what database v6.1.10 returns, and it was not checked against NVD. (`G`)
3. **One zlib advisory fails all three service images on mode (a).** CVE-2026-85091 hits zlib
   1.3.2-r0 (High, fixed in 1.3.2-r1, namespace `alpine:distro:alpine:3.24`); the upstream images
   had not been rebuilt onto the fix. On the Debian base the same ID hits `zlib1g` as not-fixed, and
   it is the one High left when `--ignore-states wont-fix` replaces `--only-fixed`. (`G`)
4. **postgres carries two more fixable matches** (its mode (c) count of 3): `nghttp2-libs`
   1.69.0-r0, CVE-2026-58055, fixed in 1.70.0-r0; and the Go module `github.com/moby/sys/user`
   v0.1.0, GHSA-mjcv-p78q-w5fw, fixed in 0.4.1, compiled into `/usr/local/bin/gosu`. (`G`)
5. **Every unknown fix state comes from CPE matching against OpenSSL.** All 26 unknown-state matches
   in postgres and all 39 in valkey are `nvd:cpe` matches on OpenSSL packages at 3.5.8-r0
   (`libssl3`, `libcrypto3`, and `openssl` in valkey): 13 distinct IDs, 4 of them High. nginx has no
   OpenSSL match. The three blank-state Medium matches in each Alpine image are CVE-2025-60876 on
   the busybox family, also by CPE. (`G`)
6. **A middle threshold exists.** `--ignore-states` accepts any of `fixed`, `not-fixed`, `unknown`
   and `wont-fix` (`grype --help`). Run as `--fail-on high --ignore-states wont-fix`, it counts
   python 1, postgres 9, valkey 13, nginx 1, each exit 2. (`G`)
7. **Go's standard library is a switch, off by default.** The default configuration has no Critical
   in any image. Enabling stdlib CPE matching (`GRYPE_MATCH_GOLANG_ALWAYS_USE_CPE_FOR_STDLIB=true`;
   default `false` at line 130 of `grype config`) adds 69 matches to postgres, all fixed (3
   Critical, 41 High, 24 Medium, 1 Low), from the go1.24.6 runtime inside `gosu`, and lifts its mode
   (a) count from 1 to 45. (`G`)
8. **Language packages in the base.** Grype catalogues `pip` 26.2.1 in
   `/usr/local/lib/python3.14/site-packages` (no match) and CPython as a binary package (GM 2); the
   uv image has no match. `uv.lock` locks the same `pip` 26.2.1, which the dev group's `pip-audit`
   pulls in through `pip-api` (`uv.lock:1167-1168,1180`; `pyproject.toml:199`), so pip-audit's
   all-groups export covers that version (`.github/workflows/audit-deps.yml:125-131`). _(reasoned)_
   The interpreter sits in no lock, so nothing this repository runs today looks at it. (`G`,
   `-o cyclonedx-json`)
9. **Exit codes.** A tripped `--fail-on` exits 2, as `grype --help` states. A missing image exits 1,
   `--fail-on banana` exits 1 with a configuration error, and a database older than the allowed age
   exits 1 (GI 11). Line 179 of `grype config` still says a tripped threshold returns 1. (`G`)
10. **A contradictory filter passes without a warning.** `--only-fixed` with `--only-notfixed` on
    the base returned 0 matches and exit 0, and Grype printed no warning. Anchore's filtering guide
    documents the empty result: it calls the pair mutually exclusive and says that together they
    leave nothing (`anc:guides/vulnerability/filter-results/`, the note under the only-fixed
    heading). (`G`)
11. **Scan cost with a warm database.** One registry pull and scan of the base took 3.81 s wall and
    262 MB peak memory on this workstation; it is not a runner figure. (`G`, `/usr/bin/env time`)

### Not measured here

The four built Django images (the production venv, `libpq5`, `libmagic1` and `curl`), any arm64
variant, whether the matches above are true positives, how pip-audit's findings overlap Grype's, and
how far the counts move as the tags re-point and the database is rebuilt each day.

## Grype - install, verification, database and ignore rules

Claims **GI** 1 to 17.

1. **Licence and cadence.** Grype is Apache-2.0. The latest release is v0.120.1 (06/10/2026); twelve
   releases ran from v0.111.1 (22/04/2026) to it. GitHub marks every release from v0.103.0 onward
   immutable and v0.102.0 and earlier mutable. (`gh api repos/anchore/grype`, `.../releases`)
2. **The signature format changed at v0.120.0.** v0.120.0 and v0.120.1 publish `checksums.txt` with
   `checksums.txt.sigstore.json`, one bundle file; v0.119.0 and earlier publish a
   `checksums.txt.pem` certificate beside a `checksums.txt.sig` signature. The installer marks the
   switch with `VERIFY_SIGN_BUNDLE_VERSION=v0.120.0` (`gr:install.sh:22`).
   (`gh api .../releases/tags/v0.120.1`, `.../v0.119.0`)
3. **Verified against an exact identity.** `cosign verify-blob --bundle` on the v0.120.1 checksums
   file, with identity
   `https://github.com/anchore/grype/.github/workflows/release.yaml@refs/heads/main` and issuer
   `https://token.actions.githubusercontent.com`, printed `Verified OK` (cosign 3.1.3, 16/10/2026).
   The certificate's SAN is that URI, so the identity names the release workflow on `main`, not the
   tag _(reasoned)_. The installer pins the same string (`gr:install.sh:603`).
4. **The signed file already carries each archive hash.** The v0.120.1 `checksums.txt` lists 15
   artefacts, `grype_0.120.1_linux_amd64.tar.gz` among them at `0a9ee97e...343d`. _(reasoned)_
   Verifying the signature and then the archive against that file gives integrity without a pin file
   of its own holding a hash.
5. **Anchore's verification page lags the release.** It still lists Grype among releases signed with
   a certificate and detached signature, shows only a regexp identity, and puts the floor for a
   bundle at cosign `v2.5.0` (`anc:installation/verification/`). The repository's pinned
   `cosign-installer` defaults to cosign v3.0.6 (`cin:action.yml:10-13`). The opengrep step passes
   `--certificate` and `--signature` (`.github/workflows/audit-static-analysis.yml:91-95`), so
   _(reasoned)_ it would not verify a Grype bundle unchanged.
6. **The official installer verifies a hash always and a signature only on request.** `install.sh`
   at v0.120.1 sets `VERIFY_SIGN=false` (`:16`), always runs its SHA-256 check (`:683`), and checks
   the signature only under `-v` with cosign present (`:819`).
7. **Anchore's action verifies less, and caches badly.** `anchore/scan-action` v7.4.2 (MIT,
   28/08/2026, `node24`) installs Grype v0.118.0 by default (`sa:GrypeVersion.js`), through the
   tag's `install.sh` with `-d -b <dir> <version>` and no `-v` (`sa:action.js:80,109`), so no
   signature is checked. Its defaults fail the build at `medium` (`sa:action.yml:16-30`). Its
   `cache-db` input caches the database under the fixed key `grype-db-<version>`
   (`sa:action.js:284`), and a GitHub cache entry cannot be rewritten under an existing key
   (`ghd:workflows-and-actions/dependency-caching`). Issue #778, open since 06/10/2026 with no
   reply, reports the result: the entry is never replaced until the Grype version moves. Each run
   therefore restores the stale entry, downloads the current database (about 190 MB, GI 9) and then
   fails to save it (`sa:action.js:285-310`). _(reasoned)_ The scan stays current; the cache saves
   no download.
8. **One advisory, no compromise.** GHSA-6gxw-85q2-q646 (CVE-2025-65965, high, 24/11/2025) covers
   registry credentials leaking into JSON output before 0.104.1. `anchore/scan-action` and
   `anchore/grype-db` publish none. (`gh api .../security-advisories`)
9. **The database is large and checksummed.** The archive is 190,642,248 bytes and installs as a
   3,257,589,760-byte `vulnerability.db`; a cold `grype db update` took 76.0 s on this workstation
   (16/10/2026). `latest.json` names one archive with a SHA-256, and `grype db status` reports the
   download URL with that checksum attached. (`curl -sI`; `ls -l`; `grype db status`)
10. **Published daily, nearly always.** The publisher runs on cron `0 6 * * *`
    (`gdb:.github/workflows/daily-db-publisher-r2.yaml:19`). Of its last 60 runs, 59 succeeded and
    one, on 19/08/2026, was cancelled with no replacement that day.
    (`gh run list -R anchore/grype-db`)
11. **A stale database is a hard failure.** Defaults: `validate-age: true` with
    `max-allowed-built-age: 120h0m0s`, `auto-update: true`, `validate-by-hash-on-start: true`,
    `require-update-check: false`, cache under `~/.cache/grype/db`, update checks at most every
    `2h`, and an application update check on each run (`grype config`, lines 272-277, 266, 269, 280,
    257, 291, 44). Anchore's database guide puts the limit at five days
    (`anc:guides/vulnerability/database/`). With the limit set to one minute, a scan exited 1 on
    `failed to load vulnerability db`. (`G`)
12. **Old binaries lose their data.** Schema v5 updates stopped on 06/03/2026, cutting off Grype
    before v0.88.0 (`anc:announcements/grype-db-v5-eol/`); 0.120.0 reads schema 6 (`grype version`).
13. **A rule can say why, but not until when.** `.grype.yaml` rules match on vulnerability, fix
    state and package name, version, type or location, and every criterion in a rule must hold
    (`anc:guides/vulnerability/filter-results/`). Measured: a rule's `reason` appears under
    `ignoredMatches[].appliedIgnoreRules`; a rule given `expires:` with a date already past still
    suppressed its match, with nothing about the key in `-vv` output. (`G`, `pkg:pypi/django@3.0.0`)
14. **Aliases are opt-in.** A rule keyed on CVE-2019-19844 left the same issue in place under
    GHSA-vfq6-hq5r-27r6 until `include-aliases: true` was added. (`G`)
15. **Scope can be narrowed by rule.** A `package: {type: python}` rule moved all 28 Django matches
    to the ignored list and turned exit 2 into 0; a `match-type: cpe-match` rule removed the two
    CPython matches and made `--fail-on medium --only-fixed` on the base exit 0. (`G`)
16. **Configuration comes from the working directory first.** Grype uses the first file it finds,
    starting with `./.grype.yaml` (`anc:reference/grype/configuration/`). Measured: one scan exited
    0 from the directory holding a rule and 2 from `/tmp`. (`G`)
17. **Thresholds apply after filtering.** Every filter (flags, rules, VEX) is applied before the
    `--fail-on` check, `high` also counts `critical`, and filtered matches land in `ignoredMatches`.
    VEX input is OpenVEX or CSAF; `not_affected` and `fixed` suppress by default, and Anchore
    advises naming products by digest because tags move.
    (`anc:guides/vulnerability/filter-results/`)

## CI - where a scan can run, and what it costs

Claims **CI** 1 to 9.

1. **Every PR builds the test image; the dev image waits for a path filter** (RE 4). On run
   38610112800 (14/10/2026) the test image's uncached build took 47.4 s (17:51:31.40 to
   17:52:18.75): the apt layer 10.8 s (1 upgrade, 79 new packages), `uv sync` 21.5 s (117 packages),
   the export 11.8 s, with no cached step, inside a 68 s test step. `[8/8] Security` took 55 s on
   the same run and builds nothing (`.github/workflows/claude.yml:5`).
   (`gh run view --job 116010956614 --log`, lines 182, 301, 770, 821, 940, 956)
2. **The nightly is short and late.** `audit-deps.yml` ran on 76 consecutive days (02/08/2026 to
   16/10/2026), none dropped: 55 failed, 21 passed. Its start trailed the 06:00 UTC cron by 38 to
   736 minutes (median 292, 90th percentile 415). The 15/10/2026 run took 2 min 21 s, 86 s of it a
   cold `cargo-deny` install; the 16/10/2026 run took 61 s with that cache warm. (`gh run list`,
   `gh run view 38724002639`, `38890054434`)
3. **What GitHub says about schedules.** Load can delay a scheduled run, the top of each hour is a
   busy time, and under enough load a queued run can be dropped; a schedule runs only from the
   default branch, and only once the file exists there; in a public repository, 60 days without
   activity disables it (`ghd:workflows-and-actions/events-that-trigger-workflows`, the `schedule`
   note). _(reasoned)_ A leg added on this branch runs nightly only after it reaches `main`.
4. **Runner size.** For public repositories the standard `ubuntu-latest` VM is 4 CPU, 16 GB RAM and
   a documented 14 GB of SSD; for private ones, 2 CPU and 8 GB with the same 14 GB
   (`ghd:runners/github-hosted-runners`). A maintainer's comment on `actions/runner-images#14492`
   (05/08/2026) puts the public 4-core disk at 150 GB with about 90 GB free since a 27/07/2026 fix,
   the private 2-core at 75 GB with about 14 GB free, and the commitment at 14 GB free on both. A
   generated project may be private _(reasoned)_.
5. **The label moves within weeks.** `ubuntu-latest` switches to Ubuntu 26.04 in a rollout starting
   19/10/2026 and due to finish by 19/11/2026 (`actions/runner-images#14748`); all 55 `runs-on:`
   lines here name `ubuntu-latest`.
6. **Disk fit** _(reasoned)_: an update briefly holds the 0.19 GB archive beside the 3.26 GB
   database, and a scan from a local Docker image adds the image itself; that fits the public
   runner's free space with room, and the 14 GB floor is the only figure GitHub commits to.
7. **The Actions cache.** A repository gets 10 GB by default, entries untouched for 7 days are
   removed, and eviction takes the least recently used first; an existing entry cannot be changed,
   only replaced under a new key. A cache that a `pull_request` run saves belongs to that PR's merge
   ref and only its re-runs can restore it; `schedule` is one of seven triggers allowed to write
   caches for the default branch. Cache contents are neither signed nor checked
   (`ghd:workflows-and-actions/dependency-caching`). This repository holds 3,364,384,773 bytes in 15
   entries, the two largest a 1.36 GB cargo cache on `main` and its copy on `refs/pull/15/merge`.
   (`gh api .../actions/cache/usage`, `.../actions/caches`)
8. **Pulls.** Hosted runners fetching public images from Docker Hub are exempt from its rate
   limiting (`ghd:limits`).
9. **A long step in `claude.yml` restarts on every push.** Its concurrency group cancels in-progress
   runs on every ref except `main` and `staging` (`.github/workflows/claude.yml:47-49`).

## pnpm 11 - cooldown and exact saves

Claims **PN** 1 to 9. pnpm.io serves the current (v12-era) documentation, so each load-bearing pnpm
11 fact was cross-checked against the v11 release notes or the 11.25.0 source this repository pins.

1. **The unit is minutes, and pnpm 11 already waits a day.** `minimumReleaseAge` defaults to 1440
   from v11 and was 0 before (`pnd:settings/dependency-resolution`); the 11.25.0 default is
   `24 * 60` (`pn:config/reader/src/index.ts:201`), introduced with strict mode off in v11.0.0
   (release notes, line 35). Transitive dependencies are covered too; a config dependency carrying
   `version+integrity` is exempt (`pnd:settings/dependency-resolution`).
2. **Setting a value makes it strict.** `minimumReleaseAgeStrict` defaults to true when the age is
   set anywhere (`pnpm-workspace.yaml`, the global `config.yaml`, any `PNPM_CONFIG_*` setting in the
   environment, or the CLI) and to false for the built-in value (v11.1.3 notes, line 11; in 11.25.0,
   `pn:config/reader/src/index.ts:711-723`, keyed on `explicitlySetKeys`). Off, pnpm installs a
   younger version when nothing in range is old enough; on, resolution fails
   (`pnd:settings/dependency-resolution`). The loose default records each young pick in
   `minimumReleaseAgeExclude` and carries on; strict mode without a terminal stops on
   `ERR_PNPM_NO_MATURE_MATCHING_VERSION` (v11.1.3 notes, lines 7-9).
3. **The committed lockfile is re-checked.** From v11.1.3 an install validates every lockfile entry
   against the active age before fetching anything and aborts, raising
   `ERR_PNPM_MINIMUM_RELEASE_AGE_VIOLATION`, honouring the exclude list; the outcome is cached, so a
   later install against the same unchanged lockfile skips the registry trip (v11.1.3 notes,
   line 3). `trustLockfile` (new in v11.3.0, off unless set) skips that pass (v11.3.0 notes, line 7;
   `pnd:settings/dependency-resolution`). _(reasoned)_ CI's `pnpm install --frozen-lockfile` holds
   the committed lock to whatever age is active: the built-in day today, an explicit cooldown once
   one is set.
4. **Exceptions are names, patterns or exact versions.** An exclude entry may be a package name
   (every version), a name pattern (from v10.17.0), or exact versions joined by `||` (from v10.19.0)
   (`pnd:settings/dependency-resolution`). `minimumReleaseAgeExcludePrune` (new in v11.22.0, off
   unless set) removes entries that the newly written lockfile does not resolve (v11.22.0 notes,
   line 9).
5. **pnpm itself is outside the workspace cooldown.** From v11.18.0 the workspace file's age
   settings no longer govern `pnpm self-update`, which takes its cooldown from the built-in value,
   global config, the environment or a flag (v11.18.0 notes, lines 9-15). This repository's updater
   runs a bare `pnpm self-update` (`code/src/scripts/development/pnpm-update.sh:68`).
6. **`.npmrc` is auth and registry only.** From v11.0.0 pnpm takes only authentication and registry
   settings from `.npmrc`, everything else from the global file or `pnpm-workspace.yaml`, with
   network settings still read there for migration (v11.0.0 notes, lines 14, 101-102;
   `pnd:settings`). _(reasoned)_ The four keys in this repository's `.npmrc` are none of those, so
   11.25.0 ignores them (RE 11).
7. **The saved range style follows the existing entry.** In 11.25.0 the style comes first from the
   manifest's current entry, then from the requested specifier, then from configuration; `saveExact`
   or an empty `savePrefix` selects the bare version
   (`pn:pkg-manifest/utils/src/rangeSpecStyle.ts:16-23,25-50`). _(reasoned)_ Turning on exact saves
   changes only new entries; the existing carets and tildes stay until edited.
8. **Versions.** The repository pins `pnpm@11.25.0` (`package.json:5`, `engines` `:8`), released
   29/08/2026; the newest 11.x is 11.28.6 (15/10/2026). (`gh api repos/pnpm/pnpm/releases`)
9. **`npx` is not pnpm.** _(reasoned)_ No pnpm setting governs the three `npx -y` MCP servers
   (`.mcp.json:9-22`).

## uv - cooldown, exact bounds and the version guard

Claims **UV** 1 to 10.

1. **Durations since 0.9.17.** `exclude-newer` accepts a relative duration from 0.9.17
   (`uv:changelogs/0.9.x.md:647,657`). The resolution guide calls this a dependency cooldown and
   takes friendly forms (`24 hours`, `1 week`) or ISO 8601 (`P7D`); calendar months and years are
   refused (`uv:docs/concepts/resolution.md:891-907`).
2. **Per-package override.** `exclude-newer-package` takes a date, a duration or `false` for one
   package, and a package value outranks the global and per-index values
   (`uv:docs/concepts/resolution.md:846-865,920-929`).
3. **The lock no longer stores the computed time.** The guide still says the computed timestamp is
   written to `uv.lock` (`uv:docs/concepts/resolution.md:910-913`), but 0.11.8 switched relative
   values to a fixed sentinel and allowed a lock carrying only `exclude-newer-span`
   (`uv:changelogs/0.11.x.md:345,356,362`); PR #19022 (merged 20/04/2026) did it to end merge
   conflicts over the timestamp. _(reasoned)_ The guide's sentence predates that change.
4. **`add-bounds`.** It sets the specifier `uv add` writes when none is given: `lower` (the
   default), `major`, `minor` or `exact`; with `--frozen` nothing is resolved and no bound is added;
   the option is marked preview (`uv:crates/uv-settings/src/settings.rs:2994-3012`;
   `uvd:reference/settings/#add-bounds`). Upstream's comment on `exact` advises against it because
   the lock already pins versions (`uv:crates/uv-configuration/src/add_bounds.rs:28-31`).
5. **`required-version`.** A PEP 440 specifier; a running uv that fails it exits with an error
   (`uv:crates/uv-settings/src/settings.rs:267-280`; `uvd:reference/settings/#required-version`).
6. **`setup-uv` reads the guard.** Given no `version` input, v10.0.1 looks for `required-version` in
   `uv.toml` at the root, or in `pyproject.toml`, and otherwise installs the latest
   (`su:README.md:32-33`); for a range it installs the highest match unless told otherwise
   (`su:docs/advanced-version-configuration.md:65-77`).
7. **`uvx` ignores project configuration.** Tool and self commands load only user-level settings
   (`uv:crates/uv/src/lib.rs:325-327`), and `uvx` is `uv tool run` under another name
   (`uv:docs/guides/tools.md:166`). _(reasoned)_ A cooldown or version guard in `pyproject.toml`
   does not reach the `uvx` sites (RE 15).
8. **Astral's Docker advice.** Pin a specific uv version in the `COPY --from`, pin by SHA256 where
   builds must be reproducible because a tag can move, and check attestations with
   `gh attestation verify` (`uv:docs/guides/integration/docker.md:139-154,579`).
9. **Releases against a seven-day window.** 0.12.22 (02/10/2026), 0.12.23 (03/10/2026), 0.12.24
   (08/10/2026), 0.13.0 (09/10/2026, 19:49Z) and 0.13.1 (14/10/2026)
   (`gh api repos/astral-sh/uv/releases`). _(reasoned)_ At 11:07Z on 16/10/2026, 0.12.24 was the
   newest release past seven days; 0.13.0 passed it at 19:49Z that day.
10. **Digests on `ghcr.io` (16/10/2026, 11:07Z).** `latest` and `0.13.1` share index
    `4a1f3666...a336`, the digest CI's 14/10/2026 build resolved (job 116010956614 log, line 222);
    `0.12.24` is `3af4716e...c65a`, `0.12.22` is `f513a91f...e1bc`, and `0.12.5` is
    `e85be844...74b1`. (anonymous `curl -I` to `ghcr.io/v2/astral-sh/uv/manifests/<tag>`)

## Expo - exact pins against the cooldown

Claims **EX** 1 to 8.

1. **The check reads what is installed.** `expo install --check` takes each version from
   `node_modules`, not from the manifest specifier
   (`ex:start/doctor/dependencies/validateDependenciesVersions.ts:125-126`;
   `ex:start/doctor/dependencies/resolvePackages.ts:13`). _(reasoned)_ An exact pin and a tilde that
   resolve to the same version get the same verdict.
2. **The comparison.** `expo` is flagged only when below its range (`semver.ltr`); every other
   package must satisfy its range, prereleases included
   (`ex:start/doctor/dependencies/validateDependenciesVersions.ts:293-300`).
3. **The ranges are remote.** Ranges from `api.expo.dev` win over the list bundled in the `expo`
   package, so Expo can correct a range without a release
   (`ex:start/doctor/dependencies/getVersionedPackages.ts:66-67`).
4. **Exit and CI use.** The check exits 0 when current and 1 when anything is behind
   (`ex:install/checkPackages.ts:73,81,104`); the CLI guide says it exits non-zero under CI and can
   hold a repository to the expected set (`exd:more/expo-cli.mdx:554,623`). The guide calls the tool
   best-effort, because React Native breaks compatibility from one version to the next (`:522`), and
   offers `expo.install.exclude` for a deliberate divergence (`:572`).
5. **The floors moved this week.** On 16/10/2026 the SDK 57 ranges were `expo` ~57.0.30,
   `expo-constants` ~57.0.22, `expo-linking` ~57.0.13, `expo-router` ~57.0.28, `react-native`
   0.86.3, `eslint-config-expo` ~57.0.2 and `jest-expo` ~57.0.6 (`api.expo.dev/v2/versions/latest`,
   `/v2/sdks/57.0.0/native-modules`); the lock resolves 57.0.9, 57.0.8, 57.0.4, 57.0.9, 0.86.2,
   57.0.1 and 57.0.3 (`pnpm-lock.yaml:70-120`). Expo's data covers 15 of the 18 mobile dependencies
   (not `@testing-library/react-native`, `eslint` or `typescript-eslint`). _(reasoned, not run)_ An
   online check flags those seven.
6. **Five of the new floors are days old.** npm publish times: `expo` 57.0.30 at 15/10/2026 14:38Z,
   `expo-constants` 57.0.22 at 14/10/2026 16:31Z, `expo-linking` 57.0.13 at 14/10/2026 16:32Z,
   `expo-router` 57.0.28 at 15/10/2026 14:43Z and `jest-expo` 57.0.6 at 12/10/2026 14:25Z; the
   other two, `react-native` 0.86.3 and `eslint-config-expo` 57.0.2, date from 24/08/2026 and
   26/08/2026 (`registry.npmjs.org`, each record's `time`). _(reasoned)_ Under an explicit, strict
   seven-day pnpm cooldown (PN 2), moving to the five finds no mature version until 19/10/2026 to
   22/10/2026 unless each is excluded.
7. **SDK 58 shipped this week.** Expo announced it on 15/10/2026
   (`https://expo.dev/changelog/sdk-58`); npm's `latest` for `expo` is 58.0.12, published 16/10/2026
   06:23Z, and its `sdk-57` tag is 57.0.30. The template declares `expo` ~57.0.9
   (`code/src/mobile/package.json:17`), and its contributor guide asks for a template release on
   every SDK release, immediately (`CONTRIBUTING.md:245-248`).
8. **Nothing here runs the check.** No script or workflow calls `expo install --check`, `--fix` or
   `expo-doctor`; the only mention is in the upstream map (`git grep`; `mut:234`). The mobile
   scripts do run `expo start` and `expo export` (`code/src/scripts/mobile/server.sh:56`,
   `code/src/scripts/mobile/bundle.sh:54`).

## The repository today - images, pins and gates

Claims **RE** 1 to 18.

1. **Dockerfiles.** All four take the base by tag and uv by `latest`, with no digest:
   `Dockerfile.dev:1,10`, `Dockerfile.test:1,10`, `Dockerfile.staging:2,9,20` and
   `Dockerfile.prod:2,9,20` (each `FROM python:3.14-slim` and
   `COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv`, under
   `code/src/docker/django/`). Staging and production copy uv into the builder stage only.
2. **What production ships.** The production runtime stage adds `libpq5`, `libmagic1` and `curl`
   (`Dockerfile.prod:20-26`) to a venv from `uv sync --frozen --no-dev --no-install-project` (`:17`)
   and runs as `USER django` (`:43`); staging is the same recipe. Dev and test are single stage and
   keep uv; their syncs are `Dockerfile.dev:22` (default groups) and `Dockerfile.test:24`
   (`--group test`). Both run as root: `grep USER` matches only `Dockerfile.prod:43` and
   `Dockerfile.staging:43`.
3. **Compose images.** `postgres:18-alpine`, `valkey/valkey:8-alpine` and `nginx:alpine` appear only
   in the dev and test files (`code/src/docker/docker-compose.dev.yml:11,35,77`;
   `code/src/docker/docker-compose.test.yml:9,35,69`). Production defines only `django`, pulled as
   `ghcr.io/<%ORG_SLUG%>/<%PROJECT_SLUG%>/django:${IMAGE_TAG:?...}` with no `build:`
   (`code/src/docker/docker-compose.prod.yml:16-17`); staging has an `image:` and a `build:` of
   `Dockerfile.staging` (`code/src/docker/docker-compose.staging.yml:15-19`). Both headers say
   GitHub Actions builds the image (`:1`) and that the server supplies Nginx, Postgres and Valkey
   (`:2`).
4. **Which workflows build which images.** `claude.yml` `[7/8] Tests` (`:378`, step `:458`) and
   `test.yml` `pytest + coverage` (`:27`, step `:112`) build `django-test` through
   `code/src/scripts/tests/backend-coverage.sh:101`, unfiltered (`test.yml:3-14`). `test-api.yml`
   builds it through `code/src/scripts/tests/api.sh:108` (step `:127`), path-filtered to the API
   tests, `code/src/django/**` and the test compose file (`:6-15`). `test-e2e.yml` builds the dev
   stack through `code/src/scripts/development/server.sh up --build` (`:91`), filtered to
   `code/src/django/**`, `code/src/docker/**` and `pyproject.toml` (`:11-20`). No workflow or
   script names `Dockerfile.prod` or `Dockerfile.staging`, and none pushes, logs in or uses
   `build-push-action` (`git grep`, exit 1 each).
5. **The required set.** Ruleset 20221742 (`main — protected`) is active on `~DEFAULT_BRANCH` with
   27 required contexts, `[7/8] Tests`, `[8/8] Security` and `pytest + coverage` among them, neither
   the e2e nor the Bruno job; the strict policy is off and no approval is required. Repository role
   5 may bypass it always, and so may the current user; classic protection on `main` answers 404.
   The repository is public, default branch `main`. (`gh api .../rulesets/20221742`;
   `.../branches/main/protection`; `repos/Syntek-Dev/syntek-base`)
6. **The rules for that set.** A workflow is path-filtered or required, never both
   (`project-management/docs/git/PR-AND-REQUIRED-CHECKS.md:42`); promotion deletes the filter in the
   same change (`:77`) and states the size the set becomes (`:99`); a schedule-only workflow cannot
   be required (`:136-138`; `.github/workflows/audit-deps.yml:22-30`).
7. **`audit-deps.yml`.** Schedule `0 6 * * *` plus dispatch (`:32-35`); permissions `contents: read`
   and `issues: write` (`:37-39`); one `ubuntu-latest` job (`:47-48`). The JS leg (`:99-104`) and
   Python leg (`:121-131`) are `continue-on-error` and tee their output; the Rust leg's comment
   starts at `:133`, its surface check at `:139`, with split cache restore and save (`:152-178`) and
   `rust/audit.sh --update` (`:182-188`). One step opens or comments on the tracking issue
   (`:190-224`) and the last fails the run (`:226-230`), both on the same four outcomes (`:191`,
   `:227`).
8. **The tracking issue never closes.** Issue #14 (opened 03/09/2026 by the Actions app, no labels,
   41 comments, the last on 14/10/2026) is open in a public repository after green runs on
   15/10/2026 and 16/10/2026; the workflow has no close step (`:190-230`). (`gh issue view 14`)
9. **The pre-PR audits sweep.** In template mode only (`copier.yml` present,
   `.claude/hooks/pre-pr-check.sh:79-80`; nine checks, `:370-373`), `check-audits.sh` runs every
   `audits/*.sh` with no arguments and fails on any non-zero exit
   (`.claude/hooks/lib/check-audits.sh:179-191`). `_AUDIT_SKIP` excludes `cloc.sh`, `security.sh`
   and `dependency-drift.sh`, with owners `check-cloc.sh`, `check-security.sh` and `-`, the last
   meaning the reason stands alone (`:111-118`).
10. **Toolchain pins and pin files.** The table lists `.nvmrc`, `.python-version`,
    `code/src/rust/rust-toolchain.toml` and `.opengrep-version`, under prose that says four files
    (`PR-AND-REQUIRED-CHECKS.md:149-159`), with `code/src/rust/.cargo-deny-version` as a scoped
    fifth (`:167-169`). `.opengrep-version` is the 7 bytes `1.27.1` and a newline,
    `.cargo-deny-version` `0.20.2` and a newline (`xxd`). The opengrep job verifies the engine with
    cosign against an exact identity and asserts the installed version
    (`audit-static-analysis.yml:91-95,104-111`); neither it nor
    `code/src/scripts/development/install-opengrep.sh` checks a SHA-256 (`grep -c sha256`: 0). The
    one version-and-digest scanner pin is inline: TruffleHog's
    `version: 3.96.0@sha256:...` (`.github/workflows/audit-secrets.yml:18-26`).
11. **uv and pnpm pins in CI and config.** `UV_VERSION: "0.12.5"` is set in `audit-deps.yml:42`,
    `syntax-python.yml:78` and `claude.yml:52`; four `setup-uv` steps pass no version
    (`audit-render-slop.yml:49`, `test-e2e.yml:57`, `audit-template.yml:111,144`); every `setup-uv`
    is SHA-pinned to `20cfd1bf` (v10.0.1). The images take `uv:latest`, which is 0.13.1 today (UV
    10). `.npmrc` holds `engine-strict`, `shamefully-hoist`, `strict-peer-dependencies` and
    `confirm-modules-purge` (`.npmrc:1-4`). `pnpm-workspace.yaml` sets no `minimumReleaseAge`; its
    11 `minimumReleaseAgeExclude` entries (`:155-166`, all from `fc905eb`, 01/08/2026) are
    unannotated, and 9 match nothing in `pnpm-lock.yaml`; only `form-data@4.0.6` and `ws@8.21.0`
    still resolve (`grep` per entry).
12. **Manifest specifiers.** Root `package.json` has 7 devDependencies, all carets, and pins
    `pnpm@11.25.0` with `engines` floors (`package.json:5-9,17-25`). `pyproject.toml` has 21 runtime
    dependencies, 11 with a `>=` floor and 10 with no bound (`:22-63`); the `dev` group has 2 floors
    and an unbounded `pip-audit`, the `test` group 9 floors (`:190-217`); the only `==` is the
    Playwright constraint (`:106`). `code/src/mobile/package.json` has 11 tilde, 5 caret and 2 exact
    (`react` 19.2.3, `react-native` 0.86.2) across 18 entries (`:16-37`). (`python3 -I` count)
13. **Action pins.** 146 of the 150 `uses:` lines carry a commit SHA. The four tag-pinned ones are
    `actions/checkout@v7` and `actions/upload-artifact@v7` at `audit-mcp-parity.yml:41,51` and
    `audit-playwright-pin.yml:56,68`, two workflows absent from `origin/main` (`4eb3c59`).
14. **Audit registration.** `code/src/scripts/audits/CONTEXT.md` measures 299 of 300 lines
    (`docs-length.sh --path`, 16/10/2026) under an allowance expiring 01/12/2026 (`:8`). A new audit
    needs its inventory and requirements rows in the same change
    (`code/src/scripts/audits/CLAUDE.md:28-32`), and `shipped-readme.sh` check 4 wants every
    `audits/*.sh` in the README register (`.github/scripts/shipped-readme.sh:25`).
15. **`uvx` sites no project cooldown governs** (UV 7): `syntax-python.yml:120,155` (ruff),
    `audit-template.yml:154` (copier), `.github/scripts/shipped-ai.sh:31` (copier, offline),
    `code/src/scripts/development/template-update.sh:114` (copier fallback), `lefthook.yml:39,43`
    (ruff, spec read from `pyproject.toml`), and the two `uvx` MCP servers (`.mcp.json:4,26`).
16. **MCP servers.** Five, none versioned: `code-review-graph` and `scrapling` by `uvx`, `context7`,
    `mcp-mermaid` and `perplexity` by `npx -y` (`.mcp.json:4-27`; `.codex/config.toml:12-48`).
17. **Doctrine in force.** Images are to be pinned by digest or specific tag, never `latest`, and
    scanned before deployment with trivy, grype or Docker Scout
    (`code/docs/security/SECRETS-AND-TRANSPORT.md:67-68`); critical and high patches within 7 days
    of release (`code/docs/security/SUPPLY-CHAIN.md:37`). Audits exit 1 on findings and 2 on a
    script error or missing required tool (`code/src/scripts/audits/docs-length.sh:162`; its sibling
    `static-analysis.sh:61-65` exits 0 when its engine is absent), and an absent tool is never
    reported clean (`code/docs/GATE-REPORTING.md:29-35`).
18. **The recorded image split and its owner.** `MAP-UPSTREAM-TRACKING` N-016 (01/09/2026) settled a
    digest for the build-graph pair, a specific tag for nginx, and rolling tags accepted for
    postgres and valkey (`mut:117,221-228`); its S-03 row carries it, unbuilt (`:369`). No Renovate
    or Dependabot configuration is tracked (`git ls-files`).

## Corrections to the 14/10/2026 brief

Claims **CO** 1 to 7. The brief is `handoffs/HANDOFF-IMAGE-SCANNING-14-10-2026.md` as committed at
`73fd24d`, 112 lines; the working copy adds 12 lines after line 93, so its later line numbers differ
(`git diff`).

1. **Trivy was one incident in three phases** (brief `:38-40`, two compromises on 28/02/2026 and
   19/03/2026). Trivy's own account puts the first access, and the theft of credentials, on
   27/02/2026, through a workflow using `pull_request_target`, with `hackerbot-claw` activity and
   further exfiltration on 28/02/2026. On 19/03/2026 a malicious v0.69.4 was released, 76 of 77
   `trivy-action` tags were force-pushed and all 7 `setup-trivy` tags replaced; on 22/03/2026 two
   malicious images (`0.69.5`, `0.69.6`) were pushed to Docker Hub with separately compromised
   credentials. The advisory treats March as a
   continuation of the February attack. (GHSA-69fq-xp46-6x23, CVE-2026-33634, critical, published
   21/03/2026; `aquasecurity/trivy` discussion #10462, timeline items 1-10)
2. **The Debian noise is wont-fix, and it is not only Low and Medium** (brief `:79-80`). The base's
   unfixed matches include 54 High wont-fix and 1 High not-fixed (GM 1); **High and Critical with a
   fix** is 0 on the base, so that threshold passes it today, while Low and above with a fix is 2,
   both CPython CPE matches fixed only in 3.15 pre-releases (GM 2). The same High-with-fix threshold
   fails all three Alpine service images on one zlib advisory (GM 3).
3. **The archive hash is already signed** (brief `:44-45` proposes a `.grype-version` holding a
   version and a SHA-256). _(reasoned)_ Checking the bundle and then the archive against the signed
   `checksums.txt` gives archive integrity without a separate hash, provided the release cannot be
   replaced: the signed file lists each archive's hash (GI 4), the signing identity is the release
   workflow on `main` rather than a tag (GI 3), and GitHub marks every release from v0.103.0
   immutable (GI 1). Whether the pin file carries a hash is the map's decision. Separately, the
   opengrep recipe does not transfer as written: Grype has signed with a bundle since v0.120.0,
   which needs `--bundle` (GI 2, GI 5).
4. **Grype's exit codes are inverted** (brief `:88-89` frames the missing-tool case as exit 2 or 0).
   Grype's 2 on findings and 1 on error (GM 9) are the reverse of the audits' 1 and 2 (RE 17).
5. **Five MCP servers, not three** (brief `:102-103` leaves MCP pins with S-03). S-03 and the census
   count three (`mut:181,268,278,369`); `.mcp.json` and `.codex/config.toml` declare five, none
   versioned (RE 16).
6. **Line drift.** The brief's `GAPS.md:298` (`:57`) is `HEAD:GAPS.md:303`. Its `:226` and `:133` in
   `audit-deps.yml` still hold: the fail step is at `:226`, and the Rust leg's comment block at
   `:133` precedes its first step at `:139`.
7. **What still holds.** Grype refuses a stale database (GI 11), and its rules do carry a `reason`,
   though no expiry (GI 13). No distribution compromise is on record; its one advisory is a
   vulnerability fixed in 0.104.1 (GI 8).

## Sources

Read on 16/10/2026 at the pins in the citation keys; the licence position follows each dash.

- **Permissive, reworded, nothing quoted** — Grype v0.120.1 and its `install.sh`, the
  oss.anchore.com pages (`anchore/oss-docs`) and the `grype-db` publisher workflow (Apache-2.0);
  `anchore/scan-action` v7.4.2 (MIT); `sigstore/cosign-installer` (Apache-2.0); uv 0.13.1 source,
  changelogs and docs (`MIT OR Apache-2.0`), with https://docs.astral.sh/uv/reference/settings/;
  `astral-sh/setup-uv` at `20cfd1bf` (MIT); pnpm 11.25.0 source and https://pnpm.io/settings,
  https://pnpm.io/settings/dependency-resolution and https://pnpm.io/cli/update (`pnpm/pnpm` and
  `pnpm/pnpm.io`, MIT); `expo/expo` at `396da464` (`sdk-57`) and its `docs/pages/more/expo-cli.mdx`
  at `112612b8`, the source of https://docs.expo.dev/more/expo-cli/ (MIT).
- **Attribution licence, reworded, nothing quoted** — GitHub Docs (`github/docs` content, CC BY
  4.0):
  https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows,
  https://docs.github.com/en/actions/reference/workflows-and-actions/dependency-caching,
  https://docs.github.com/en/actions/reference/runners/github-hosted-runners and
  https://docs.github.com/en/actions/reference/limits. Nothing is shared or adapted, so no
  attribution is owed.
- **No grant, facts only** — pnpm's GitHub release notes v11.0.0, v11.1.3, v11.3.0, v11.18.0 and
  v11.22.0; uv PR #19022; `actions/runner-images` issues #14492 and #14748; `anchore/scan-action`
  issue #778; Trivy advisory GHSA-69fq-xp46-6x23 and discussion #10462; Grype advisory
  GHSA-6gxw-85q2-q646
  (GitHub user content); https://expo.dev/changelog/sdk-58, the `api.expo.dev` v2 responses, npm
  registry records, `ghcr.io` manifests, `latest.json`, and GitHub API records for rulesets, runs,
  issues, caches and releases (service terms).
- **Measured, not read as text** — the five registry images in `G`, the Grype v0.120.1 release
  files, and the CI log of job 116010956614.
- **This repository at `73fd24d`** — the paths cited per claim; `git grep`, `git ls-files`,
  `git log`, `xxd` and `docs-length.sh --path` as measurements.

**Measured: nothing quoted.** On 16/10/2026 the whole note (body, tables, _Sources_ and _Feeds_) had
its curly quotes straightened and full URLs removed, was lowercased, and was split on every
non-alphanumeric character into word five-grams. These were compared with 67 source copies kept
whole: each cited web page fetched with `curl` and read five ways (raw, tags stripped, visible text,
attribute values, script contents), the GitHub files, release notes, issue, discussion and advisory
bodies through `gh api`, the `api.expo.dev` and `latest.json` responses, and Grype's own `--help`,
`config` and `version` output, 151 text views in all, by a script run with `python3 -I` from a fresh
`mktemp -d` directory. Earlier counts the same day found 30 runs of prose shared with a source and a
handful straddling a backticked name; each was reworded and the count redone. After the independent
review the revised note was measured again, with pnpm's v11.3.0 notes and fresh copies of Anchore's
filtering guide and scan-action issue #778 added to the set. **Result:** 33 of 8,257 distinct
five-grams are shared: 31 inside or touching a backticked identifier, flag, path, locator, timestamp
or version, and 2 runs of numerals from the count cells of the GM table, which are all that remain
once backticked spans are removed (6,194 distinct). No sentence of prose is shared with any source,
permissive or no-grant.

## Feeds

`project-management/src/01-FEATURE-MAPS/MAP-PIN-DETECT-MOVE.md` — written alongside this note. No
ADR or `STORY-PLAN-US###` exists yet; each links back here by path when it does.

- **S-01 'Pin and move'** — mainly _pnpm 11 - cooldown and exact saves_, _uv - cooldown, exact
  bounds and the version guard_ and _Expo - exact pins against the cooldown_ (the rule's cooldowns,
  exact saves and exceptions); _The repository today_ RE 1-3 and RE 10-16 (exact manifests, image
  tags and digests, `UV_VERSION`, `uvx`, action SHAs, MCP servers); UV 10 (uv digests); GI 1-6 (the
  scanner's own pin and verification).
- **S-02 'Detect'** — mainly _Measured - Grype against the base and service images_, _Grype -
  install, verification, database and ignore rules_ (GI 7-17) and _CI - where a scan can run, and
  what it costs_; _The repository today_ RE 4-9, RE 14 and RE 17 (image builds, the required set,
  the nightly and its issue, the pre-PR sweep, audit registration, exit codes).
- **Both** — _Corrections to the 14/10/2026 brief_.

`MAP-UPSTREAM-TRACKING` — a pointer only; this note does not amend it. RE 18 and CO 5 restate what
its N-016, census and S-03 row recorded at `73fd24d`.
