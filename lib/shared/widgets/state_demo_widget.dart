import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';

/// Demo widget showing how to use the AppStateModel
/// This can be used for testing and demonstration purposes
class StateDemoWidget extends StatelessWidget {
  const StateDemoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, appState, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('State Management Demo'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Current state display
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current State:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          appState.currentState.toString().split('.').last,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        if (appState.isLoading)
                          const Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              SizedBox(width: 8),
                              Text('Loading...'),
                            ],
                          ),
                        if (appState.errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Text(
                              'Error: ${appState.errorMessage}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Navigation buttons
                const Text(
                  'Navigation Actions:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => appState.completeOnboarding(),
                      child: const Text('Complete Onboarding'),
                    ),
                    ElevatedButton(
                      onPressed: () => appState.navigateToSignUp(),
                      child: const Text('Go to Sign Up'),
                    ),
                    ElevatedButton(
                      onPressed: () => appState.navigateToSignIn(),
                      child: const Text('Go to Sign In'),
                    ),
                    ElevatedButton(
                      onPressed: () => appState.completeAuthentication(),
                      child: const Text('Complete Auth'),
                    ),
                    ElevatedButton(
                      onPressed: () => appState.signOut(),
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Utility actions
                const Text(
                  'Utility Actions:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => appState.setLoading(!appState.isLoading),
                      child: Text(appState.isLoading ? 'Stop Loading' : 'Start Loading'),
                    ),
                    ElevatedButton(
                      onPressed: () => appState.setError('Test error message'),
                      child: const Text('Set Error'),
                    ),
                    ElevatedButton(
                      onPressed: () => appState.clearError(),
                      child: const Text('Clear Error'),
                    ),
                    ElevatedButton(
                      onPressed: () => appState.reset(),
                      child: const Text('Reset State'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Async operation demo
                ElevatedButton(
                  onPressed: () => _performAsyncOperation(appState),
                  child: const Text('Test Async Operation'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Demonstrate async operation with state management
  void _performAsyncOperation(AppStateModel appState) {
    appState.performAsyncOperation<String>(
      () async {
        // Simulate network delay
        await Future.delayed(const Duration(seconds: 2));
        
        // Randomly succeed or fail for demo purposes
        if (DateTime.now().millisecondsSinceEpoch % 2 == 0) {
          return 'Operation completed successfully!';
        } else {
          throw Exception('Random operation failure');
        }
      },
      onSuccess: (result) {
        // Handle success - could show a snackbar or update UI
        debugPrint('Success: $result');
      },
      onError: (error) {
        // Handle error - could show error dialog
        debugPrint('Error: $error');
      },
    );
  }
}