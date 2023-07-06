import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Ambience {
  none,
  seaside,
  fireplace,
  forest,
  rain,
  musicElevation,
  musicHarmony,
  musicHealing,
  musicNature,
  musicReflection,
  musicSnowyPeaks,
  musicSpiritual,
  musicSunrise,
  musicZen,
  shuffle,
}

extension AmbienceText on Ambience {
  String toText() {
    switch (this) {
      case Ambience.none:
        return 'No Ambience';
      case Ambience.forest:
        return 'Forest';
      case Ambience.rain:
        return 'Rain';
      case Ambience.seaside:
        return 'Seaside';
      case Ambience.fireplace:
        return 'Fireplace';
      case Ambience.musicReflection:
        return 'Reflection';
      case Ambience.musicSunrise:
        return 'Sunrise';
      case Ambience.musicElevation:
        return 'Elevation';
      case Ambience.musicSnowyPeaks:
        return 'Snowy Peaks';
      case Ambience.musicHealing:
        return 'Healing';
      case Ambience.musicNature:
        return 'Nature';
      case Ambience.musicHarmony:
        return 'Harmony';
      case Ambience.musicSpiritual:
        return 'Spiritual';
      case Ambience.musicZen:
        return 'Zen';
      case Ambience.shuffle:
        return 'Shuffle';
    }
  }
}

extension AmbienceIcon on Ambience {
  IconData toIcon() {
    switch (this) {
      case Ambience.none:
        return Icons.piano_off_outlined;
      case Ambience.forest:
        return Icons.forest_outlined;
      case Ambience.rain:
        return FontAwesomeIcons.droplet;
      case Ambience.fireplace:
        return FontAwesomeIcons.fireBurner;
      case Ambience.seaside:
        return FontAwesomeIcons.umbrellaBeach;
      case Ambience.musicReflection:
        return Icons.piano_outlined;
      case Ambience.musicSunrise:
        return Icons.piano_outlined;
      case Ambience.musicElevation:
        return Icons.piano_outlined;
      case Ambience.musicSnowyPeaks:
        return Icons.piano_outlined;
      case Ambience.musicHealing:
        return Icons.piano_outlined;
      case Ambience.musicNature:
        return Icons.piano_outlined;
      case Ambience.musicHarmony:
        return Icons.piano_outlined;
      case Ambience.musicSpiritual:
        return Icons.piano_outlined;
      case Ambience.musicZen:
        return Icons.piano_outlined;
      case Ambience.shuffle:
        return FontAwesomeIcons.shuffle;
    }
  }
}
