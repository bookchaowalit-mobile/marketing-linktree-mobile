# Linktree (mobile) — product notes

Describes only what exists in this repository today (2026-10-22).

## What it is

A Swift package for a link-in-bio app, and the **canonical SwiftUI template**
of the `bookchaowalit-mobile` portfolio. Six repos copy its package layout,
tab shell and CI (listed in the README).

It is not a shippable app: there is no Xcode project or app target (`@main`),
so nothing can be installed on a device yet.

## Screens (`Sources/LinktreeUI`, placeholder)

A SwiftUI `TabView` with three static tabs: **Home** (app name and tagline),
**Explore** (a single text label) and **Profile** (owner name and a link to
bookchaowalit.com). The UI does not use `LinktreeCore` yet.

## Domain logic (`Sources/LinktreeCore`, Foundation only)

- Handle rules: 3–30 chars of `a–z0–9_.`, lower-cased, leading `@` stripped,
  no leading/trailing/doubled dots.
- Link URL rules: https, mailto and tel only; bare domains get https; http and
  script/other schemes rejected.
- UTM tagging (`utm_source` / `utm_medium`) for https links, never overwriting
  existing values.
- Profile links: add, reorder (clamped), enable/disable, scheduled visibility
  windows; view and click counters with click-through rate.

Covered by XCTest in `Tests/LinktreeCoreTests` (3 files: `LinkRulesTests.swift`,
`ProfileLinkTests.swift`, `ProfileTests.swift`).

## Data

In-memory value types only. No persistence, no account, no backend, no
network calls, no analytics.

## Build and distribution status

- CI (macOS 14, Xcode 15.4 / Swift 5.10) runs `swift build` and `swift test`
  fail-closed, plus the shared security scans.
- No iOS build, no signing, no TestFlight or App Store listing.

## Not built yet

See [docs/UPGRADE-PLAN.md](docs/UPGRADE-PLAN.md): Xcode app target, profile
editor UI on top of `LinktreeCore`, backend sync.
