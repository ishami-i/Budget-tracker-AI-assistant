
import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import { commonStyles, colors, glassmorphismStyles } from '../styles/commonStyles';
import GlassBackground from './GlassBackground';
import Floating3D from './Floating3D';
import Card3D from './Card3D';

interface MainAppProps {
  onLogout: () => void;
}

export default function MainApp({ onLogout }: MainAppProps) {
  const handleLogout = () => {
    console.log('User logged out');
    onLogout();
  };

  return (
    <GlassBackground>
      <SafeAreaView style={styles.container}>
        <View style={styles.header}>
          <Floating3D intensity={8} duration={4000}>
            <LinearGradient
              colors={colors.gradientGreen}
              style={[styles.logoContainer, glassmorphismStyles.neon]}
              start={{ x: 0, y: 0 }}
              end={{ x: 1, y: 1 }}
            >
              <Ionicons name="calculator-outline" size={32} color="white" />
            </LinearGradient>
          </Floating3D>
          <Text style={styles.appName}>SmartBudget AI</Text>
        </View>

        <View style={styles.content}>
          <Card3D style={styles.welcomeCard}>
            <View style={styles.cardContent}>
              <Ionicons name="checkmark-circle" size={60} color={colors.primary} style={styles.successIcon} />
              <Text style={styles.welcomeTitle}>Welcome to SmartBudget AI!</Text>
              <Text style={styles.welcomeText}>
                You&apos;re all set up and ready to start your savings journey. 
                Let&apos;s build your personalized budget plan.
              </Text>
            </View>
          </Card3D>

          <View style={styles.features}>
            <Card3D style={styles.featureCard}>
              <LinearGradient
                colors={colors.gradientGreen}
                style={styles.featureIconContainer}
                start={{ x: 0, y: 0 }}
                end={{ x: 1, y: 1 }}
              >
                <Ionicons name="wallet-outline" size={24} color="white" />
              </LinearGradient>
              <Text style={styles.featureTitle}>Set Income</Text>
              <Text style={styles.featureText}>Tell us your monthly income</Text>
            </Card3D>

            <Card3D style={styles.featureCard}>
              <LinearGradient
                colors={colors.gradientBlue}
                style={styles.featureIconContainer}
                start={{ x: 0, y: 0 }}
                end={{ x: 1, y: 1 }}
              >
                <Ionicons name="analytics-outline" size={24} color="white" />
              </LinearGradient>
              <Text style={styles.featureTitle}>AI Analysis</Text>
              <Text style={styles.featureText}>Smart expense tracking</Text>
            </Card3D>

            <Card3D style={styles.featureCard}>
              <LinearGradient
                colors={colors.gradientPurple}
                style={styles.featureIconContainer}
                start={{ x: 0, y: 0 }}
                end={{ x: 1, y: 1 }}
              >
                <Ionicons name="trending-up-outline" size={24} color="white" />
              </LinearGradient>
              <Text style={styles.featureTitle}>Save More</Text>
              <Text style={styles.featureText}>Reach your goals faster</Text>
            </Card3D>
          </View>
        </View>

        <View style={styles.footer}>
          <TouchableOpacity
            style={[styles.logoutButton, glassmorphismStyles.glassButton]}
            onPress={handleLogout}
          >
            <Ionicons name="log-out-outline" size={20} color={colors.text} />
            <Text style={styles.logoutText}>Logout</Text>
          </TouchableOpacity>
        </View>
      </SafeAreaView>
    </GlassBackground>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  header: {
    alignItems: 'center',
    paddingTop: 20,
    paddingBottom: 30,
  },
  logoContainer: {
    width: 80,
    height: 80,
    borderRadius: 40,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 16,
  },
  appName: {
    fontSize: 24,
    fontWeight: '800',
    color: colors.text,
    letterSpacing: 0.5,
    textShadow: '0 0 20px rgba(255, 255, 255, 0.3)',
  },
  content: {
    flex: 1,
    paddingHorizontal: 24,
  },
  welcomeCard: {
    marginBottom: 30,
  },
  cardContent: {
    padding: 32,
    alignItems: 'center',
  },
  successIcon: {
    marginBottom: 20,
    textShadow: '0 0 20px rgba(76, 175, 80, 0.6)',
  },
  welcomeTitle: {
    fontSize: 24,
    fontWeight: '800',
    color: colors.text,
    textAlign: 'center',
    marginBottom: 16,
    textShadow: '0 0 15px rgba(255, 255, 255, 0.2)',
  },
  welcomeText: {
    fontSize: 16,
    color: colors.textSecondary,
    textAlign: 'center',
    lineHeight: 24,
  },
  features: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    flexWrap: 'wrap',
  },
  featureCard: {
    width: '30%',
    marginBottom: 20,
  },
  featureIconContainer: {
    width: 48,
    height: 48,
    borderRadius: 24,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 12,
    alignSelf: 'center',
  },
  featureTitle: {
    fontSize: 14,
    fontWeight: '700',
    color: colors.text,
    textAlign: 'center',
    marginBottom: 4,
  },
  featureText: {
    fontSize: 12,
    color: colors.textSecondary,
    textAlign: 'center',
    lineHeight: 16,
  },
  footer: {
    paddingHorizontal: 24,
    paddingBottom: 32,
  },
  logoutButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 16,
    paddingHorizontal: 32,
    borderRadius: 25,
  },
  logoutText: {
    marginLeft: 8,
    fontSize: 16,
    fontWeight: '500',
    color: colors.text,
  },
});
