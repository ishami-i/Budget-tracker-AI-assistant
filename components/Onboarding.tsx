
import React, { useState, useRef, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  Dimensions,
  ScrollView,
  TouchableOpacity,
  Animated,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { commonStyles, colors, buttonStyles, glassmorphismStyles } from '../styles/commonStyles';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import { BlurView } from 'expo-blur';
import GlassBackground from './GlassBackground';
import Floating3D from './Floating3D';
import Card3D from './Card3D';

const { width: screenWidth } = Dimensions.get('window');

interface OnboardingSlide {
  id: number;
  title: string;
  subtitle: string;
  icon: keyof typeof Ionicons.glyphMap;
  gradient: string[];
}

const slides: OnboardingSlide[] = [
  {
    id: 1,
    title: 'Start With Your Income',
    subtitle: 'Tell us your monthly income and how much you want to save.',
    icon: 'wallet-outline',
    gradient: colors.gradientGreen,
  },
  {
    id: 2,
    title: 'AI Finds Smart Cut-Offs',
    subtitle: 'We look at your expenses and suggest where you can cut back — like dining out, transport, or subscriptions.',
    icon: 'analytics-outline',
    gradient: colors.gradientBlue,
  },
  {
    id: 3,
    title: 'Reach Your Savings Goal',
    subtitle: 'We help you stay on track to save 10%, 20%, or more each month.',
    icon: 'trending-up-outline',
    gradient: colors.gradientGreen,
  },
  {
    id: 4,
    title: 'Your Money, Your Rules',
    subtitle: 'You decide what&apos;s flexible and what&apos;s not. We only suggest realistic changes.',
    icon: 'options-outline',
    gradient: colors.gradientPurple,
  },
];

interface OnboardingProps {
  onComplete: () => void;
}

export default function Onboarding({ onComplete }: OnboardingProps) {
  const [currentIndex, setCurrentIndex] = useState(0);
  const scrollViewRef = useRef<ScrollView>(null);
  const scrollX = useRef(new Animated.Value(0)).current;
  const autoSlideTimer = useRef<NodeJS.Timeout | null>(null);

  // Auto-slide functionality
  useEffect(() => {
    const startAutoSlide = () => {
      if (autoSlideTimer.current) {
        clearTimeout(autoSlideTimer.current);
      }
      
      autoSlideTimer.current = setTimeout(() => {
        if (currentIndex < slides.length - 1) {
          const nextIndex = currentIndex + 1;
          setCurrentIndex(nextIndex);
          scrollViewRef.current?.scrollTo({
            x: nextIndex * screenWidth,
            animated: true,
          });
          console.log(`Auto-sliding to slide ${nextIndex + 1}`);
        } else {
          // Auto-complete onboarding after the last slide
          console.log('Auto-completing onboarding after final slide');
          onComplete();
        }
      }, 4000);
    };

    startAutoSlide();

    // Cleanup timer on unmount or when currentIndex changes
    return () => {
      if (autoSlideTimer.current) {
        clearTimeout(autoSlideTimer.current);
      }
    };
  }, [currentIndex, onComplete]);

  const handleSkip = () => {
    try {
      console.log('Onboarding skipped');
      if (autoSlideTimer.current) {
        clearTimeout(autoSlideTimer.current);
      }
      onComplete();
    } catch (error) {
      console.error('Error in handleSkip:', error);
    }
  };

  const handleScroll = (event: any) => {
    try {
      const contentOffsetX = event.nativeEvent.contentOffset.x;
      const index = Math.round(contentOffsetX / screenWidth);
      
      if (index !== currentIndex) {
        setCurrentIndex(index);
        console.log(`Manual scroll to slide ${index + 1}`);
        
        // Reset auto-slide timer when user manually scrolls
        if (autoSlideTimer.current) {
          clearTimeout(autoSlideTimer.current);
        }
      }
    } catch (error) {
      console.error('Error in handleScroll:', error);
    }
  };

  const renderSlide = (slide: OnboardingSlide, index: number) => (
    <View key={slide.id} style={styles.slide}>
      <View style={styles.logoSection}>
        <Floating3D intensity={8} duration={4000}>
          <LinearGradient
            colors={colors.gradientGreen}
            style={[styles.appLogoContainer, glassmorphismStyles.floating3D]}
            start={{ x: 0, y: 0 }}
            end={{ x: 1, y: 1 }}
          >
            <Ionicons name="calculator-outline" size={32} color="white" />
          </LinearGradient>
        </Floating3D>
        <Text style={styles.appName}>SmartBudget AI</Text>
      </View>

      <Card3D interactive={false} style={styles.iconCard}>
        <LinearGradient
          colors={slide.gradient}
          style={[styles.iconContainer, glassmorphismStyles.neon]}
          start={{ x: 0, y: 0 }}
          end={{ x: 1, y: 1 }}
        >
          <Ionicons name={slide.icon} size={80} color="white" />
        </LinearGradient>
      </Card3D>
      
      <View style={[styles.textContainer, glassmorphismStyles.glassCard]}>
        <Text style={styles.title}>{slide.title}</Text>
        <Text style={styles.subtitle}>{slide.subtitle}</Text>
      </View>

      {/* Show "Get Started" button only on the last slide */}
      {index === slides.length - 1 && (
        <TouchableOpacity
          style={[
            buttonStyles.startSaving,
            styles.getStartedButton,
            glassmorphismStyles.floating3D,
          ]}
          onPress={() => {
            try {
              console.log('Get Started button pressed');
              if (autoSlideTimer.current) {
                clearTimeout(autoSlideTimer.current);
              }
              onComplete();
            } catch (error) {
              console.error('Error in Get Started button:', error);
            }
          }}
        >
          <LinearGradient
            colors={colors.gradientGreen}
            style={styles.buttonGradient}
            start={{ x: 0, y: 0 }}
            end={{ x: 1, y: 1 }}
          >
            <Text style={styles.getStartedButtonText}>Get Started</Text>
          </LinearGradient>
        </TouchableOpacity>
      )}
    </View>
  );

  const renderPagination = () => (
    <View style={[styles.pagination, glassmorphismStyles.glassContainer]}>
      {slides.map((_, index) => (
        <TouchableOpacity
          key={index}
          style={[
            styles.dot,
            index === currentIndex ? styles.activeDot : styles.inactiveDot,
          ]}
          onPress={() => {
            try {
              console.log(`Pagination dot ${index + 1} pressed`);
              setCurrentIndex(index);
              scrollViewRef.current?.scrollTo({
                x: index * screenWidth,
                animated: true,
              });
              
              // Reset auto-slide timer when user manually navigates
              if (autoSlideTimer.current) {
                clearTimeout(autoSlideTimer.current);
              }
            } catch (error) {
              console.error('Error in pagination dot press:', error);
            }
          }}
        />
      ))}
    </View>
  );

  return (
    <GlassBackground>
      <SafeAreaView style={styles.container}>
        <BlurView intensity={20} style={styles.header}>
          <TouchableOpacity onPress={handleSkip} style={[styles.skipButton, glassmorphismStyles.glassButton]}>
            <Text style={styles.skipText}>Skip</Text>
          </TouchableOpacity>
        </BlurView>

        <ScrollView
          ref={scrollViewRef}
          horizontal
          pagingEnabled
          showsHorizontalScrollIndicator={false}
          onScroll={handleScroll}
          scrollEventThrottle={16}
          style={styles.scrollView}
        >
          {slides.map((slide, index) => renderSlide(slide, index))}
        </ScrollView>

        {renderPagination()}
      </SafeAreaView>
    </GlassBackground>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    paddingHorizontal: 24,
    paddingTop: 16,
    paddingBottom: 8,
  },
  skipButton: {
    paddingVertical: 8,
    paddingHorizontal: 16,
    borderRadius: 20,
  },
  skipText: {
    fontSize: 16,
    color: colors.text,
    fontWeight: '500',
  },
  scrollView: {
    flex: 1,
  },
  slide: {
    width: screenWidth,
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 40,
  },
  logoSection: {
    alignItems: 'center',
    marginBottom: 40,
  },
  appLogoContainer: {
    width: 60,
    height: 60,
    borderRadius: 30,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 12,
  },
  appName: {
    fontSize: 20,
    fontWeight: '800',
    color: colors.text,
    letterSpacing: 0.5,
    textShadow: '0 0 20px rgba(255, 255, 255, 0.3)',
  },
  iconCard: {
    marginBottom: 30,
    backgroundColor: 'transparent',
  },
  iconContainer: {
    width: 160,
    height: 160,
    borderRadius: 80,
    alignItems: 'center',
    justifyContent: 'center',
  },
  textContainer: {
    padding: 24,
    alignItems: 'center',
    maxWidth: 320,
    marginBottom: 20,
  },
  title: {
    fontSize: 28,
    fontWeight: '800',
    color: colors.text,
    textAlign: 'center',
    marginBottom: 16,
    lineHeight: 36,
    textShadow: '0 0 20px rgba(255, 255, 255, 0.2)',
  },
  subtitle: {
    fontSize: 16,
    color: colors.textSecondary,
    textAlign: 'center',
    lineHeight: 24,
  },
  pagination: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    paddingVertical: 20,
    marginHorizontal: 20,
    borderRadius: 25,
    position: 'absolute',
    bottom: 100,
    left: 0,
    right: 0,
  },
  dot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    marginHorizontal: 4,
  },
  activeDot: {
    backgroundColor: colors.primary,
    width: 24,
    boxShadow: '0 0 10px rgba(76, 175, 80, 0.6)',
  },
  inactiveDot: {
    backgroundColor: colors.textSecondary,
  },
  getStartedButton: {
    overflow: 'hidden',
    borderRadius: 25,
    marginTop: 20,
  },
  buttonGradient: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 18,
    paddingHorizontal: 40,
    borderRadius: 25,
  },
  getStartedButtonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: '600',
    textShadow: '0 0 10px rgba(0, 0, 0, 0.3)',
  },
});
