# VikMobile iOS — SwiftUI Port

iOS port of VikMobile (MyApp) built with Swift + SwiftUI. Builds automatically via GitHub Actions — **no Mac required**.

## Quick Start (No Mac Needed)

### Step 1: Push to GitHub

```bash
cd VikMobile-iOS
git init
git add -A
git commit -m "Initial iOS port"
gh repo create VikMobile-iOS --public --source=. --push
```

### Step 2: GitHub Actions builds automatically

- Go to your repo on GitHub → **Actions** tab
- The **"Build iOS IPA"** workflow runs on every push to `main`
- Wait ~10 minutes for the build to complete

### Step 3: Download the IPA

- Click the completed workflow run
- Scroll to **Artifacts** → download **MyApp-unsigned-ipa**
- Unzip to get `MyApp-unsigned.ipa`

### Step 4: Install on iPhone via AltStore

1. Install **AltStore** on your Windows PC from [altstore.io](https://altstore.io)
2. Install **iCloud for Windows** (required by AltStore)
3. Connect your iPhone via USB cable
4. Open AltStore on your PC
5. In AltStore on your phone: **My Apps → + → select the IPA**
6. Sign in with your **free Apple ID** when prompted
7. AltStore re-signs the app and installs it

> **Note**: Free Apple IDs allow 3 sideloaded apps, valid for 7 days. Refresh via AltStore before expiry.

## How It Works

The project uses **xcodegen** to generate the Xcode project from `project.yml`, then builds an unsigned arm64 IPA on GitHub's free macOS runner. AltStore handles code signing on your Windows PC using your Apple ID.

## Project Structure

```
VikMobile-iOS/
├── .github/workflows/build-ios.yml  # CI build pipeline
├── project.yml                       # xcodegen spec (generates .xcodeproj)
├── MyApp/
│   ├── MyAppApp.swift               # App entry + TabView navigation
│   ├── Info.plist                    # App config + photo permission
│   ├── Theme/SaffronTheme.swift     # Saffron color palette (light/dark)
│   ├── Models/PhotoStorage.swift    # JPEG file persistence
│   ├── Views/
│   │   ├── HomeScreen.swift         # 4-tab photo gallery (6 slots each)
│   │   ├── AboutScreen.swift        # Profile page with photo upload
│   │   └── ProjectsScreen.swift     # Project cards with URL chips
│   └── Assets.xcassets/             # Accent color, app icon
└── README-setup.md                  # This file
```

## Manual Build (If You Have a Mac)

### Option A: Using xcodegen

```bash
brew install xcodegen
cd VikMobile-iOS
xcodegen generate
open MyApp.xcodeproj
```

Then build normally in Xcode (Cmd+R).

### Option B: Manual Xcode project

1. Open Xcode → **File → New → Project → iOS → App**
2. Product Name: `MyApp`, Interface: SwiftUI, Language: Swift
3. Delete generated `ContentView.swift` and `MyAppApp.swift`
4. Drag all files from `MyApp/` into the project navigator
5. Set deployment target to iOS 16.0
6. Build & Run

## Architecture

| File | Purpose |
|------|---------|
| `MyAppApp.swift` | `@main` entry, `TabView` with 3 tabs (Photos, Projects, About) |
| `SaffronTheme.swift` | Color palette, `SaffronColors` environment key, ViewModifiers |
| `PhotoStorage.swift` | Save/load JPEG photos in Documents directory |
| `HomeScreen.swift` | 4-tab gallery, 6 slots/tab, picker, edit, share, fullscreen |
| `AboutScreen.swift` | Profile photo, name, bio, skills, education, contact cards |
| `ProjectsScreen.swift` | 3 project cards with tappable chips that open URLs |

## Dependencies

**None** — uses only native SwiftUI and PhotosUI frameworks.

## Feature Parity with Android

- 3-tab bottom navigation (Photos, Projects, About)
- 4 sub-tabs in Photos with 6 photo slots each
- Photo picker, edit, share, and fullscreen popup
- Profile photo with camera badge
- Project cards with linked chips opening Safari
- Saffron/orange theme in both light and dark mode
- Photo persistence across app launches
