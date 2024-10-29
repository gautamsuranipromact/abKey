# AbKey Pro

AbKey Pro is a custom keyboard application designed for iOS devices, offering enhanced keyboard functionality by allowing users to store and retrieve information on specific keys. Ideal for users who require quick access to frequently used data, AbKey Pro provides customizable key functions, backup and restore options, and an intuitive interface for seamless integration with other apps.

## Features

- **Key Storage and Retrieval**  
  - Tap the `T+` key to store information on any selected key.
  - Tap the `Tr` key to retrieve stored information from a selected key.
  - Premium users can store unlimited entries on a single key.

- **Keyboard Layouts**  
  - Choose from three customizable keyboard layouts:
    - Alphabet
    - Numeric
    - Accents
  - Each layout allows for easy switching and personalization.

- **Backup and Restore**  
  - Easily back up your saved keys and settings.
  - Restore feature enables quick retrieval of your stored keys after a reinstall or on a new device just with the backuped Database file.

- **Device Adaptivity**  
  - Custom styling and responsive layouts for both iPhone and iPad.
  - Font sizes, button images, and UI components adjust dynamically to provide the best experience across devices.

## Installation
### Prerequisites
  - Xcode installed on your machine
  - CocoaPods installed on your machine
### Steps
  1. ***[Clone the repository from Github](https://github.com/gautamsuranipromact/abKey.git)***
  2. cd abKey
  3. pod install
  4. Open the workspace and run the application.

## Usage

1. Open AbKey Pro as your keyboard in any app.
2. Use the `T+` key to store data and the `Tr` key to retrieve it.
3. Customize layouts and manage your key storage directly through the keyboard settings.

## Premium Features

- **Unlimited Key Storage:** Store unlimited entries on each key.
- **Advanced Backup and Restore:** Safeguard your data with reliable backups and easy restoration.
- **Enhanced Layouts:** More options for layout customization tailored to specific tasks and workflows.

## Development Notes

This project was developed using Swift, and follows MVC pattern folder structure:
- **Controllers**: Manage keyboard layouts, data handling and all the other feature related logic.
- **Database**: Stores key data using raw SQL queries.
- **View**: Adaptive layouts and UI elements for iPhone and iPad, with dynamic scaling.
