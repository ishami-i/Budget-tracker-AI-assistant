
import React, { useState, useEffect } from 'react';
import { View, StyleSheet } from 'react-native';
import { commonStyles, colors } from '../styles/commonStyles';
import Onboarding from '../components/Onboarding';
import SignIn from '../components/SignIn';
import SignUp from '../components/SignUp';
import MainApp from '../components/MainApp';

type AppState = 'onboarding' | 'signin' | 'signup' | 'main';

export default function App() {
  const [currentState, setCurrentState] = useState<AppState>('onboarding');
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    // Simulate checking for existing user session with proper error handling
    const checkUserSession = async () => {
      try {
        // In a real app, you would check AsyncStorage or secure storage
        // for existing authentication tokens
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        setIsLoading(false);
        // For demo purposes, always start with onboarding
        // In production, you might skip to 'main' if user is already authenticated
        console.log('App initialized, starting onboarding flow');
      } catch (error) {
        console.error('Error checking user session:', error);
        setIsLoading(false);
        // Fallback to onboarding on error
        console.log('Falling back to onboarding due to session check error');
      }
    };

    checkUserSession().catch(error => {
      console.error('Unhandled error in checkUserSession:', error);
      setIsLoading(false);
    });
  }, []);

  const handleOnboardingComplete = () => {
    try {
      console.log('Onboarding completed, navigating to sign in');
      setCurrentState('signin');
    } catch (error) {
      console.error('Error in handleOnboardingComplete:', error);
    }
  };

  const handleNavigateToSignUp = () => {
    try {
      console.log('Navigating to sign up');
      setCurrentState('signup');
    } catch (error) {
      console.error('Error in handleNavigateToSignUp:', error);
    }
  };

  const handleNavigateToSignIn = () => {
    try {
      console.log('Navigating to sign in');
      setCurrentState('signin');
    } catch (error) {
      console.error('Error in handleNavigateToSignIn:', error);
    }
  };

  const handleSignInSuccess = () => {
    try {
      console.log('Sign in successful, navigating to main app');
      setCurrentState('main');
    } catch (error) {
      console.error('Error in handleSignInSuccess:', error);
    }
  };

  const handleSignUpSuccess = () => {
    try {
      console.log('Sign up successful, navigating to main app');
      setCurrentState('main');
    } catch (error) {
      console.error('Error in handleSignUpSuccess:', error);
    }
  };

  const handleLogout = () => {
    try {
      console.log('User logged out, returning to sign in');
      setCurrentState('signin');
    } catch (error) {
      console.error('Error in handleLogout:', error);
    }
  };

  if (isLoading) {
    return (
      <View style={[commonStyles.container, styles.loadingContainer]}>
        {/* You could add a loading spinner here */}
      </View>
    );
  }

  try {
    switch (currentState) {
      case 'onboarding':
        return <Onboarding onComplete={handleOnboardingComplete} />;
      
      case 'signin':
        return (
          <SignIn
            onSignUp={handleNavigateToSignUp}
            onSignInSuccess={handleSignInSuccess}
          />
        );
      
      case 'signup':
        return (
          <SignUp
            onSignIn={handleNavigateToSignIn}
            onSignUpSuccess={handleSignUpSuccess}
          />
        );
      
      case 'main':
        return <MainApp onLogout={handleLogout} />;
      
      default:
        console.log('Unknown app state, falling back to onboarding');
        return <Onboarding onComplete={handleOnboardingComplete} />;
    }
  } catch (error) {
    console.error('Error rendering app state:', error);
    // Fallback to onboarding on any render error
    return <Onboarding onComplete={handleOnboardingComplete} />;
  }
}

const styles = StyleSheet.create({
  loadingContainer: {
    backgroundColor: colors.background,
  },
});
