# TaskFlow

A modern Flutter task management application with weather integration, built using MVVM clean architecture.

## Features

- **Task Management** - Create, edit, and delete tasks with priorities and due dates
- **Task Completion** - Mark tasks as complete/incomplete
- **Weather Integration** - Real-time weather information using OpenWeatherMap API
- **Authentication** - Secure user authentication with Firebase Auth
- **Cloud Storage** - Tasks stored in Firebase Firestore
- **Responsive Design** - Optimized for different screen sizes
- **Modern UI** - Clean, intuitive interface with gradient effects and glassmorphism

## Tech Stack

- **Framework**: Flutter
- **Architecture**: MVVM (Model-View-ViewModel) with Clean Architecture
- **State Management**: Provider
- **Backend**: Firebase (Authentication & Firestore)
- **Weather API**: OpenWeatherMap
- **Local Storage**: Shared Preferences

## Prerequisites

Before you begin, ensure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.0.0 or higher)
- [Dart SDK](https://dart.dev/get-dart) (3.0.0 or higher)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)
- [Git](https://git-scm.com/)
- [Firebase CLI](https://firebase.google.com/docs/cli) (for Firebase configuration)

## Project Setup

### 1. Clone the Repository

```bash
git clone git@github.com:Chanukaa2002/task_flow.git
cd task_flow
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Environment Configuration

#### Step 1: Create .env File

1. Copy the `.env.example` file to create a new `.env` file:

```bash
cp .env.example .env
```

Or on Windows:

```cmd
copy .env.example .env
```

#### Step 2: Configure Environment Variables

Open the `.env` file and add your API credentials:

```env
# OpenWeatherMap API Configuration
OPENWEATHER_API_KEY=your_openweathermap_api_key_here
OPENWEATHER_BASE_URL=https://api.openweathermap.org/data/2.5
```

**How to get OpenWeatherMap API Key:**

1. Go to [OpenWeatherMap](https://openweathermap.org/)
2. Sign up for a free account
3. Navigate to **API Keys** section
4. Copy your API key and paste it in the `.env` file

### 4. Firebase Setup

#### Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"** or select an existing project
3. Follow the setup wizard to create your project
4. Click **"Continue"** after the project is ready

#### Step 2: Enable Firebase Authentication

1. In Firebase Console, navigate to **Build** → **Authentication**
2. Click **"Get Started"**
3. Go to the **"Sign-in method"** tab
4. Enable **Email/Password** authentication
5. Click **"Save"**

#### Step 3: Create Firestore Database

1. In Firebase Console, navigate to **Build** → **Firestore Database**
2. Click **"Create database"**
3. Choose **"Start in test mode"** (for development) or **"Start in production mode"**
4. Select a Cloud Firestore location (choose closest to your users)
5. Click **"Enable"**

#### Step 4: Add Flutter App to Firebase (Using FlutterFire CLI)

Firebase now provides a **Flutter option** directly in the console that makes configuration much easier.


1. **Install FlutterFire CLI:**

```bash
dart pub global activate flutterfire_cli
```

2. **Configure Firebase for your Flutter app:**

```bash
flutterfire configure
```

3. **Follow the prompts:**

   - Select your Firebase project
   - Choose platforms (Android, iOS, Web, Windows, macOS)
   - The CLI will automatically generate `firebase_options.dart`

4. **Verify the configuration:**
   - Check that `lib/firebase_options.dart` was created
   - This file contains all Firebase configuration for all platforms

#### Step 5: Verify Firebase Configuration

Ensure the following:

- ✅ `lib/firebase_options.dart` exists
- ✅ Firebase is initialized in `lib/main.dart`
- ✅ `firebase_core` is in `pubspec.yaml` dependencies

## Running the Application

```bash
flutter run -d <platform/device> eg: windows,ios,android,edge,chorme
```
## Building for Production

### Build for Android (APK)

```bash
flutter build apk --release
```