// Lunara - Lunar Phase Service
// Copyright (C) 2026 alchemyxcode
// Licensed under GNU General Public License v3.0

class LunarService {
  static final LunarService instance = LunarService._internal();
  LunarService._internal();

  // Returns the moon phase for a given date (0.0 - 1.0)
  // 0.0 = new moon, 0.25 = first quarter, 0.5 = full moon, 0.75 = last quarter
  double getMoonPhase(DateTime date) {
    // Known new moon reference: January 6, 2000
    final reference = DateTime(2000, 1, 6, 18, 14);
    const synodicMonth = 29.53058770576; // days

    final daysSinceReference = date.difference(reference).inMilliseconds /
        (1000 * 60 * 60 * 24);
    final phase = (daysSinceReference % synodicMonth) / synodicMonth;
    return phase < 0 ? phase + 1 : phase;
  }

  // Returns the phase name for a given date
  String getPhaseName(DateTime date) {
    final phase = getMoonPhase(date);
    if (phase < 0.0625) return 'New Moon';
    if (phase < 0.1875) return 'Waxing Crescent';
    if (phase < 0.3125) return 'First Quarter';
    if (phase < 0.4375) return 'Waxing Gibbous';
    if (phase < 0.5625) return 'Full Moon';
    if (phase < 0.6875) return 'Waning Gibbous';
    if (phase < 0.8125) return 'Last Quarter';
    if (phase < 0.9375) return 'Waning Crescent';
    return 'New Moon';
  }

  // Returns an emoji for the phase
  String getPhaseEmoji(DateTime date) {
    final phase = getMoonPhase(date);
    if (phase < 0.0625) return '🌑';
    if (phase < 0.1875) return '🌒';
    if (phase < 0.3125) return '🌓';
    if (phase < 0.4375) return '🌔';
    if (phase < 0.5625) return '🌕';
    if (phase < 0.6875) return '🌖';
    if (phase < 0.8125) return '🌗';
    if (phase < 0.9375) return '🌘';
    return '🌑';
  }

  // Returns true if date is within 1 day of a full or new moon
  bool isAlignmentDay(DateTime date) {
    final phase = getMoonPhase(date);
    return phase < 0.0625 || phase > 0.9375 || // new moon
           (phase > 0.4375 && phase < 0.5625);  // full moon
  }

  // Returns days until next full moon
  int daysUntilFullMoon(DateTime date) {
    double phase = getMoonPhase(date);
    const synodicMonth = 29.53058770576;
    double daysLeft;
    if (phase <= 0.5) {
      daysLeft = (0.5 - phase) * synodicMonth;
    } else {
      daysLeft = (1.5 - phase) * synodicMonth;
    }
    return daysLeft.round();
  }

  // Returns days until next new moon
  int daysUntilNewMoon(DateTime date) {
    double phase = getMoonPhase(date);
    const synodicMonth = 29.53058770576;
    double daysLeft = (1.0 - phase) * synodicMonth;
    return daysLeft.round();
  }

  // Returns true only on the single peak day of a full or new moon
  bool isFullMoonDay(DateTime date) {
    final phase = getMoonPhase(date);
    final tomorrow = getMoonPhase(date.add(const Duration(days: 1)));
    final yesterday = getMoonPhase(date.subtract(const Duration(days: 1)));
    // Full moon is nearest to 0.5
    final distToday = (phase - 0.5).abs();
    final distTomorrow = (tomorrow - 0.5).abs();
    final distYesterday = (yesterday - 0.5).abs();
    return distToday < distTomorrow && distToday < distYesterday && distToday < 0.05;
  }

  bool isNewMoonDay(DateTime date) {
    final phase = getMoonPhase(date);
    final tomorrow = getMoonPhase(date.add(const Duration(days: 1)));
    final yesterday = getMoonPhase(date.subtract(const Duration(days: 1)));
    // New moon is nearest to 0.0 or 1.0
    double dist(double p) => p > 0.5 ? 1.0 - p : p;
    return dist(phase) < dist(tomorrow) && dist(phase) < dist(yesterday) && dist(phase) < 0.05;
  }
}
