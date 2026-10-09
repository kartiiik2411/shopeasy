# shopeasy_app

ShopEasy is a Flutter shopping app with a Firebase-backed Google sign-in flow.

## Authentication setup

1. In Firebase Console, enable **Google** under **Authentication → Sign-in
   method** and select a support email. A `CONFIGURATION_NOT_FOUND` response
   means this provider configuration is missing from the Firebase project.
2. Register the Android application ID and iOS bundle ID used by this project.
   For Android, add the signing certificate SHA-1 and SHA-256 fingerprints.
3. Download fresh `google-services.json` and `GoogleService-Info.plist` files
   after enabling Google sign-in and place them in `android/app/` and
   `ios/Runner/`, respectively. The iOS Google OAuth reversed client ID must
   also be configured as a URL scheme in the Runner target. The downloaded
   files must include the platform's Google OAuth client configuration.
4. Run `flutter pub get`, then launch with `flutter run`.

## Structure

- `lib/ui/views/`: Stacked views and viewmodels for splash, login, and home.
- `lib/domain/`: Authentication entities, repository contract, and use cases.
- `lib/data/`: Firebase implementation of the authentication repository.

Routes and dependencies are generated from `lib/app/app.dart` with
`dart run build_runner build`.
