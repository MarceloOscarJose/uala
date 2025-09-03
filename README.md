# Smart City Exploration (iOS 17+)

An iOS application built with **SwiftUI** and modular **Swift Packages**.  
Implements the **Smart City Exploration** feature: search, preview, and explore cities interactively on a map.

---

## Modules

- **SCFeatureHome** → App entry point, adaptive layouts (compact vs regular).
- **SCFeatureCitySearch** → City search UI and logic.
- **SCFeatureMap** → Map display, city previews, and detail view.
- **SCBaseCore** → Core domain models (`City`) and shared types.
- **SCBasePersistence** → SQLite + GRDB store with FTS5 search and favorites persistence.
- **SCBaseNetworking** → Networking environment, request builder, API client.

---

## Getting Started

### Requirements
- macOS 15+
- Xcode 16.4+
- iOS 17+ (Simulator or Device)

### Run the App
1. Clone the repository:
   ```bash
   git clone https://github.com/<your-org>/SmartCityExploration.git
   cd SmartCityExploration
   ```
2. Open the workspace:
   ```bash
   open SmartCityExploration.xcworkspace
   ```
3. Select the **SmartCityExploration** scheme and run (⌘R).

### Run Tests
Run all unit and UI tests:
```bash
xcodebuild test \
  -scheme SmartCityExploration \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=18.3'
```

---

## Documentation
A detailed technical documentation (with architecture diagrams and decisions) is available in the repository:  
[📄 SmartCityExploration Documentation](docs/DOCUMENTATION.md)
