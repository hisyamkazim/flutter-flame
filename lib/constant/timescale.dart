enum Timescale {
  pause,
  normal,
  fast,
}

extension TimescaleExtension on Timescale {
  double get value {
    switch (this) {
      case Timescale.pause:
        return 0.0;
      case Timescale.normal:
        return 1.0;
      case Timescale.fast:
        return 2.0;
    }
  }
}
