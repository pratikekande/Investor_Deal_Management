# DealFlow — Smart Investing, Simplified

> A Flutter-based investor deal management app where corporates post investment opportunities and investors browse, filter, and express interest. Built with Clean Architecture, BLoC state management, and a fully local SQLite backend.

---

## 📱 Screenshots

### Splash, Sign In & Sign Up
<table>
  <tr>
    <td align="center"><b>Splash Screen</b></td>
    <td align="center"><b>Sign In</b></td>
    <td align="center"><b>Sign Up</b></td>
  </tr>
  <tr>
    <td><img src="ScreenShots/Splash.jpeg" width="220"/></td>
    <td><img src="ScreenShots/SignIn.jpeg" width="220"/></td>
    <td><img src="ScreenShots/SignUp.jpeg" width="220"/></td>
  </tr>
</table>

### Investor — Deal Listing, Search & Filters
<table>
  <tr>
    <td align="center"><b>Deal Listing</b></td>
    <td align="center"><b>Search</b></td>
    <td align="center"><b>Filter Sheet (Default)</b></td>
    <td align="center"><b>Filter Sheet (Applied)</b></td>
  </tr>
  <tr>
    <td><img src="ScreenShots/Investor/Deal Listing.jpeg" width="220"/></td>
    <td><img src="ScreenShots/Investor/Deals - Search Bar.jpeg" width="220"/></td>
    <td><img src="ScreenShots/Investor/Deals Filtering.jpeg" width="220"/></td>
    <td><img src="ScreenShots/Investor/Deals Filtering-2.jpeg" width="220"/></td>
  </tr>
</table>

### Investor — Deal Detail, My Interests & Profile
<table>
  <tr>
    <td align="center"><b>Deal Detail (Top)</b></td>
    <td align="center"><b>Deal Detail (ROI + Risk)</b></td>
    <td align="center"><b>My Interests</b></td>
    <td align="center"><b>Investor Profile</b></td>
  </tr>
  <tr>
    <td><img src="ScreenShots/Investor/Deal Details-1.jpeg" width="220"/></td>
    <td><img src="ScreenShots/Investor/Deal Deatils-2.jpeg" width="220"/></td>
    <td><img src="ScreenShots/Investor/Intrested Deals.jpeg" width="220"/></td>
    <td><img src="ScreenShots/Investor/Investor Profile.jpeg" width="220"/></td>
  </tr>
</table>

### Corporate — Dashboard, My Deals & Profile
<table>
  <tr>
    <td align="center"><b>Corporate Dashboard</b></td>
    <td align="center"><b>My Deals</b></td>
    <td align="center"><b>Corporate Profile</b></td>
  </tr>
  <tr>
    <td><img src="ScreenShots/Corporate/Corporate Dashboard.jpeg" width="220"/></td>
    <td><img src="ScreenShots/Corporate/Corporate My Deals.jpeg" width="220"/></td>
    <td><img src="ScreenShots/Corporate/Corporate Profile.jpeg" width="220"/></td>
  </tr>
</table>

---

## 🎯 Project Overview

DealFlow is a mini investor deal management platform with two distinct user roles:

- **Corporate** — Post investment opportunities, manage deal status (Open/Close), and track investor interest from a dashboard.
- **Investor** — Browse all available deals, search and filter them, view detailed financial highlights with an ROI projection chart, and express or remove interest.

All data is persisted **100% locally** using SQLite — no internet connection or backend server is required.

---

---

## 🚀 Features

### 🔐 Authentication — Common for Both Roles
- Role-based sign up — choose **Investor** or **Corporate** at registration
- Email + password sign in with credential validation
- Session persistence via `SharedPreferences` — stay logged in across app restarts
- Auto-routing on launch: Splash → correct home screen based on saved session

### 👤 Profile — Common for Both Roles
- Avatar with initials, name, email, and role chip
- Info card displaying Name / Email / Role
- Logout button — clears session and navigates back to Sign In

---

### 📱 Investor

#### 📋 Deal Listing
- Scrollable deal cards showing: Company Name, Industry Tag, Investment Required (INR), Expected ROI (%), Risk Level, and Status
- Colour-coded risk badges: 🟢 Low / 🟡 Medium / 🔴 High
- Industry chips with a distinct colour per sector
- Simulated API delay (600ms) on data load for realistic UX

#### 🔍 Search & Filter
- Live search by company name or deal title — results update on every keystroke
- Filter bottom sheet with:
  - Industry dropdown
  - Risk level selector (All / Low / Medium / High)
  - Status selector (All / Open / Closed)
  - ROI range slider (0–100%)
- Active filter badge count shown on the filter button
- One-tap "Clear All" to reset all filters instantly
- All filtering runs **in-memory** inside `DealBloc` — no additional DB queries

#### 📄 Deal Detail
- Company header card with industry colour theming and live Open / Closed status
- Financial highlights grid: Investment Required, Expected ROI, Risk Level, Deal Status
- Deal description paragraph
- **ROI Projection line chart** powered by `fl_chart` — animated curve from JAN to DEC
- **Risk Analysis card** with colour-coded left border (🟢/🟡/🔴) matching risk level
- Sticky bottom CTA button:
  - **"I'm Interested"** → purple gradient → saves interest to SQLite
  - **"Interest Expressed ✓"** → green gradient → tap again to remove interest
  - **Locked state** for Closed deals with explanatory message

#### 🔖 My Interests
- Summary card: total deals saved + aggregated total potential investment (auto-formatted to L / Cr)
- Each interest card mirrors the deal listing card with a delete button
- Confirm-before-remove dialog to prevent accidental deletion
- Pull-to-refresh support

---

### 🏢 Corporate

#### 📊 Dashboard
- Stats row: Total Deals / Open / Closed — live from `DealBloc` state
- Investor interest counter card with a mini bar chart visualisation
- **POST NEW DEAL** CTA button with animated navigation
- Recent deals preview list (latest 2 deals)
- Market Insights banner with a custom `CustomPainter` wave background

#### 📁 Post New Deal
- Full form: Title, Company Name, Industry (dropdown), Investment Required (₹), Expected ROI (%), Risk Level selector, Description
- `TextFormField` validators on every input field
- On success: new deal is instantly prepended to the list in `DealBloc` state — no reload needed

#### 🗂️ My Deals
- Portfolio banner with Total / Open / Closed counts
- Filter pills to quickly toggle between All / Open / Closed deals
- Funding progress bar as a visual indicator per deal
- Per-deal actions with confirmation dialogs:
  - **Close Deal** — marks deal as Closed
  - **Reopen** — marks a Closed deal back to Open
  - **Delete** — permanently removes the deal

---

## 🏗️ Architecture

The project follows **Clean Architecture** with a strict 3-layer separation:

```
lib/
├── core/                          # App-wide constants and failure types
│   ├── db_constants.dart          # All SQLite table/column name constants
│   └── failures.dart              # Typed failure classes (DatabaseFailure, AuthFailure, SessionFailure)
│
├── data/                          # Data layer
│   ├── datasources/
│   │   ├── database_helper.dart           # Singleton SQLite setup (sqflite) — creates users, deals, interests tables
│   │   ├── auth_local_datasource.dart     # Sign up / sign in against SQLite
│   │   ├── deal_local_datasource.dart     # CRUD for deals with simulated delay
│   │   ├── interest_local_datasource.dart # CRUD for investor interests
│   │   └── shared_preferences.dart        # Session persistence (save / get / clear)
│   ├── dummy_data/
│   │   └── dummy_deals.dart       # 3 hardcoded seed deals (always visible, negative IDs)
│   ├── models/
│   │   ├── deal_model.dart        # DealModel with toMap() / fromMap() for SQLite
│   │   ├── interest_model.dart    # InterestModel with toMap() / fromMap()
│   │   └── user_model.dart        # UserModel with toMap() / fromMap()
│   └── repository/
│       ├── auth_repository_impl.dart      # Implements AuthRepository, maps Model ↔ Entity
│       ├── deal_repository_impl.dart      # Implements DealRepository
│       └── interest_repository_impl.dart  # Implements InterestRepository
│
├── domain/                        # Business logic layer — no Flutter/sqflite imports
│   ├── entities/
│   │   ├── deal_entity.dart       # Pure Dart deal entity
│   │   ├── interest_entity.dart   # Pure Dart interest entity
│   │   └── user_entity.dart       # Pure Dart user entity
│   ├── repositories/
│   │   ├── auth_repository.dart   # Abstract AuthRepository interface
│   │   ├── deal_repository.dart   # Abstract DealRepository interface
│   │   └── interest_repository.dart # Abstract InterestRepository interface
│   └── usecases/
│       ├── auth_usecases.dart     # GetSession, SignIn, SignUp, SignOut
│       └── deals_usecases.dart    # GetAllDeals, GetMyDeals, PostDeal, UpdateStatus, Delete, CheckInterest, ExpressInterest, RemoveInterest, GetMyInterests
│
├── presentation/                  # UI layer
│   ├── bloc/
│   │   ├── auth/                  # AuthBloc — CheckSession, SignIn, SignUp, SignOut
│   │   ├── deal/                  # DealBloc — load, post, update, delete, search, filter
│   │   └── interest/              # InterestBloc — load, express, remove, check
│   ├── screens/
│   │   ├── auth/                  # SignInScreen, SignUpScreen
│   │   ├── corporate/             # CorporateBottomNav, DealDashboard, MyDeals, PostDeal, CorporateProfile
│   │   ├── investor/              # InvestorBottomNav, DealListing, DealDetail, MyInterests, InvestorProfile
│   │   └── splash/                # SplashScreen
│   └── widgets/
│       └── filter_bottom_sheet.dart  # Reusable filter sheet widget
│
├── injection_container.dart       # GetIt dependency injection — wires all layers
└── main.dart                      # App entry point
```

---

## 🧠 Architecture & Key Decisions

### 1. Clean Architecture — Why?
The project strictly separates **Domain**, **Data**, and **Presentation** layers. The domain layer has zero Flutter or SQLite imports — it only contains pure Dart entities, repository interfaces, and use cases. This means business rules are completely decoupled from the database or UI framework, making them independently testable and easy to swap implementations.

### 2. BLoC for State Management
Three BLoCs manage all meaningful state:

| BLoC | Responsibility |
|---|---|
| `AuthBloc` | Session check on launch, sign in, sign up, sign out |
| `DealBloc` | Load deals, post, update status, delete, in-memory search & filter |
| `InterestBloc` | Load interests, express, remove, check per-deal interest status |

BLoC was chosen over `setState` or `Provider` because it enforces a clean event → state flow, makes loading/error/success states explicit, and keeps all business logic out of widget trees.

---

## 🛠️ Tech Stack

| Category | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | flutter_bloc + equatable |
| Local Database | sqflite (SQLite) |
| Session Storage | shared_preferences |
| Charts | fl_chart |
| Dependency Injection | get_it |
| Architecture | Clean Architecture (Domain / Data / Presentation) |
| IDE | VS Code |
| Version Control | Github |

---

## 📦 Key Dependencies

```yaml
dependencies:
  flutter_bloc: # BLoC state management
  equatable:    # Value equality for BLoC states/events
  sqflite:      # SQLite local database
  path:         # Database path helper
  shared_preferences: # Session persistence
  fl_chart:     # ROI Projection line chart
  get_it:       # Dependency injection service locator
```

---

## ⚙️ Getting Started

### Prerequisites
- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio / VS Code with Flutter plugin

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/pratikekande/Investor_Deal_Management
cd investor_deal_management

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

> No API keys, Firebase setup, or internet connection required. The app runs entirely offline.

---

## 🧪 Test Credentials

You can register directly in the app.

> Accounts are stored locally in SQLite — register once and the session persists.

---

## 📁 Data Flow Example — Express Interest

```
User taps "I'm Interested"
        ↓
InterestBloc receives ExpressInterestEvent(InterestEntity)
        ↓
ExpressInterestUsecase.call(interest)
        ↓
InterestRepositoryImpl.expressInterest(interest)
        ↓
InterestLocalDatasourceImpl.expressInterest(InterestModel)
        ↓
DatabaseHelper.insertInterest(model) → SQLite INSERT
        ↓
InterestBloc emits InterestOperationSuccess
        ↓
UI updates button to "Interest Expressed ✓" (green)
```

---

## 📊 Database Schema

### `users`
| Column | Type | Notes |
|---|---|---|
| id | INTEGER PK | Auto-increment |
| name | TEXT | |
| email | TEXT UNIQUE | |
| password | TEXT | |
| role | TEXT | `investor` or `corporate` |

### `deals`
| Column | Type | Notes |
|---|---|---|
| id | INTEGER PK | Auto-increment |
| title | TEXT | |
| company_name | TEXT | |
| industry | TEXT | |
| investment_required | TEXT | Formatted string e.g. `₹2,50,00,000` |
| expected_roi | REAL | |
| risk_level | TEXT | `Low` / `Medium` / `High` |
| status | TEXT | `Open` / `Closed` |
| posted_by_email | TEXT | |
| posted_by_name | TEXT | |
| description | TEXT | |
| created_at | TEXT | ISO 8601 string |

### `interests`
| Column | Type | Notes |
|---|---|---|
| id | INTEGER PK | Auto-increment |
| deal_id | INTEGER | References deal |
| investor_email | TEXT | |
| + all deal fields | | Denormalised for offline read performance |
| UNIQUE | (deal_id, investor_email) | Prevents duplicates at DB level |

---

## 🗺️ App Navigation Map

```
SplashScreen
    ├── AuthAuthenticated (investor)  → InvestorBottomNav
    │       ├── [0] DealListingScreen
    │       │       └── → DealDetailScreen
    │       ├── [1] MyInterestsScreen
    │       │       └── → DealDetailScreen
    │       └── [2] InvestorProfileScreen
    │
    ├── AuthAuthenticated (corporate) → CorporateBottomNav
    │       ├── [0] DealDashboardScreen
    │       │       └── → PostNewDealScreen
    │       ├── [1] MyDealsScreen
    │       └── [2] CorporateProfileScreen
    │
    └── AuthUnauthenticated → SignInScreen
                                └── → SignUpScreen
```
