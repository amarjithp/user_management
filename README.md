# User Management Flutter App

## Project Overview

This Flutter app demonstrates a user management system with API integration, offline caching, and theming support. It fetches user data from a remote API and caches it locally using Hive for offline access. The app uses the BLoC pattern for state management, ensuring a clean separation between business logic and UI.

---

## Features

- Fetch users from remote API with pagination and search
- Fetch user posts and todos on user selection
- Offline caching of user data using Hive
- Automatic fallback to cached data if API is unavailable
- Light and dark theme support with runtime switching
- Clean and modular architecture with separation of concerns

---

## Setup Instructions

### Prerequisites

- Flutter SDK (>= 3.x)
- Dart SDK
- An IDE (VS Code, Android Studio, etc.)
- Internet connection to fetch packages

### Steps

1. **Clone the repository**

   ```bash
   git clone https://github.com/amarjithp/user_management.git
   cd user_management
 
2. **Install dependencies**

   ```bash
   flutter pub get

3. **Run the app**

   ```bash
   flutter run

# 🧩 Architecture Overview

The project follows a clean layered architecture:

---

## 📁 Data Layer

- `models/`: Data classes (e.g., `User`) annotated with `@HiveType`  
- `services/`: Handles all API calls and caching logic (e.g., `UserService`)  
- Hive boxes used to persist user data locally for offline support  

---

## ⚙️ Business Logic Layer

- `bloc/`: Handles application state using `flutter_bloc`  
- **UserBloc**: Handles user fetching, caching, and search  
- **ThemeCubit**: Manages light/dark mode switching  

---

## 🎨 Presentation Layer

- `screens/`: UI screens like user list  
- `widgets/`: Reusable components  
- Reacts to Bloc/Cubit state changes to keep UI in sync  

---

## 📴 Offline Caching with Hive

- When users are fetched from the API, they are saved to a Hive box (`userBox`).  
- If an error occurs during fetch (e.g., no internet), the app loads users from Hive.  
- This fallback ensures a smooth offline experience for the user.  
- Hive initialization and box opening are done in `main.dart`.  

---

## 📚 Technologies Used

- Flutter  
- Hive for local storage  
- flutter_bloc for state management  
- http for API calls  
