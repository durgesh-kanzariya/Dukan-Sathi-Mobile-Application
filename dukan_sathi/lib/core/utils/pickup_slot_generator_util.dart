import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Representation of a Shop's daily operating schedule (supporting split shifts).
class ShopOperatingHours {
  final TimeOfDay morningOpen;
  final TimeOfDay morningClose;
  final TimeOfDay? eveningOpen;
  final TimeOfDay? eveningClose;

  const ShopOperatingHours({
    required this.morningOpen,
    required this.morningClose,
    this.eveningOpen,
    this.eveningClose,
  });

  /// Default standard Kirana schedule: 8:00 AM - 12:00 PM & 4:00 PM - 9:00 PM
  factory ShopOperatingHours.defaultKirana() {
    return const ShopOperatingHours(
      morningOpen: TimeOfDay(hour: 8, minute: 0),
      morningClose: TimeOfDay(hour: 12, minute: 0),
      eveningOpen: TimeOfDay(hour: 16, minute: 0),
      eveningClose: TimeOfDay(hour: 21, minute: 0),
    );
  }

  /// Default Dairy schedule: 6:00 AM - 1:00 PM & 4:00 PM - 10:00 PM
  factory ShopOperatingHours.defaultDairy() {
    return const ShopOperatingHours(
      morningOpen: TimeOfDay(hour: 6, minute: 0),
      morningClose: TimeOfDay(hour: 13, minute: 0),
      eveningOpen: TimeOfDay(hour: 16, minute: 0),
      eveningClose: TimeOfDay(hour: 22, minute: 0),
    );
  }

  String get formattedHoursSummary {
    final mOpen = _formatTimeOfDay(morningOpen);
    final mClose = _formatTimeOfDay(morningClose);

    if (eveningOpen != null && eveningClose != null) {
      final eOpen = _formatTimeOfDay(eveningOpen!);
      final eClose = _formatTimeOfDay(eveningClose!);
      return '$mOpen - $mClose  •  $eOpen - $eClose';
    }

    return '$mOpen - $mClose';
  }

  static String _formatTimeOfDay(TimeOfDay tod) {
    final dt = DateTime(2026, 1, 1, tod.hour, tod.minute);
    return DateFormat('h:mm a').format(dt);
  }
}

/// Utility for generating valid 1-hour pre-order pickup window slots.
class PickupSlotGeneratorUtil {
  PickupSlotGeneratorUtil._();

  /// Generates 1-hour pickup slots for today & tomorrow based on split shop operating hours.
  static List<String> generateAvailableSlots({
    ShopOperatingHours? hours,
    DateTime? currentTime,
  }) {
    final schedule = hours ?? ShopOperatingHours.defaultKirana();
    final now = currentTime ?? DateTime.now();
    final List<String> slots = [];

    // 1. Today's Available Slots
    final todaySlots = _generateSlotsForDate(
      dateLabel: 'Today',
      date: now,
      schedule: schedule,
      filterPastCurrentTime: true,
      now: now,
    );
    slots.addAll(todaySlots);

    // 2. Tomorrow's Available Slots
    final tomorrow = now.add(const Duration(days: 1));
    final tomorrowSlots = _generateSlotsForDate(
      dateLabel: 'Tomorrow',
      date: tomorrow,
      schedule: schedule,
      filterPastCurrentTime: false,
      now: now,
    );
    slots.addAll(tomorrowSlots);

    if (slots.isEmpty) {
      return ['Tomorrow (${ShopOperatingHours._formatTimeOfDay(schedule.morningOpen)} - ${ShopOperatingHours._formatTimeOfDay(TimeOfDay(hour: schedule.morningOpen.hour + 1, minute: 0))})'];
    }

    return slots;
  }

  static List<String> _generateSlotsForDate({
    required String dateLabel,
    required DateTime date,
    required ShopOperatingHours schedule,
    required bool filterPastCurrentTime,
    required DateTime now,
  }) {
    final List<String> slots = [];

    // Shift 1: Morning Session
    slots.addAll(_generateShiftSlots(
      dateLabel: dateLabel,
      date: date,
      startHour: schedule.morningOpen.hour,
      endHour: schedule.morningClose.hour,
      filterPast: filterPastCurrentTime,
      now: now,
    ));

    // Shift 2: Evening Session (if store re-opens in evening)
    if (schedule.eveningOpen != null && schedule.eveningClose != null) {
      slots.addAll(_generateShiftSlots(
        dateLabel: dateLabel,
        date: date,
        startHour: schedule.eveningOpen!.hour,
        endHour: schedule.eveningClose!.hour,
        filterPast: filterPastCurrentTime,
        now: now,
      ));
    }

    return slots;
  }

  static List<String> _generateShiftSlots({
    required String dateLabel,
    required DateTime date,
    required int startHour,
    required int endHour,
    required bool filterPast,
    required DateTime now,
  }) {
    final List<String> result = [];

    for (int hour = startHour; hour < endHour; hour++) {
      final slotStart = DateTime(date.year, date.month, date.day, hour, 0);
      final slotEnd = DateTime(date.year, date.month, date.day, hour + 1, 0);

      // If checking today, ignore slots that have already passed
      if (filterPast && slotEnd.isBefore(now)) {
        continue;
      }

      final startStr = DateFormat('h:mm a').format(slotStart);
      final endStr = DateFormat('h:mm a').format(slotEnd);

      result.add('$dateLabel ($startStr - $endStr)');
    }

    return result;
  }
}
