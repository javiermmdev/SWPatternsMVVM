
# SWPatterns: A Dragon Ball Heroes App 🌌

## Overview

SWPatterns is a mobile application that allows users to explore the fascinating world of Dragon Ball heroes and their transformations. This app follows the **MVVM (Model-View-ViewModel)** architecture, which helps separate the business logic from the user interface, making the code more modular, testable, and maintainable. 

## Installation

To set up the project locally, follow these steps:

1. Clone the repository:
    ```bash
    git clone https://github.com/javiermmdev/SWPatternsMVVM.git
    cd SWPatternsMVVM
    ```
2. Open the project in Xcode:
    ```bash
    open SWPatternsMVVM.xcodeproj
    ```
3. Build and run the app in a simulator or a physical device.

## Usage

1. Open the project in Xcode.
2. Build and run the application on your device or simulator.
3. Enjoy exploring the Dragon Ball heroes and their transformations! 🎉

## Features

- **Login System**: Secure login using Basic Authentication 🔐
- **Hero List**: View a list of heroes with detailed information 🦸‍♂️
- **Transformation Details**: Explore various transformations available for each hero 🔥
- **Responsive UI**: Smooth transitions and user-friendly design 📱


## Project Structure

Here's a brief overview of the project structure:

```
SWPatterns
├── Models
│   ├── Credentials.swift
│   ├── Hero.swift
│   ├── Transformation.swift
│   └── HeroIDContainer.swift
├── Networking
│   ├── APIRequest.swift
│   ├── APISession.swift
│   ├── APIErrorResponse.swift
│   ├── APIInterceptor.swift
│   └── APIRequestInterceptor.swift
├── UseCases
│   ├── GetAllHeroesUseCase.swift
│   ├── GetSingleHeroesUseCase.swift
│   ├── GetAllTransformationsUseCase.swift
│   ├── GetSingleTransformationUseCase.swift
│   └── LoginUseCase.swift
├── ViewModels
│   ├── HeroesListViewModel.swift
│   ├── HeroesDetailViewModel.swift
│   ├── LoginViewModel.swift
│   ├── SplashViewModel.swift
│   └── TransformationListViewModel.swift
│   └── TransformationDetailViewModel.swift
├── Views
│   ├── HeroesListViewController.swift
│   ├── HeroesDetailViewController.swift
│   ├── LoginViewController.swift
│   ├── SplashViewController.swift
│   ├── TransformationListViewController.swift
│   └── TransformationDetailViewController.swift
├── Resources
│   ├── Assets.xcassets
│   ├── LaunchScreen.storyboard
│   └── Main.storyboard
└── Supporting Files
    ├── AppDelegate.swift
    └── SceneDelegate.swift
```

## Contributions

Contributions are welcome! If you would like to contribute, please fork the repository and create a pull request.

## License

This project is licensed under the MIT License.

## Contact

For questions or suggestions, feel free to reach out!

---
