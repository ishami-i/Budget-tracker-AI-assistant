# App State Management System

This document explains how to use the app state management system implemented for the SmartBudget AI Flutter app.

## Overview

The app state management system is built using Flutter's `ChangeNotifier` and the `provider` package. It provides a centralized way to manage the application's state, including navigation flow, loading states, and error handling.

## Core Components

### AppState Enum

Defines the different states of the application:

```dart
enum AppState {
  onboarding,  // User is viewing the onboarding slides
  signIn,      // User is on the sign-in screen
  signUp,      // User is on the sign-up screen
  dashboard,   // User is on the main dashboard
}
```

### AppStateModel

The main state management class that extends `ChangeNotifier`. It provides:

- **State Management**: Track and transition between app states
- **Loading State**: Manage loading indicators during async operations
- **Error Handling**: Display and clear error messages
- **State Validation**: Ensure only valid state transitions occur

## Usage

### 1. Setting up Provider

In your app's main widget, wrap your app with `ChangeNotifierProvider`:

```dart
class SmartBudgetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppStateModel(),
      child: Consumer<AppStateModel>(
        builder: (context, appState, child) {
          return MaterialApp(
            home: _buildCurrentScreen(appState.currentState),
          );
        },
      ),
    );
  }
}
```

### 2. Consuming State in Widgets

Use `Consumer<AppStateModel>` or `Provider.of<AppStateModel>()` to access the state:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, appState, child) {
        return Column(
          children: [
            Text('Current State: ${appState.currentState}'),
            if (appState.isLoading)
              CircularProgressIndicator(),
            if (appState.errorMessage != null)
              Text('Error: ${appState.errorMessage}'),
          ],
        );
      },
    );
  }
}
```

### 3. State Transitions

#### Valid Transitions

The system enforces these valid state transitions:

- `onboarding` → `signIn`
- `signIn` → `signUp`, `dashboard`, `onboarding`
- `signUp` → `signIn`, `dashboard`
- `dashboard` → `signIn`, `onboarding`

#### Convenience Methods

Use these methods for common state transitions:

```dart
final appState = Provider.of<AppStateModel>(context, listen: false);

// Complete onboarding flow
appState.completeOnboarding(); // onboarding → signIn

// Navigate between auth screens
appState.navigateToSignUp();   // signIn → signUp
appState.navigateToSignIn();   // signUp → signIn

// Complete authentication
appState.completeAuthentication(); // signIn/signUp → dashboard

// Sign out
appState.signOut(); // dashboard → signIn
```

#### Manual State Transitions

For more control, use `navigateToState()`:

```dart
// With validation (default)
appState.navigateToState(AppState.signIn);

// Without validation (bypass validation rules)
appState.navigateToState(AppState.dashboard, validate: false);
```

### 4. Loading State Management

Manage loading states during async operations:

```dart
// Manual loading control
appState.setLoading(true);
// ... perform operation
appState.setLoading(false);

// Automatic loading with async operations
await appState.performAsyncOperation<String>(
  () async {
    // Your async operation
    return await someApiCall();
  },
  onSuccess: (result) {
    // Handle success
    print('Success: $result');
  },
  onError: (error) {
    // Handle error
    print('Error: $error');
  },
);
```

### 5. Error Handling

Display and manage error messages:

```dart
// Set an error message
appState.setError('Something went wrong');

// Clear error message
appState.clearError();

// Check for errors in UI
if (appState.errorMessage != null) {
  // Show error UI
}
```

### 6. Reset Functionality

Reset the app to its initial state:

```dart
appState.reset(); // Returns to onboarding state, clears loading and errors
```

## Best Practices

### 1. Use Context Appropriately

- Use `Provider.of<AppStateModel>(context, listen: false)` when you don't need to rebuild on state changes
- Use `Consumer<AppStateModel>` when you need to rebuild on state changes
- Use `context.read<AppStateModel>()` for one-time reads without listening

### 2. Handle Errors Gracefully

Always handle potential errors in state transitions:

```dart
try {
  appState.navigateToState(AppState.dashboard);
} catch (e) {
  // Handle invalid transition
  print('Invalid state transition: $e');
}
```

### 3. Use Async Operations Helper

Prefer `performAsyncOperation()` over manual loading state management:

```dart
// Good
await appState.performAsyncOperation(() => apiCall());

// Less ideal
appState.setLoading(true);
try {
  await apiCall();
} finally {
  appState.setLoading(false);
}
```

### 4. Validate State Transitions

Let the system validate state transitions by default, only bypass validation when absolutely necessary:

```dart
// Good - uses validation
appState.navigateToState(AppState.signIn);

// Use sparingly - bypasses validation
appState.navigateToState(AppState.dashboard, validate: false);
```

## Testing

The state management system includes comprehensive unit tests. Run them with:

```bash
flutter test test/shared/services/app_state_model_test.dart
```

### Example Test

```dart
test('should allow valid transition from onboarding to signIn', () {
  final appState = AppStateModel();
  appState.navigateToState(AppState.signIn);
  
  expect(appState.currentState, AppState.signIn);
  expect(appState.errorMessage, null);
  
  appState.dispose();
});
```

## Integration with Screens

Each screen should check the current state and respond appropriately:

```dart
Widget _buildCurrentScreen(AppState currentState) {
  switch (currentState) {
    case AppState.onboarding:
      return OnboardingScreen();
    case AppState.signIn:
      return SignInScreen();
    case AppState.signUp:
      return SignUpScreen();
    case AppState.dashboard:
      return DashboardScreen();
  }
}
```

This ensures that the UI always reflects the current application state and provides a consistent user experience.