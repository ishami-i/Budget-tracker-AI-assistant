
import { StyleSheet, ViewStyle, TextStyle } from 'react-native';

export const colors = {
  primary: '#2E7D32',       // Green (growth/savings)
  secondary: '#1976D2',     // Blue (trust)
  accent: '#4CAF50',        // Light green accent
  background: '#0F0F23',    // Dark background for glassmorphism
  backgroundAlt: '#1A1A2E', // Darker background
  backgroundLight: 'rgba(255, 255, 255, 0.05)', // Glass background
  text: '#FFFFFF',          // White text for dark theme
  textSecondary: '#B0B0B0', // Light grey text
  grey: '#333333',          // Dark grey
  card: 'rgba(255, 255, 255, 0.1)', // Glass card background
  success: '#4CAF50',       // Green success
  error: '#FF5252',         // Red error
  border: 'rgba(255, 255, 255, 0.2)', // Glass border
  gradientGreen: ['#4CAF50', '#2E7D32'], // Green gradient
  gradientBlue: ['#1976D2', '#0D47A1'],  // Blue gradient
  gradientPurple: ['#9C27B0', '#673AB7'], // Purple gradient
  gradientGlass: ['rgba(255, 255, 255, 0.25)', 'rgba(255, 255, 255, 0.05)'], // Glass gradient
};

export const glassmorphismStyles = StyleSheet.create({
  glassContainer: {
    backgroundColor: 'rgba(255, 255, 255, 0.1)',
    borderRadius: 20,
    borderWidth: 1,
    borderColor: 'rgba(255, 255, 255, 0.2)',
    backdropFilter: 'blur(20px)',
    boxShadow: '0 8px 32px rgba(0, 0, 0, 0.3)',
    elevation: 8,
  },
  glassCard: {
    backgroundColor: 'rgba(255, 255, 255, 0.08)',
    borderRadius: 16,
    borderWidth: 1,
    borderColor: 'rgba(255, 255, 255, 0.15)',
    backdropFilter: 'blur(15px)',
    boxShadow: '0 4px 24px rgba(0, 0, 0, 0.25)',
    elevation: 6,
  },
  glassButton: {
    backgroundColor: 'rgba(255, 255, 255, 0.15)',
    borderRadius: 25,
    borderWidth: 1,
    borderColor: 'rgba(255, 255, 255, 0.3)',
    backdropFilter: 'blur(10px)',
    boxShadow: '0 4px 16px rgba(0, 0, 0, 0.2)',
    elevation: 4,
  },
  glassInput: {
    backgroundColor: 'rgba(255, 255, 255, 0.05)',
    borderRadius: 12,
    borderWidth: 1,
    borderColor: 'rgba(255, 255, 255, 0.1)',
    backdropFilter: 'blur(8px)',
  },
  floating3D: {
    transform: [
      { perspective: 1000 },
      { rotateX: '5deg' },
      { rotateY: '5deg' },
      { translateZ: 10 }
    ],
    boxShadow: '0 20px 40px rgba(0, 0, 0, 0.4), 0 0 0 1px rgba(255, 255, 255, 0.1)',
    elevation: 12,
  },
  neon: {
    boxShadow: '0 0 20px rgba(76, 175, 80, 0.6), 0 0 40px rgba(76, 175, 80, 0.4), 0 0 60px rgba(76, 175, 80, 0.2)',
    borderColor: 'rgba(76, 175, 80, 0.8)',
    borderWidth: 1,
  },
});

export const buttonStyles = StyleSheet.create({
  primary: {
    backgroundColor: 'transparent',
    borderRadius: 25,
    paddingVertical: 16,
    paddingHorizontal: 32,
    alignItems: 'center',
    justifyContent: 'center',
    ...glassmorphismStyles.glassButton,
  },
  secondary: {
    backgroundColor: 'transparent',
    borderRadius: 25,
    paddingVertical: 16,
    paddingHorizontal: 32,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 2,
    borderColor: colors.primary,
    ...glassmorphismStyles.glassButton,
  },
  social: {
    backgroundColor: 'rgba(255, 255, 255, 0.08)',
    borderRadius: 25,
    paddingVertical: 16,
    paddingHorizontal: 32,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    borderColor: 'rgba(255, 255, 255, 0.15)',
    backdropFilter: 'blur(10px)',
    boxShadow: '0 4px 16px rgba(0, 0, 0, 0.2)',
    elevation: 4,
  },
  startSaving: {
    backgroundColor: 'transparent',
    borderRadius: 25,
    paddingVertical: 18,
    paddingHorizontal: 40,
    alignItems: 'center',
    justifyContent: 'center',
    ...glassmorphismStyles.glassButton,
    ...glassmorphismStyles.neon,
  },
  floating: {
    ...glassmorphismStyles.floating3D,
  },
});

export const commonStyles = StyleSheet.create({
  wrapper: {
    backgroundColor: colors.background,
    width: '100%',
    height: '100%',
  },
  container: {
    flex: 1,
    backgroundColor: colors.background,
    width: '100%',
    height: '100%',
  },
  content: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    maxWidth: 400,
    width: '100%',
    paddingHorizontal: 24,
  },
  title: {
    fontSize: 32,
    fontWeight: '800',
    textAlign: 'center',
    color: colors.text,
    marginBottom: 12,
    lineHeight: 40,
    textShadow: '0 0 20px rgba(255, 255, 255, 0.3)',
  },
  subtitle: {
    fontSize: 18,
    fontWeight: '600',
    textAlign: 'center',
    color: colors.text,
    marginBottom: 8,
    lineHeight: 24,
  },
  text: {
    fontSize: 16,
    fontWeight: '400',
    color: colors.textSecondary,
    marginBottom: 8,
    lineHeight: 24,
    textAlign: 'center',
  },
  section: {
    width: '100%',
    alignItems: 'center',
    paddingHorizontal: 20,
  },
  buttonContainer: {
    width: '100%',
    alignItems: 'center',
    paddingHorizontal: 20,
  },
  card: {
    ...glassmorphismStyles.glassCard,
    padding: 20,
    marginVertical: 8,
    width: '100%',
  },
  input: {
    ...glassmorphismStyles.glassInput,
    paddingVertical: 16,
    paddingHorizontal: 16,
    fontSize: 16,
    color: colors.text,
    marginBottom: 16,
  },
  inputFocused: {
    borderColor: colors.primary,
    boxShadow: '0 0 0 3px rgba(46, 125, 50, 0.3), 0 0 20px rgba(46, 125, 50, 0.2)',
  },
  icon: {
    width: 60,
    height: 60,
    tintColor: colors.primary,
  },
  logoContainer: {
    width: 100,
    height: 100,
    borderRadius: 50,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 24,
    ...glassmorphismStyles.floating3D,
  },
  glassBackground: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(15, 15, 35, 0.8)',
    backdropFilter: 'blur(20px)',
  },
});
