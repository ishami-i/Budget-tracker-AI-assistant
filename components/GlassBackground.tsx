
import React from 'react';
import { View, StyleSheet, Dimensions } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { colors } from '../styles/commonStyles';

const { width, height } = Dimensions.get('window');

interface GlassBackgroundProps {
  children: React.ReactNode;
}

export default function GlassBackground({ children }: GlassBackgroundProps) {
  return (
    <View style={styles.container}>
      {/* Animated background orbs */}
      <View style={styles.orbContainer}>
        <LinearGradient
          colors={['rgba(76, 175, 80, 0.3)', 'rgba(76, 175, 80, 0.1)']}
          style={[styles.orb, styles.orb1]}
        />
        <LinearGradient
          colors={['rgba(25, 118, 210, 0.3)', 'rgba(25, 118, 210, 0.1)']}
          style={[styles.orb, styles.orb2]}
        />
        <LinearGradient
          colors={['rgba(156, 39, 176, 0.3)', 'rgba(156, 39, 176, 0.1)']}
          style={[styles.orb, styles.orb3]}
        />
      </View>
      
      {/* Glass overlay */}
      <View style={styles.glassOverlay} />
      
      {/* Content */}
      <View style={styles.content}>
        {children}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  orbContainer: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
  },
  orb: {
    position: 'absolute',
    borderRadius: 200,
  },
  orb1: {
    width: 300,
    height: 300,
    top: -100,
    right: -100,
  },
  orb2: {
    width: 250,
    height: 250,
    bottom: -50,
    left: -50,
  },
  orb3: {
    width: 200,
    height: 200,
    top: height * 0.4,
    right: -80,
  },
  glassOverlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(15, 15, 35, 0.7)',
    backdropFilter: 'blur(20px)',
  },
  content: {
    flex: 1,
    zIndex: 1,
  },
});
