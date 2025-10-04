
import React, { useEffect, useRef } from 'react';
import { View, Animated, StyleSheet } from 'react-native';
import { colors, glassmorphismStyles } from '../styles/commonStyles';

interface Floating3DProps {
  children: React.ReactNode;
  style?: any;
  intensity?: number;
  duration?: number;
}

export default function Floating3D({ 
  children, 
  style, 
  intensity = 10, 
  duration = 3000 
}: Floating3DProps) {
  const floatAnim = useRef(new Animated.Value(0)).current;
  const rotateAnim = useRef(new Animated.Value(0)).current;
  const scaleAnim = useRef(new Animated.Value(1)).current;

  useEffect(() => {
    const startFloatingAnimation = () => {
      Animated.loop(
        Animated.sequence([
          Animated.timing(floatAnim, {
            toValue: 1,
            duration: duration,
            useNativeDriver: true,
          }),
          Animated.timing(floatAnim, {
            toValue: 0,
            duration: duration,
            useNativeDriver: true,
          }),
        ])
      ).start();
    };

    const startRotationAnimation = () => {
      Animated.loop(
        Animated.timing(rotateAnim, {
          toValue: 1,
          duration: duration * 2,
          useNativeDriver: true,
        })
      ).start();
    };

    const startScaleAnimation = () => {
      Animated.loop(
        Animated.sequence([
          Animated.timing(scaleAnim, {
            toValue: 1.05,
            duration: duration / 2,
            useNativeDriver: true,
          }),
          Animated.timing(scaleAnim, {
            toValue: 1,
            duration: duration / 2,
            useNativeDriver: true,
          }),
        ])
      ).start();
    };

    startFloatingAnimation();
    startRotationAnimation();
    startScaleAnimation();
  }, [floatAnim, rotateAnim, scaleAnim, duration]);

  const translateY = floatAnim.interpolate({
    inputRange: [0, 1],
    outputRange: [0, -intensity],
  });

  const rotate = rotateAnim.interpolate({
    inputRange: [0, 1],
    outputRange: ['0deg', '360deg'],
  });

  return (
    <Animated.View
      style={[
        styles.container,
        glassmorphismStyles.floating3D,
        {
          transform: [
            { translateY },
            { rotate },
            { scale: scaleAnim },
          ],
        },
        style,
      ]}
    >
      {children}
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    justifyContent: 'center',
  },
});
