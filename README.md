# 🚀 Echo (Anonymous College App) - Flutter Frontend

This is the **Flutter frontend** for the Anonymous College App, designed to provide a private and engaging experience for students to interact under persistent anonymous identities.  
Built with **BLoC (Cubit)** for state management and follows the **MVC architecture** for clean code separation.

---

## 🛠️ Tech Stack

- **Flutter**
- **Dart**
- **BLoC (Cubit)**
- **MVC Architecture**
- **Firebase / REST API Integration (if applicable)**

---

## 📦 Getting Started

Follow these steps to set up the project on your local machine.

### 1. Clone the Repository

```bash
git clone https://github.com/<your-username>/echo.git
cd echo
```
### 2. Install the dependencies
```bash
flutter pub get
```

### 3. Set Up the Enviornment
Create a .env similar to the .env.example for the variables
#### Make sure to use Flutter varsion >=3.0.0

### 4. Run the App
```bash
flutter run
```
## 🧱 Project Structure
This project follows MVC structure organised as:
```bash
lib/
├── src/                     # Data models
    ├── core/                # Core utilities, constants, exceptions, configs
    ├── features/            # Features likr authentication profile etc.
        ├── (any feature)/
            ├── cubit/       # Here the cubits and necessary state 
            ├── model/       # Models needed for the particular feature
            ├── view/        # All the UI elements and widgets
    ├── services/      # External APIs, Auth, DB etc.
    ├── theme/         # App-wide theming and style
├── main.dart       # Entry point
```
State management is handled using Cubit (from BLoC package).

## ✅ VS Code Steup Guidelines
To ensure minimal linting issues and a consistent code style across contributors:
### 1. Enable Error Lens
Install the Error Lens extension from the VS Code Marketplace to get inline highlighting of warnings and errors.

### 2. Use Recommended Extensions

- Dart
- Flutter
- Error Lens
- Bloc
- Pubspec Assist

### 3. Enable Format on Save
In your VS Code settings.json:
```bash
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  }
}
```
## 🤝 Contributing
Curious contributions are welcome! Please follow these rules:
Branch Naming: Use clear branch names like feature/login-screen, fix/profile-bug, etc.

### 🔀 Branching
  Use feature-based naming:
  
  - **`feature/user-authentication`**
  
  - **`fix/profile-crash`**

### Commit the Code

  When committing your code, follow this commit message structure:
  
  ```less
  [Operation]: [Work] in [Module]
  ```
  
  For example:
  
  - **`Add: Login form in Auth Module`**
  - **`Fix: Error Message in Product Module`**

### Pull Request Guidelines:

  - Describe your changes clearly.

  - Link related issues (if any).

  - Make sure no lint warnings remain.

### Testing:

  - Run the app and verify core flows before pushing.

  - Make sure your feature doesn’t break existing screens.

## 📄 License
This project is under the Apache License Version 2.0.

## 🙋‍♂️ Need Help?
If you're stuck or need help understanding the project flow, feel free to raise an issue or start a discussion in the repo or Contact me through email.

## ⭐️ Show Your Support
If you like this project, please give it a ⭐️ and share it with your peers!
