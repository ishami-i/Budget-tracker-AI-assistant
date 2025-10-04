
import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  Alert,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { commonStyles, colors, buttonStyles, glassmorphismStyles } from '../styles/commonStyles';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import { BlurView } from 'expo-blur';
import GlassBackground from './GlassBackground';
import Floating3D from './Floating3D';
import Card3D from './Card3D';

interface SignUpProps {
  onSignIn: () => void;
  onSignUpSuccess: () => void;
}

export default function SignUp({ onSignIn, onSignUpSuccess }: SignUpProps) {
  const [fullName, setFullName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [focusedField, setFocusedField] = useState<string | null>(null);

  const handleSignUp = async () => {
    if (!fullName || !email || !password) {
      Alert.alert('Error', 'Please fill in all fields');
      return;
    }

    if (!email.includes('@')) {
      Alert.alert('Error', 'Please enter a valid email address');
      return;
    }

    if (password.length < 6) {
      Alert.alert('Error', 'Password must be at least 6 characters long');
      return;
    }

    setIsLoading(true);
    
    // Simulate API call
    setTimeout(() => {
      setIsLoading(false);
      console.log('Sign up attempt:', { fullName, email, password });
      Alert.alert('Welcome to SmartBudget AI!', 'Your account has been created successfully. Let&apos;s start building your savings plan!', [
        { text: 'Get Started', onPress: onSignUpSuccess }
      ]);
    }, 1500);
  };

  const handleSocialSignUp = (provider: string) => {
    console.log(`Sign up with ${provider}`);
    Alert.alert('Coming Soon', `${provider} sign-up will be available soon!`);
  };

  const renderInput = (
    label: string,
    value: string,
    onChangeText: (text: string) => void,
    placeholder: string,
    icon: keyof typeof Ionicons.glyphMap,
    options?: {
      secureTextEntry?: boolean;
      keyboardType?: 'default' | 'email-address';
      autoCapitalize?: 'none' | 'sentences' | 'words' | 'characters';
      showPasswordToggle?: boolean;
      onTogglePassword?: () => void;
    }
  ) => {
    const fieldKey = label.toLowerCase().replace(' ', '');
    const isFocused = focusedField === fieldKey;

    return (
      <View style={styles.inputContainer}>
        <Text style={styles.inputLabel}>{label}</Text>
        <BlurView 
          intensity={10} 
          style={[
            styles.inputWrapper,
            glassmorphismStyles.glassInput,
            isFocused && styles.inputWrapperFocused
          ]}
        >
          <Ionicons name={icon} size={20} color={colors.textSecondary} style={styles.inputIcon} />
          <TextInput
            style={styles.input}
            placeholder={placeholder}
            placeholderTextColor={colors.textSecondary}
            value={value}
            onChangeText={onChangeText}
            secureTextEntry={options?.secureTextEntry}
            keyboardType={options?.keyboardType || 'default'}
            autoCapitalize={options?.autoCapitalize || 'sentences'}
            autoCorrect={false}
            onFocus={() => setFocusedField(fieldKey)}
            onBlur={() => setFocusedField(null)}
          />
          {options?.showPasswordToggle && (
            <TouchableOpacity
              onPress={options.onTogglePassword}
              style={styles.eyeIcon}
            >
              <Ionicons
                name={options.secureTextEntry ? "eye-off-outline" : "eye-outline"}
                size={20}
                color={colors.textSecondary}
              />
            </TouchableOpacity>
          )}
        </BlurView>
      </View>
    );
  };

  return (
    <GlassBackground>
      <SafeAreaView style={styles.container}>
        <KeyboardAvoidingView
          behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
          style={styles.keyboardView}
        >
          <ScrollView
            contentContainerStyle={styles.scrollContent}
            showsVerticalScrollIndicator={false}
            keyboardShouldPersistTaps="handled"
          >
            <View style={styles.header}>
              <Floating3D intensity={12} duration={3500}>
                <LinearGradient
                  colors={colors.gradientBlue}
                  style={[commonStyles.logoContainer, glassmorphismStyles.neon]}
                  start={{ x: 0, y: 0 }}
                  end={{ x: 1, y: 1 }}
                >
                  <Ionicons name="calculator-outline" size={40} color="white" />
                </LinearGradient>
              </Floating3D>
              <Text style={styles.appName}>SmartBudget AI</Text>
              <Text style={styles.title}>Create your SmartBudget AI Account</Text>
              <Text style={styles.subtitle}>Set your income, saving goal, and let the AI help you cut costs.</Text>
            </View>

            <Card3D style={styles.formCard}>
              <View style={styles.form}>
                {renderInput(
                  'Full Name',
                  fullName,
                  setFullName,
                  'Enter your full name',
                  'person-outline',
                  { autoCapitalize: 'words' }
                )}

                {renderInput(
                  'Email',
                  email,
                  setEmail,
                  'Enter your email',
                  'mail-outline',
                  { keyboardType: 'email-address', autoCapitalize: 'none' }
                )}

                {renderInput(
                  'Password',
                  password,
                  setPassword,
                  'Create a password',
                  'lock-closed-outline',
                  {
                    secureTextEntry: !showPassword,
                    autoCapitalize: 'none',
                    showPasswordToggle: true,
                    onTogglePassword: () => setShowPassword(!showPassword)
                  }
                )}

                <TouchableOpacity
                  style={[styles.signUpButton, glassmorphismStyles.floating3D, isLoading && styles.buttonDisabled]}
                  onPress={handleSignUp}
                  disabled={isLoading}
                >
                  <LinearGradient
                    colors={colors.gradientBlue}
                    style={styles.buttonGradient}
                    start={{ x: 0, y: 0 }}
                    end={{ x: 1, y: 1 }}
                  >
                    {isLoading ? (
                      <Text style={styles.buttonText}>Creating Account...</Text>
                    ) : (
                      <Text style={styles.buttonText}>Sign Up</Text>
                    )}
                  </LinearGradient>
                </TouchableOpacity>

                <View style={styles.divider}>
                  <View style={styles.dividerLine} />
                  <Text style={styles.dividerText}>or continue with</Text>
                  <View style={styles.dividerLine} />
                </View>

                <View style={styles.socialButtons}>
                  <TouchableOpacity
                    style={[styles.socialButton, glassmorphismStyles.glassButton]}
                    onPress={() => handleSocialSignUp('Google')}
                  >
                    <Ionicons name="logo-google" size={20} color={colors.text} />
                    <Text style={styles.socialButtonText}>Google</Text>
                  </TouchableOpacity>

                  <TouchableOpacity
                    style={[styles.socialButton, glassmorphismStyles.glassButton]}
                    onPress={() => handleSocialSignUp('Apple')}
                  >
                    <Ionicons name="logo-apple" size={20} color={colors.text} />
                    <Text style={styles.socialButtonText}>Apple</Text>
                  </TouchableOpacity>
                </View>
              </View>
            </Card3D>

            <View style={styles.footer}>
              <Text style={styles.footerText}>
                Already have an account?{' '}
                <Text style={styles.signInLink} onPress={onSignIn}>
                  Sign In
                </Text>
              </Text>
            </View>
          </ScrollView>
        </KeyboardAvoidingView>
      </SafeAreaView>
    </GlassBackground>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  keyboardView: {
    flex: 1,
  },
  scrollContent: {
    flexGrow: 1,
    paddingHorizontal: 24,
  },
  header: {
    alignItems: 'center',
    paddingTop: 40,
    paddingBottom: 32,
  },
  appName: {
    fontSize: 20,
    fontWeight: '800',
    color: colors.text,
    marginBottom: 16,
    letterSpacing: 0.5,
    textShadow: '0 0 20px rgba(255, 255, 255, 0.3)',
  },
  title: {
    fontSize: 24,
    fontWeight: '800',
    color: colors.text,
    marginBottom: 8,
    textAlign: 'center',
    textShadow: '0 0 15px rgba(255, 255, 255, 0.2)',
  },
  subtitle: {
    fontSize: 16,
    color: colors.textSecondary,
    textAlign: 'center',
    lineHeight: 22,
    paddingHorizontal: 20,
  },
  formCard: {
    marginBottom: 20,
  },
  form: {
    padding: 24,
  },
  inputContainer: {
    marginBottom: 20,
  },
  inputLabel: {
    fontSize: 14,
    fontWeight: '600',
    color: colors.text,
    marginBottom: 8,
  },
  inputWrapper: {
    flexDirection: 'row',
    alignItems: 'center',
    borderRadius: 12,
    paddingHorizontal: 16,
    overflow: 'hidden',
  },
  inputWrapperFocused: {
    borderColor: colors.primary,
    boxShadow: '0 0 0 3px rgba(46, 125, 50, 0.3), 0 0 20px rgba(46, 125, 50, 0.2)',
  },
  inputIcon: {
    marginRight: 12,
  },
  input: {
    flex: 1,
    paddingVertical: 16,
    fontSize: 16,
    color: colors.text,
  },
  eyeIcon: {
    padding: 4,
  },
  signUpButton: {
    marginBottom: 32,
    marginTop: 8,
    borderRadius: 25,
    overflow: 'hidden',
  },
  buttonGradient: {
    paddingVertical: 16,
    paddingHorizontal: 32,
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 25,
  },
  buttonDisabled: {
    opacity: 0.6,
  },
  buttonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: '600',
    textShadow: '0 0 10px rgba(0, 0, 0, 0.3)',
  },
  divider: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 24,
  },
  dividerLine: {
    flex: 1,
    height: 1,
    backgroundColor: colors.border,
  },
  dividerText: {
    marginHorizontal: 16,
    fontSize: 14,
    color: colors.textSecondary,
  },
  socialButtons: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 20,
  },
  socialButton: {
    flex: 1,
    flexDirection: 'row',
    marginHorizontal: 6,
    paddingVertical: 16,
    paddingHorizontal: 20,
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 25,
  },
  socialButtonText: {
    marginLeft: 8,
    fontSize: 16,
    fontWeight: '500',
    color: colors.text,
  },
  footer: {
    alignItems: 'center',
    paddingBottom: 32,
  },
  footerText: {
    fontSize: 14,
    color: colors.textSecondary,
  },
  signInLink: {
    color: colors.primary,
    fontWeight: '600',
  },
});
