
import React, { useRef, useEffect } from 'react';
import { View, Animated, StyleSheet, PanGestureHandler, State } from 'react-native';
import { colors, glassmorphismStyles } from '../styles/commonStyles';

interface Card3DProps {
  children: React.ReactNode;
  style?: any;
  interactive?: boolean;
}

export default function Card3D({ children, style, interactive = true }: Card3DProps) {
  const rotateX = useRef(new Animated.Value(0)).current;
  const rotateY = useRef(new Animated.Value(0)).current;
  const scale = useRef(new Animated.Value(1)).current;

  useEffect(() => {
    // Subtle auto-rotation animation
    const autoRotate = () => {
      Animated.loop(
        Animated.sequence([
          Animated.timing(rotateY, {
            toValue: 0.1,
            duration: 2000,
            useNativeDriver: true,
          }),
          Animated.timing(rotateY, {
            toValue: -0.1,
            duration: 2000,
            useNativeDriver: true,
          }),
        ])
      ).start();
    };

    if (!interactive) {
      autoRotate();
    }
  }, [rotateY, interactive]);

  const onGestureEvent = (event: any) => {
    if (!interactive) return;

    const { translationX, translationY } = event.nativeEvent;
    const rotateYValue = translationX / 200;
    const rotateXValue = -translationY / 200;

    rotateX.setValue(rotateXValue);
    rotateY.setValue(rotateYValue);
  };

  const onHandlerStateChange = (event: any) => {
    if (!interactive) return;

    if (event.nativeEvent.state === State.BEGAN) {
      Animated.spring(scale, {
        toValue: 1.05,
        useNativeDriver: true,
      }).start();
    } else if (event.nativeEvent.state === State.END) {
      Animated.spring(scale, {
        toValue: 1,
        useNativeDriver: true,
      }).start();

      Animated.spring(rotateX, {
        toValue: 0,
        useNativeDriver: true,
      }).start();

      Animated.spring(rotateY, {
        toValue: 0,
        useNativeDriver: true,
      }).start();
    }
  };

  const CardContent = (
    <Animated.View
      style={[
        styles.card,
        glassmorphismStyles.glassCard,
        {
          transform: [
            { perspective: 1000 },
            { rotateX: rotateX.interpolate({
              inputRange: [-1, 1],
              outputRange: ['-15deg', '15deg'],
            })},
            { rotateY: rotateY.interpolate({
              inputRange: [-1, 1],
              outputRange: ['-15deg', '15deg'],
            })},
            { scale },
          ],
        },
        style,
      ]}
    >
      {children}
    </Animated.View>
  );

  if (interactive) {
    return (
      <PanGestureHandler
        onGestureEvent={onGestureEvent}
        onHandlerStateChange={onHandlerStateChange}
      >
        {CardContent}
      </PanGestureHandler>
    );
  }

  return CardContent;
}

const styles = StyleSheet.create({
  card: {
    padding: 20,
    margin: 10,
    borderRadius: 16,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
