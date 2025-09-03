# Smart City Exploration — Technical Documentation

## Overview
The **Smart City Exploration** app enables users to search and explore cities interactively using a map.  
It processes a dataset of ~200k cities, optimizes prefix-based search, and provides responsive UI behavior in both portrait (compact) and landscape (regular) modes.

---

## Architecture

### High-level modules
- **SCBaseCore**  
  Shared domain entities and utilities. Example: `City` model, protocol definitions.

- **SCBasePersistence**  
  Local storage powered by GRDB + SQLite. Manages database migrations, city imports, search (via FTS5), and favorites.

- **SCBaseNetworking**  
  Lightweight networking layer using `URLSession`. Includes:
  - `APIClient` for making requests.
  - `Endpoint` abstraction to define REST endpoints.
  - `RequestBuilder` to assemble `URLRequest`s.
  - `NetworkError` for unified error handling.

- **SCFeatureCitySearch**  
  Feature module that manages city searching and displaying results. Provides:
  - `CitySearchView` (SwiftUI search UI).
  - `CitySearchViewModel` (search state, favorites).

- **SCFeatureMap**  
  Handles interactive map display via MapKit. Provides:
  - `MapPaneView` and `MapDetailView`.
  - `MapViewModel` for focusing on single city or preview of multiple.

- **SCFeatureHome**  
  Orchestrates features and adapts UI to device orientation:
  - **Compact (portrait/iPhone):** List → push detail map.
  - **Regular (landscape/iPad):** Split view with search + map side by side.

---

## Data Flow

1. **Startup**
   - `HomeViewModel.start()` initializes persistence (`CityStore`), networking (`APIClient`), and seeds the database if empty.

2. **Search**
   - User types → `CitySearchViewModel.search(query)` → repository (`SQLiteCityRepository`) → persistence (`CityStore.search` using FTS5).  
   - Results update in real-time.

3. **Favorites**
   - User toggles favorite → `CityStore.setFavorite()` updates DB.  
   - Persisted across launches.

4. **Map**
   - On select city → `MapViewModel.focus(city)`.  
   - On preview (landscape) → `MapViewModel.preview(cities)`.

---

## Key Technical Decisions
- **Swift Package Manager modularization**: Features and bases separated into packages for scalability with larger teams.  
- **Actors for thread safety**: `CityStore` is an actor ensuring safe DB access across concurrency.  
- **SQLite FTS5 for search**: Fast prefix-based, case-insensitive search.  
- **SwiftUI responsive layouts**: Compact vs. Regular using size classes and `GeometryReader`.

---

## Recommended Patterns
- **MVVM**: Each feature has a ViewModel binding data to SwiftUI views.  
- **Dependency Injection**: Repositories and services injected into view models, allowing for mocks in testing.  
- **Previews + Fixtures**: Local JSON fixtures used for UI previews and snapshot tests.  
- **Automated Tests**:
  - Unit Tests: Persistence (migrations, search, favorites) + Networking (stubbed endpoints).  
  - UI Tests: Orientation-aware tests with compact/regular modes.

---

## Suggested Diagrams
1. **Architecture Diagram**: Show packages/modules and dependencies.  
2. **Data Flow Diagram**: Input (query) → Repo → Store → DB → Results → UI.  
3. **Sequence Diagram**: For *“Search & Select city”* flow.
