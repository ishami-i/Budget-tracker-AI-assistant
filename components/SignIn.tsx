
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

interface SignInProps {
  onSignUp: () => void;
  onSignInSuccess: () => void;
}

export default function SignIn({ onSignUp, onSignInSuccess }: SignInProps) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [emailFocused, setEmailFocused] = useState(false);
  const [passwordFocused, setPasswordFocused] = useState(false);

  const handleSignIn = async () => {
    if (!email || !password) {
      Alert.alert('Error', 'Please fill in all fields');
      return;
    }

    if (!email.includes('@')) {
      Alert.alert('Error', 'Please enter a valid email address');
      return;
    }

    setIsLoading(true);
    
    // Simulate API call
    setTimeout(() => {
      setIsLoading(false);
      console.log('Sign in attempt:', { email, password });
      Alert.alert('Welcome back!', 'Let&apos;s check your progress toward your savings goal.', [
        { text: 'Continue', onPress: onSignInSuccess }
      ]);
    }, 1500);
  };

  const handleSocialSignIn = (provider: string) => {
    console.log(`Sign in with ${provider}`);
    Alert.alert('Coming Soon', `${provider} sign-in will be available soon!`);
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
              <Floating3D intensity={12} duration={3000}>
                <LinearGradient
                  colors={colors.gradientGreen}
                  style={[commonStyles.logoContainer, glassmorphismStyles.neon]}
                  start={{ x: 0, y: 0 }}
                  end={{ x: 1, y: 1 }}
                >
                  <Ionicons name="calculator-outline" size={40} color="white" />
                </LinearGradient>
              </Floating3D>
              <Text style={styles.appName}>SmartBudget AI</Text>
              <Text style={styles.title}>Welcome back to SmartBudget AI</Text>
              <Text style={styles.subtitle}>Let&apos;s check your progress toward your savings goal.</Text>
            </View>

            <Card3D style={styles.formCard}>
              <View style={styles.form}>
                <View style={styles.inputContainer}>
                  <Text style={styles.inputLabel}>Email</Text>
                  <BlurView 
                    intensity={10} 
                    style={[
                      styles.inputWrapper,
                      glassmorphismStyles.glassInput,
                      emailFocused && styles.inputWrapperFocused
                    ]}
                  >
                    <Ionicons name="mail-outline" size={20} color={colors.textSecondary} style={styles.inputIcon} />
                    <TextInput
                      style={styles.input}
                      placeholder="Enter your email"
                      placeholderTextColor={colors.textSecondary}
                      value={email}
                      onChangeText={setEmail}
                      keyboardType="email-address"
                      autoCapitalize="none"
                      autoCorrect={false}
                      onFocus={() => setEmailFocused(true)}
                      onBlur={() => setEmailFocused(false)}
                    />
                  </BlurView>
                </View>

                <View style={styles.inputContainer}>
                  <Text style={styles.inputLabel}>Password</Text>
                  <BlurView 
                    intensity={10} 
                    style={[
                      styles.inputWrapper,
                      glassmorphismStyles.glassInput,
                      passwordFocused && styles.inputWrapperFocused
                    ]}
                  >
                    <Ionicons name="lock-closed-outline" size={20} color={colors.textSecondary} style={styles.inputIcon} />
                    <TextInput
                      style={styles.input}
                      placeholder="Enter your password"
                      placeholderTextColor={colors.textSecondary}
                      value={password}
                      onChangeText={setPassword}
                      secureTextEntry={!showPassword}
                      onFocus={() => setPasswordFocused(true)}
                      onBlur={() => setPasswordFocused(false)}
                    />
                    <TouchableOpacity
                      onPress={() => setShowPassword(!showPassword)}
                      style={styles.eyeIcon}
                    >
                      <Ionicons
                        name={showPassword ? "eye-outline" : "eye-off-outline"}
                        size={20}
                        color={colors.textSecondary}
                      />
                    </TouchableOpacity>
                  </BlurView>
                </View>

                <TouchableOpacity style={styles.forgotPassword}>
                  <Text style={styles.forgotPasswordText}>Forgot Password?</Text>
                </TouchableOpacity>

                <TouchableOpacity
                  style={[styles.signInButton, glassmorphismStyles.floating3D, isLoading && styles.buttonDisabled]}
                  onPress={handleSignIn}
                  disabled={isLoading}
                >
                  <LinearGradient
                    colors={colors.gradientGreen}
                    style={styles.buttonGradient}
                    start={{ x: 0, y: 0 }}
                    end={{ x: 1, y: 1 }}
                  >
                    {isLoading ? (
                      <Text style={styles.buttonText}>Signing In...</Text>
                    ) : (
                      <Text style={styles.buttonText}>Sign In</Text>
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
                    onPress={() => handleSocialSignIn('Google')}
                  >
                    <Ionicons name="logo-google" size={20} color={colors.text} />
                    <Text style={styles.socialButtonText}>Google</Text>
                  </TouchableOpacity>

                  <TouchableOpacity
                    style={[styles.socialButton, glassmorphismStyles.glassButton]}
                    onPress={() => handleSocialSignIn('Apple')}
                  >
                    <Ionicons name="logo-apple" size={20} color={colors.text} />
                    <Text style={styles.socialButtonText}>Apple</Text>
                  </TouchableOpacity>
                </View>
              </View>
            </Card3D>

            <View style={styles.footer}>
              <Text style={styles.footerText}>
                New here?{' '}
                <Text style={styles.signUpLink} onPress={onSignUp}>
                  Create an account
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
    paddingBottom: 40,
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
  forgotPassword: {
    alignSelf: 'flex-end',
    marginBottom: 32,
  },
  forgotPasswordText: {
    fontSize: 14,
    color: colors.secondary,
    fontWeight: '500',
  },
  signInButton: {
    marginBottom: 32,
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
  signUpLink: {
    color: colors.primary,
    fontWeight: '600',
  },
});
