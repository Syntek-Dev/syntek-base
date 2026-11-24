# CMS and hosted-platform database support

**Last Updated**: 24/11/2026

## Question

Which databases do WordPress, Drupal, Joomla, Squarespace and Wix support, and which of them can
follow this template's PostgreSQL default? A second question rides along because D13 cites it:
how do Flutter and React Native render their UI on mobile?

## Verdict

**Only WordPress rules PostgreSQL out.** Its requirements name only MySQL and MariaDB.

- **Drupal** supports PostgreSQL officially, and so does **Joomla**.
- **Squarespace and Wix** are hosted. Neither lets the customer choose a database. Wix can attach
  an external PostgreSQL through an adaptor server that the customer deploys.
- **No primary source says Squarespace or Wix uses MySQL**, so that belief should not be written as
  fact.

So the exception list in D12 on MAP-FRAMEWORK-NEUTRAL-FOUNDATION is **WordPress** (MySQL or
MariaDB), plus **Squarespace and Wix** (no database to choose). Whether Drupal and Joomla default to
PostgreSQL is left open in N-020.

On the second question, neither Flutter nor React Native is a web wrapper, but both are a
cross-platform runtime. Flutter draws its own widgets with its own engine from Dart. React Native
drives real platform views from JavaScript. D1 and D2 rule both out as profiles.

## Claims

| #   | Claim                                                                                                                                                                                                                          | Source                                                                                                                                                                                                                                                                                              |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| C1  | WordPress (7.1.5 current) recommends MySQL 8.4+ or MariaDB 10.11+ and lists no other engine. That it does not support PostgreSQL is an inference from the list, not a statement on the page.                                   | [WordPress requirements](https://wordpress.org/about/requirements/); [version-check API](https://api.wordpress.org/core/version-check/1.7/)                                                                                                                                                         |
| C2  | Drupal 11 (11.4.13 latest stable) supports MySQL 8.0+, MariaDB 10.6+, PostgreSQL 16+ and SQLite 3.45+.                                                                                                                         | [11.4.13 INSTALL.txt](https://raw.githubusercontent.com/drupal/drupal/11.4.13/core/INSTALL.txt); [Packagist drupal/core](https://repo.packagist.org/p2/drupal/core.json)                                                                                                                            |
| C3  | Drupal 12 (12.0.0-beta2, not yet stable) raises the floors to PostgreSQL 18+ and MariaDB 10.11+.                                                                                                                               | [12.0.0-beta2 INSTALL.txt](https://raw.githubusercontent.com/drupal/drupal/12.0.0-beta2/core/INSTALL.txt)                                                                                                                                                                                           |
| C4  | Drupal's PostgreSQL driver needs the `pg_trgm` extension, and its install check fails when that extension is missing.                                                                                                          | [pgsql install tasks](https://raw.githubusercontent.com/drupal/drupal/11.x/core/modules/pgsql/src/Driver/Database/pgsql/Install/Tasks.php)                                                                                                                                                          |
| C5  | Joomla 6.2 (current) supports MySQL, MariaDB and PostgreSQL. For PostgreSQL it recommends 17.6, supports 14.0 and sets 12.0 as the minimum, through `pdo_pgsql`. The page notes that the supported column may not be enforced. | [Joomla technical requirements](https://manual.joomla.org/docs/get-started/technical-requirements/); [Joomla downloads API](https://downloads.joomla.org/api/v1/latest/cms)                                                                                                                         |
| C6  | Wix's built-in CMS collections are a document store that Wix manages, and the customer picks no engine. An external database, PostgreSQL among them, can be attached through an adaptor server the customer deploys.           | [Wix data management](https://dev.wix.com/docs/develop-websites/articles/databases/about-wix-data-management-solutions.md); [Wix external databases](https://dev.wix.com/docs/develop-websites/articles/databases/external-databases/overview/integrating-external-databases-with-your-wix-site.md) |
| C7  | Wix's Git integration and the Wix CLI keep site code in a GitHub repository that Wix creates, but the site still runs on Wix.                                                                                                  | [Wix Git integration](https://dev.wix.com/docs/develop-websites-sdk/code-your-site/developer-environments/ides/git-integration/about-git-integration-with-wix-cli.md)                                                                                                                               |
| C8  | Squarespace exposes no database. Its Developer Platform runs no server-side code, works on version 7.0 sites only, and keeps the template in a connected GitHub repository.                                                    | [Developer Platform FAQ](https://support.squarespace.com/hc/en-us/articles/206545717-Squarespace-Developer-Platform-FAQ); [Developer quick start](https://developers.squarespace.com/quick-start)                                                                                                   |
| C9  | Flutter draws every widget itself with its own engine (Impeller on native platforms), not the OS widgets. App logic is Dart, compiled ahead of time for release.                                                               | [Flutter architectural overview](https://docs.flutter.dev/resources/architectural-overview)                                                                                                                                                                                                         |
| C10 | React Native's Fabric renderer mounts real platform views (Android `ViewGroup`/`TextView`, iOS `UIView`). It drives them from JavaScript running in Hermes over JSI, and the New Architecture is on by default since 0.76.     | [Render pipeline](https://reactnative.dev/architecture/render-pipeline); [Fabric renderer](https://reactnative.dev/architecture/fabric-renderer); [Hermes](https://reactnative.dev/docs/hermes)                                                                                                     |

## Unverified

1. The drupal.org database requirements page itself, which is JavaScript-rendered. The figures come
   from Drupal core's own `INSTALL.txt` and driver source instead.
2. The range of PostgreSQL versions Wix's ready-made adaptors support. The docs say 9 to 13, the
   page is undated, and the range may be stale.
3. The internal database engines of Squarespace and Wix, which are not documented.
4. Whether Wix's Git integration is blocked on sites that use Velo packages. A search summary said
   so, but no primary page was read to confirm it.

## Sources

Primary sources were read on 24/11/2026: vendor requirements pages, Drupal core source at release
tags, the Joomla manual and downloads API, Wix's developer docs, Squarespace's help-centre article
(through its Zendesk API JSON, the same content), and the Flutter and React Native architecture
docs. An independent pass re-read them to refute each claim, and its corrections are folded in above.
Search results only located sources and are not cited. No third-party text is quoted verbatim, so no
_Influences_ row or third-party notice is owed.

## Feeds

- **D12 on MAP-FRAMEWORK-NEUTRAL-FOUNDATION** — the PostgreSQL default and its exceptions.
- **N-020 on MAP-FRAMEWORK-NEUTRAL-FOUNDATION** — whether Drupal and Joomla follow that default.
- **N-038 on MAP-FRAMEWORK-NEUTRAL-FOUNDATION** — what a hosted-platform directory can hold (C7, C8).

24/11/2026. No ADR, story or plan cites this note yet.
