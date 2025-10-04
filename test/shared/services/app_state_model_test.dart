import 'package:flutter_test/flutter_test.dart';
import 'package:smartbudget_ai/shared/services/app_state_model.dart';

void main() {
  group('AppStateModel', () {
    late AppStateModel appStateModel;

    setUp(() {
      appStateModel = AppStateModel();
    });

    tearDown(() {
      appStateModel.dispose();
    });

    group('Initial State', () {
      test('should start with onboarding state', () {
        expect(appStateModel.currentState, AppState.onboarding);
      });

      test('should start with loading false', () {
        expect(appStateModel.isLoading, false);
      });

      test('should start with no error message', () {
        expect(appStateModel.errorMessage, null);
      });
    });

    group('State Transitions', () {
      test('should allow valid transition from onboarding to signIn', () {
        appStateModel.navigateToState(AppState.signIn);
        expect(appStateModel.currentState, AppState.signIn);
        expect(appStateModel.errorMessage, null);
      });

      test('should allow valid transition from signIn to signUp', () {
        appStateModel.navigateToState(AppState.signIn);
        appStateModel.navigateToState(AppState.signUp);
        expect(appStateModel.currentState, AppState.signUp);
        expect(appStateModel.errorMessage, null);
      });

      test('should allow valid transition from signIn to dashboard', () {
        appStateModel.navigateToState(AppState.signIn);
        appStateModel.navigateToState(AppState.dashboard);
        expect(appStateModel.currentState, AppState.dashboard);
        expect(appStateModel.errorMessage, null);
      });

      test('should allow valid transition from signUp to signIn', () {
        appStateModel.navigateToState(AppState.signIn);
        appStateModel.navigateToState(AppState.signUp);
        appStateModel.navigateToState(AppState.signIn);
        expect(appStateModel.currentState, AppState.signIn);
        expect(appStateModel.errorMessage, null);
      });

      test('should allow valid transition from signUp to dashboard', () {
        appStateModel.navigateToState(AppState.signIn);
        appStateModel.navigateToState(AppState.signUp);
        appStateModel.navigateToState(AppState.dashboard);
        expect(appStateModel.currentState, AppState.dashboard);
        expect(appStateModel.errorMessage, null);
      });

      test('should allow valid transition from dashboard to signIn', () {
        appStateModel.navigateToState(AppState.signIn);
        appStateModel.navigateToState(AppState.dashboard);
        appStateModel.navigateToState(AppState.signIn);
        expect(appStateModel.currentState, AppState.signIn);
        expect(appStateModel.errorMessage, null);
      });

      test('should reject invalid transition from onboarding to signUp', () {
        final initialState = appStateModel.currentState;
        appStateModel.navigateToState(AppState.signUp);
        expect(appStateModel.currentState, initialState);
        expect(appStateModel.errorMessage, isNotNull);
        expect(appStateModel.errorMessage, contains('Invalid state transition'));
      });

      test('should reject invalid transition from onboarding to dashboard', () {
        final initialState = appStateModel.currentState;
        appStateModel.navigateToState(AppState.dashboard);
        expect(appStateModel.currentState, initialState);
        expect(appStateModel.errorMessage, isNotNull);
        expect(appStateModel.errorMessage, contains('Invalid state transition'));
      });

      test('should allow transition without validation when validate is false', () {
        appStateModel.navigateToState(AppState.dashboard, validate: false);
        expect(appStateModel.currentState, AppState.dashboard);
        expect(appStateModel.errorMessage, null);
      });
    });

    group('Convenience Methods', () {
      test('completeOnboarding should navigate to signIn', () {
        appStateModel.completeOnboarding();
        expect(appStateModel.currentState, AppState.signIn);
      });

      test('navigateToSignUp should navigate to signUp from signIn', () {
        appStateModel.navigateToState(AppState.signIn);
        appStateModel.navigateToSignUp();
        expect(appStateModel.currentState, AppState.signUp);
      });

      test('navigateToSignIn should navigate to signIn from signUp', () {
        appStateModel.navigateToState(AppState.signIn);
        appStateModel.navigateToState(AppState.signUp);
        appStateModel.navigateToSignIn();
        expect(appStateModel.currentState, AppState.signIn);
      });

      test('completeAuthentication should navigate to dashboard', () {
        appStateModel.navigateToState(AppState.signIn);
        appStateModel.completeAuthentication();
        expect(appStateModel.currentState, AppState.dashboard);
      });

      test('signOut should navigate to signIn from dashboard', () {
        appStateModel.navigateToState(AppState.signIn);
        appStateModel.navigateToState(AppState.dashboard);
        appStateModel.signOut();
        expect(appStateModel.currentState, AppState.signIn);
      });
    });

    group('Loading State Management', () {
      test('should set loading state to true', () {
        appStateModel.setLoading(true);
        expect(appStateModel.isLoading, true);
      });

      test('should set loading state to false', () {
        appStateModel.setLoading(true);
        appStateModel.setLoading(false);
        expect(appStateModel.isLoading, false);
      });

      test('should notify listeners when loading state changes', () {
        bool notified = false;
        appStateModel.addListener(() {
          notified = true;
        });

        appStateModel.setLoading(true);
        expect(notified, true);
      });
    });

    group('Error Handling', () {
      test('should set error message', () {
        const errorMessage = 'Test error message';
        appStateModel.setError(errorMessage);
        expect(appStateModel.errorMessage, errorMessage);
      });

      test('should clear error message', () {
        appStateModel.setError('Test error');
        appStateModel.clearError();
        expect(appStateModel.errorMessage, null);
      });

      test('should notify listeners when error is set', () {
        bool notified = false;
        appStateModel.addListener(() {
          notified = true;
        });

        appStateModel.setError('Test error');
        expect(notified, true);
      });

      test('should notify listeners when error is cleared', () {
        appStateModel.setError('Test error');
        bool notified = false;
        appStateModel.addListener(() {
          notified = true;
        });

        appStateModel.clearError();
        expect(notified, true);
      });

      test('should not notify listeners when clearing null error', () {
        bool notified = false;
        appStateModel.addListener(() {
          notified = true;
        });

        appStateModel.clearError();
        expect(notified, false);
      });
    });

    group('Reset Functionality', () {
      test('should reset to initial state', () {
        appStateModel.navigateToState(AppState.signIn);
        appStateModel.setLoading(true);
        appStateModel.setError('Test error');

        appStateModel.reset();

        expect(appStateModel.currentState, AppState.onboarding);
        expect(appStateModel.isLoading, false);
        expect(appStateModel.errorMessage, null);
      });

      test('should notify listeners when reset', () {
        bool notified = false;
        appStateModel.addListener(() {
          notified = true;
        });

        appStateModel.reset();
        expect(notified, true);
      });
    });

    group('Async Operations', () {
      test('should handle successful async operation', () async {
        const expectedResult = 'success';
        String? actualResult;
        
        final result = await appStateModel.performAsyncOperation<String>(
          () async {
            await Future.delayed(const Duration(milliseconds: 10));
            return expectedResult;
          },
          onSuccess: (result) {
            actualResult = result;
          },
        );

        expect(result, expectedResult);
        expect(actualResult, expectedResult);
        expect(appStateModel.isLoading, false);
        expect(appStateModel.errorMessage, null);
      });

      test('should handle failed async operation', () async {
        const errorMessage = 'Operation failed';
        String? capturedError;
        
        final result = await appStateModel.performAsyncOperation<String>(
          () async {
            await Future.delayed(const Duration(milliseconds: 10));
            throw Exception(errorMessage);
          },
          onError: (error) {
            capturedError = error;
          },
        );

        expect(result, null);
        expect(capturedError, contains(errorMessage));
        expect(appStateModel.isLoading, false);
        expect(appStateModel.errorMessage, contains(errorMessage));
      });

      test('should set loading to true during async operation', () async {
        bool wasLoadingDuringOperation = false;
        
        await appStateModel.performAsyncOperation<void>(
          () async {
            wasLoadingDuringOperation = appStateModel.isLoading;
            await Future.delayed(const Duration(milliseconds: 10));
          },
        );

        expect(wasLoadingDuringOperation, true);
        expect(appStateModel.isLoading, false);
      });

      test('should clear error before starting async operation', () async {
        appStateModel.setError('Previous error');
        
        await appStateModel.performAsyncOperation<void>(
          () async {
            await Future.delayed(const Duration(milliseconds: 10));
          },
        );

        expect(appStateModel.errorMessage, null);
      });
    });

    group('Change Notification', () {
      test('should notify listeners on state change', () {
        bool notified = false;
        appStateModel.addListener(() {
          notified = true;
        });

        appStateModel.navigateToState(AppState.signIn);
        expect(notified, true);
      });

      test('should not notify listeners on invalid state transition', () {
        bool notified = false;
        appStateModel.addListener(() {
          notified = true;
        });

        appStateModel.navigateToState(AppState.dashboard); // Invalid from onboarding
        expect(notified, true); // Should notify due to error being set
      });
    });
  });
}