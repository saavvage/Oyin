# Firebase Push Setup

## 1) Create Firebase project
1. Open Firebase Console.
2. Add Android app with package id from `android/app/build.gradle.kts` (`applicationId`).
3. Add iOS app with bundle id from Xcode target `Runner`.

## 2) Download platform configs
- Android: `google-services.json` -> place into `android/app/google-services.json`.
- iOS: `GoogleService-Info.plist` -> place into `ios/Runner/GoogleService-Info.plist`.

## 3) iOS capabilities in Xcode
Open `ios/Runner.xcworkspace` in Xcode and enable for Runner target:
- `Push Notifications`
- `Background Modes` -> `Remote notifications`

Also make sure APNs key/certificate is configured in Firebase Console.

## 4) Install packages
Run in project root:

```bash
flutter pub get
```

Then iOS pods:

```bash
cd ios && pod install && cd ..
```

## 5) Run and check token
On app start, `PushNotificationsService` logs FCM token to console.
Use that token for server-side push targeting.

## 6) Backend FCM configuration
In `Oyin_backend/.env` configure:

```env
FCM_ENABLED=true
FCM_SERVICE_ACCOUNT_PATH=/absolute/path/to/firebase-service-account.json
PUSH_REMINDER_SCHEDULER_ENABLED=true
PUSH_REMINDER_CHECK_INTERVAL_SECONDS=60
```

Alternative to file path:
- use `FCM_SERVICE_ACCOUNT_JSON` with one-line JSON
- or `FCM_PROJECT_ID`, `FCM_CLIENT_EMAIL`, `FCM_PRIVATE_KEY`

The app now auto-syncs the FCM token to backend (`PUT /users/me/push-token`)
after login/startup and on token refresh.

## Notes
- Without Firebase config files, app runs but push init is skipped with a debug log.
- Permission texts for camera/microphone/location/photo library are in `ios/Runner/Info.plist`.
