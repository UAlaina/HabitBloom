import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:habittracker/models/db_service.dart';
import 'package:habittracker/models/dbHelper.dart';

class DateCheckService {
  // Singleton setup
  static final DateCheckService _instance = DateCheckService._internal();
  factory DateCheckService() => _instance;
  DateCheckService._internal();

  Timer? _timer;

  void initialize({Duration interval = const Duration(seconds: 5)}) {
    print('[!Service] Initialized with interval: ${interval.inSeconds} seconds');
    final DbHelper dbHelper = DbService().dbHelper;
    print('!MADE IT');

    _timer?.cancel(); // clear previous timer if any

    _timer = Timer.periodic(interval, (_) {
      print('[!Service] Tick at ${DateTime.now()}');
    });
  }

  void dispose() {
    _timer?.cancel();
    print('[!Service] Disposed');
  }


  void runDateCheck() {

  }





}





















/*
class DateCheckService {
  // Singleton pattern
  static final DateCheckService _instance = DateCheckService._internal();
  factory DateCheckService() => _instance;
  DateCheckService._internal();

  // Timer for periodic checks
  Timer? _timer;

  // Event callbacks
  VoidCallback? onDayEnd;
  VoidCallback? onWeekEnd;
  VoidCallback? onMonthEnd;

  // Last checked date (to detect changes)
  DateTime _lastCheckedDate = DateTime.now();

  // Initialize the service
  void initialize({
    VoidCallback? onDayEnd,
    VoidCallback? onWeekEnd,
    VoidCallback? onMonthEnd,
    Duration checkInterval = const Duration(hours: 1),
  }) {
    print('!interval in datecheckservice');

    this.onDayEnd = onDayEnd;
    this.onWeekEnd = onWeekEnd;
    this.onMonthEnd = onMonthEnd;

    // Check immediately on startup
    checkDateEvents();

    // Set up periodic checking
    _timer?.cancel();
    _timer = Timer.periodic(checkInterval, (_) {
      checkDateEvents();
    });
  }

  // Cancel timer when not needed
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }

  // The core date checking logic
  void checkDateEvents() {
    DateTime now = DateTime.now();

    // Check if day changed since last check
    bool dayChanged = _lastCheckedDate.day != now.day ||
        _lastCheckedDate.month != now.month ||
        _lastCheckedDate.year != now.year;

    // Check if week changed (crossed Monday boundary)
    bool weekChanged = _lastCheckedDate.weekday > now.weekday &&
        now.weekday == DateTime.monday;

    // Check if month changed
    bool monthChanged = _lastCheckedDate.month != now.month ||
        _lastCheckedDate.year != now.year;

    // Trigger appropriate callbacks
    if (dayChanged && onDayEnd != null) {
      onDayEnd!();
    }

    if (weekChanged && onWeekEnd != null) {
      onWeekEnd!();
    }

    if (monthChanged && onMonthEnd != null) {
      onMonthEnd!();
    }

    // Update last checked date
    _lastCheckedDate = now;
  }

  // Helper methods you might want to use
  bool isEndOfDay() {
    final now = DateTime.now();
    return now.hour >= 23 && now.minute >= 0;
  }

  bool isEndOfMonth() {
    final now = DateTime.now();
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0).day;
    return now.day == lastDayOfMonth;
  }
}

 */