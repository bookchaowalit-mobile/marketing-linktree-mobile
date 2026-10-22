# Linktree — Mobile

SwiftUI app for **Linktree** — a link-in-bio profile page.

Part of [Chaowalit Greepoke](https://bookchaowalit.com)'s 101 Portfolio Projects.

## Canonical SwiftUI template

This repo **is the canonical SwiftUI template** of `bookchaowalit-mobile`
(SwiftPM package: `<Name>Core` Foundation-only logic + `<Name>UI` SwiftUI tab
shell + XCTest target, and the CI below). These repos are name-substituted
copies of it, each with its own small `Core` module (consolidation or archiving
pending owner decision D5 / BD-033):

- [`content-knowledgehub-mobile`](https://github.com/bookchaowalit-mobile/content-knowledgehub-mobile)
- [`devtools-lab-mobile`](https://github.com/bookchaowalit-mobile/devtools-lab-mobile)
- [`devtools-mcplist-mobile`](https://github.com/bookchaowalit-mobile/devtools-mcplist-mobile)
- [`education-learn-mobile`](https://github.com/bookchaowalit-mobile/education-learn-mobile)
- [`marketing-linerichmenu-mobile`](https://github.com/bookchaowalit-mobile/marketing-linerichmenu-mobile)
- [`productivity-kanban-board-mobile`](https://github.com/bookchaowalit-mobile/productivity-kanban-board-mobile)

What the product does today: [PRODUCT.md](PRODUCT.md).

## Status

This is a Swift package, not yet a shippable app:

- `Sources/LinktreeCore` — Foundation-only domain logic, unit-tested in
  `Tests/LinktreeCoreTests` (XCTest).
- `Sources/LinktreeUI` — SwiftUI tab shell (Home / Explore / Profile). It does not
  use `LinktreeCore` yet, and there is no Xcode app target (`@main`) yet.

The code is built and tested only in CI (it was written without a local Swift
toolchain). See [docs/UPGRADE-PLAN.md](docs/UPGRADE-PLAN.md).

## Core features (`LinktreeCore`)

- Handle rules (3–30 chars, `a–z0–9_.`, no leading/trailing/doubled dots, leading `@` stripped)
- Link URL rules: https, mailto and tel only; bare domains get https; http and script schemes rejected
- UTM tagging (`utm_source` / `utm_medium`) for https links without overwriting existing values
- Profile links: add, reorder, enable/disable, scheduled visibility windows
- View and click counting with click-through rate

## Tech Stack

- **UI:** SwiftUI (iOS 17+ / macOS 14+)
- **Language:** Swift 5.10 (`swift-tools-version: 5.10`, Xcode 15.4 in CI)
- **Tests:** XCTest via SwiftPM

## Getting Started

```bash
swift build
swift test          # runs LinktreeCoreTests
open Package.swift  # opens in Xcode 15+
```

CI (`.github/workflows/build.yml`, fail-closed):

1. `build` — macOS 14, `xcode-select` Xcode 15.4 (Swift 5.10), `swift build`, `swift test`
2. `security` — shared `security.yml` (gitleaks, Semgrep, OSV-Scanner, Trivy) from
   `bookchaowalit/platform-ci-workflows` v1.1.1, pinned by SHA

Test files are named `*Tests.swift` (XCTest convention); the portfolio scorecard's
test-file regex does not count that pattern.

## Related

- **Frontend:** [bookchaowalit-website/linktree-frontend](https://github.com/bookchaowalit-website/bookchaowalit-linktree-frontend)
- **Portfolio:** [bookchaowalit.com](https://bookchaowalit.com)

## License

MIT
