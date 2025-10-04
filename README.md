# SmartBudget AI

## Testing and Coverage

- Run tests:

```bash
flutter test --coverage
```

- Check coverage threshold (90%):

```bash
dart run tool/check_coverage.dart coverage/lcov.info 0.90
```


## Build & Deployment

### Android
- Configure signing in `android/app/build.gradle` and `key.properties`.
- Build release APK/AAB:
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
- Open `ios/Runner.xcworkspace` in Xcode.
- Set signing team and provisioning profiles.
- Build archive from Xcode or:
```bash
flutter build ios --release
```

### Web (PWA)
- Build web:
```bash
flutter build web --release
```
- Configure PWA assets in `web/` if needed (manifest, icons, service worker).


