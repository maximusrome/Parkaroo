# Parkaroo

A community-based iOS app that helps urban drivers quickly find on-street parking.

## Overview

Parkaroo is a parking marketplace that connects drivers who are leaving parking spots with those who need them. The app uses GPS technology and real-time notifications to facilitate seamless parking spot transactions between users.

## Features

### Core Functionality
- **Get Spot**: Browse available parking spots on an interactive map and reserve them using credits
- **Give Spot**: Mark your current parking spot as available when you're about to leave
- **Real-time GPS Tracking**: Precise location services using MapKit and Core Location
- **Credit System**: In-app currency for reserving parking spots
- **Instant Messaging**: Built-in chat system for communication between buyers and sellers
- **Push Notifications**: Real-time alerts for new available spots and transaction updates

### User Experience
- **Onboarding Flow**: Guided first-time user experience
- **User Authentication**: Secure Firebase Authentication with email/password
- **Profile Management**: User accounts with ratings and transaction history
- **Rating System**: Mutual rating system for buyers and sellers
- **Street Information**: Detailed parking spot descriptions and instructions

### Technical Features
- **Offline Support**: Graceful handling of network connectivity issues
- **Location Services**: Background location tracking and geofencing
- **Payment Integration**: Stripe payment processing for credit purchases
- **Analytics**: Comprehensive user behavior tracking and crash reporting
- **Force Updates**: Automatic app update enforcement for critical releases

## Tech Stack

### Frontend
- **SwiftUI**: Modern declarative UI framework
- **MapKit**: Apple's mapping and location services
- **Core Location**: GPS and location tracking
- **UserNotifications**: Push notification handling

### Backend
- **Firebase Firestore**: NoSQL cloud database
- **Firebase Authentication**: User authentication and management
- **Firebase Cloud Functions**: Serverless backend logic
- **Firebase Cloud Messaging**: Push notification delivery
- **Firebase Analytics**: User behavior tracking
- **Firebase Crashlytics**: Error monitoring and crash reporting

### Third-Party Services
- **Stripe**: Payment processing and credit system
- **CocoaPods**: Dependency management

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Models**: Data structures for users, parking spots, and transactions
- **Views**: SwiftUI views for all user interfaces
- **ViewModels**: Business logic and state management
- **Services**: Location, notification, and authentication services

## Project Structure

```
Parkaroo/
├── Parkaroo/                 # Main iOS app
│   ├── Auth/                # Authentication components
│   ├── GetSpot/             # Parking spot reservation features
│   ├── GiveSpot/            # Parking spot sharing features
│   ├── Messaging/           # Chat and communication
│   ├── Models/              # Data models
│   ├── Services/            # Core services
│   ├── ViewModels/          # Business logic
│   └── Utilities/           # Helper functions and constants
├── functions/               # Firebase Cloud Functions
└── Pods/                    # CocoaPods dependencies
```

## Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.0+
- CocoaPods

## Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/parkaroo.git
cd parkaroo
```

2. Install dependencies
```bash
pod install
```

3. Open the workspace
```bash
open Parkaroo.xcworkspace
```

4. Configure Firebase
   - Add your `GoogleService-Info.plist` to the project
   - Configure Firebase project settings

5. Configure Stripe
   - Update Stripe publishable key in `ParkarooApp.swift`

6. Build and run the project

## Configuration

### Firebase Setup
1. Create a Firebase project
2. Enable Authentication, Firestore, Cloud Functions, and Cloud Messaging
3. Download and add `GoogleService-Info.plist` to the project
4. Deploy Cloud Functions:
```bash
cd functions
npm install
firebase deploy --only functions
```

### Stripe Setup
1. Create a Stripe account
2. Update the publishable key in `ParkarooApp.swift`
3. Configure webhook endpoints for payment processing

## Usage

### For Drivers Looking for Parking
1. Open the app and navigate to "Get Spot"
2. Browse available parking spots on the map
3. Select a spot and review details
4. Use credits to reserve the spot
5. Navigate to the location and park
6. Rate the seller after parking

### For Drivers Leaving a Spot
1. Navigate to "Give Spot" when ready to leave
2. Set departure time and add street information
3. Confirm spot availability
4. Wait for a buyer to reserve your spot
5. Rate the buyer after the transaction

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is proprietary software owned by Parkaroo, LLC.

## Support

For support and questions, please contact the development team or refer to the in-app FAQ section.
