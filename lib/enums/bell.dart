enum Bell {
  none,
  bell,
  bellChakra,
  bellDeep,
  bellHigh,
  bellHimalayan,
  bellLow,
  bellMedium,
  bellSharp,
  bellSoft,
  chimeSingle,
  chimesMultiple,
  gong
}

extension ToText on Bell {
  String toText() {
    switch (this) {
      case Bell.none:
        return 'None';
      case Bell.bell:
        return 'Tibetan singing bowl';
      case Bell.bellChakra:
        return 'Chakra bell';
      case Bell.bellDeep:
        return 'Deep Tibetan singing bowl';
      case Bell.bellHigh:
        return 'High Tibetan singing bowl';
      case Bell.bellHimalayan:
        return 'Himalayan singing bowl';
      case Bell.bellLow:
        return 'Low Tibetan singing bowl';
      case Bell.bellMedium:
        return 'Medium Tibetan singing bowl';
      case Bell.bellSharp:
        return 'Sharp meditation bell';
      case Bell.bellSoft:
        return 'Soft meditation bell';
      case Bell.chimeSingle:
        return 'Single meditation chime';
      case Bell.chimesMultiple:
        return 'Multiple meditation chimes';
      case Bell.gong:
        return 'Meditation gong';
    }
  }
}
