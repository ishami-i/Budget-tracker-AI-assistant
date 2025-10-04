import 'package:flutter/material.dart';

/// Model representing an individual onboarding slide
/// Contains all necessary data for displaying onboarding content
class OnboardingSlide {
  /// Unique identifier for the slide
  final int id;
  
  /// Main title text displayed on the slide
  final String title;
  
  /// Subtitle/description text displayed below the title
  final String subtitle;
  
  /// Icon displayed on the slide using Flutter's Icons class
  final IconData icon;
  
  /// Gradient colors used for the slide's visual effects
  final List<Color> gradientColors;

  const OnboardingSlide({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is OnboardingSlide &&
        other.id == id &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.icon == icon &&
        _listEquals(other.gradientColors, gradientColors);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        subtitle.hashCode ^
        icon.hashCode ^
        gradientColors.hashCode;
  }

  @override
  String toString() {
    return 'OnboardingSlide(id: $id, title: $title, subtitle: $subtitle, icon: $icon, gradientColors: $gradientColors)';
  }

  /// Helper method to compare lists for equality
  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    if (identical(a, b)) return true;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}