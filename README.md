
# SWPatterns Application 🚀

SWPatterns is a mobile application designed to display heroes and their transformations from the Dragon Ball universe. It employs the **MVVM (Model-View-ViewModel)** architecture to separate concerns, enhance testability, and facilitate a clean and maintainable code structure.

## Project Structure 📁

Below is the directory structure of the project:

```
SWPatterns/
├── Models/
│   ├── Hero.swift
│   ├── Transformation.swift
│   └── Credentials.swift
├── ViewModels/
│   ├── HeroesListViewModel.swift
│   ├── HeroesDetailViewModel.swift
│   ├── LoginViewModel.swift
│   └── TransformationDetailViewModel.swift
├── Views/
│   ├── HeroesListViewController.swift
│   ├── HeroesDetailViewController.swift
│   ├── LoginViewController.swift
│   └── TransformationDetailViewController.swift
├── UseCases/
│   ├── GetAllHeroesUseCase.swift
│   ├── GetSingleHeroesUseCase.swift
│   ├── GetAllTransformationsUseCase.swift
│   └── GetSingleTransformationUseCase.swift
├── Networking/
│   ├── APIRequest.swift
│   ├── APISession.swift
│   ├── APIErrorResponse.swift
│   └── APIInterceptor.swift
└── Resources/
    ├── Assets.xcassets
    └── Info.plist
```

## Features 🌟

- **Hero List**: View all heroes available in the database with their respective details.
- **Hero Details**: Get detailed information about each hero, including their transformations.
- **Login Functionality**: Users can log in to access personalized features.
- **Transformation Details**: View specific transformations for each hero, showcasing their abilities.

## Technology Stack 🛠️

- **Swift**: The programming language used for development.
- **UIKit**: For building the user interface.
- **MVVM Architecture**: This structure promotes a clear separation of concerns:
    - **Model**: Represents the data structures (e.g., Hero, Transformation).
    - **View**: The user interface components (ViewControllers).
    - **ViewModel**: Contains the logic for managing the data and communication between the Model and the View.

## How to Run the Project 🏃‍♂️

1. Clone the repository to your local machine.
2. Open the `SWPatterns.xcodeproj` file in Xcode.
3. Build and run the application on your desired simulator or device.

## Testing 🧪

The project includes unit tests for critical functionalities, ensuring that the application behaves as expected. Use the following command to run the tests:

```
⌘ U
```

## Contribution 🤝

If you'd like to contribute to this project, feel free to submit a pull request or create an issue.

## License 📝

This project is licensed under the MIT License. See the LICENSE file for more information.

---

Feel free to explore the application, and enjoy the world of heroes and transformations! 🎉
