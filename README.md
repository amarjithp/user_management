# User Management Flutter App

## Project Overview

This Flutter app demonstrates a user management system with API integration, offline caching, and theming support. It fetches user data from a remote API and caches it locally using Hive for offline access. The app uses the BLoC pattern for state management, ensuring a clean separation between business logic and UI.

---

## Features

- Fetch users from remote API with pagination and search
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
   git clone https://github.com/yourusername/user_management_flutter.git
   cd user_management_flutter
