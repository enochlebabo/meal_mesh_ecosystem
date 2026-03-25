# MealMesh Ecosystem

A modularized, full-stack food delivery platform featuring real-time data synchronization between customers, drivers, and vendors. Built with **Flutter**, **Firebase**, and a scalable **Monorepo** architecture.

---

## 📁 Project Structure

This repository is organized as a monorepo containing multiple Flutter applications and shared logic:

*   **`apps/meal_mesh_ios_user`**: The customer-facing iOS app for browsing restaurants and placing orders.
*   **`apps/meal_mesh_ios_driver`**: The driver app featuring live location tracking and order management.
*   **`apps/meal_mesh_web_admin`**: A centralized dashboard for platform-wide management.
*   **`apps/meal_mesh_web_restaurant`**: A dedicated portal for vendors to manage menus and incoming orders.
*   **`packages/`**: Shared business logic, UI components, and data models to ensure consistency across all platforms.
*   **`firebase/`**: Configuration files for cloud functions, security rules, and database indexing.

---

## 🛠 Core Features

*   **Real-time Tracking**: Live driver location updates using Google Maps API.
*   **Modular Architecture**: Clean separation of concerns between user, driver, and vendor domains.
*   **Cross-Platform**: Unified experience across iOS, macOS, and Web.
*   **Firebase Backend**: Secured with Firebase Auth, Firestore, and Cloud Messaging.

---

## 🚀 Getting Started

### Prerequisites
*   **Flutter SDK**: `^3.x.x`
*   **Xcode**: Required for iOS/macOS builds.
*   **Firebase CLI**: For managing backend configurations.

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com
    cd meal_mesh_ecosystem
    ```

2.  **Install dependencies**:
    Navigate to the specific app or package directory to run `pub get`:
    ```bash
    cd apps/meal_mesh_ios_driver
    flutter pub get
    ```

3.  **Native Configuration**:
    *   Place your `GoogleService-Info.plist` in the `ios/Runner` folders of the mobile apps via Xcode.
    *   Ensure your Google Maps API key is initialized in `AppDelegate.swift`.

---

## 💡 Troubleshooting Build Issues

If the app crashes or loses connection on startup:
1.  **Validate Info.plist**: Ensure all `<dict>` tags are properly closed and required privacy descriptions (Location, Camera, etc.) are present.
2.  **Verify API Keys**: Double-check that Google Maps and Firebase are properly initialized in the native code.
3.  **Deep Clean**:
    ```bash
    flutter clean
    rm -rf ios/Pods ios/Podfile.lock
    flutter pub get
    cd ios && pod install && cd ..
    flutter run
    ```

---

## 🏗 Tech Stack
*   **Languages**: Dart (75.8%), C/C++, TypeScript, HTML, Ruby.
*   **Backend**: Firebase (Firestore, Auth, Functions, Hosting).
*   **Deployment**: Vercel (Web), App Store (iOS).

