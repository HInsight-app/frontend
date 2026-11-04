import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hinsight/core.dart';

// A simple mock entity representing your HInsight decisions
class DecisionMock {
  final String title;
  final String date;
  final String status;
  final Color statusColor;
  final IconData icon;

  DecisionMock({
    required this.title,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.icon,
  });
}

// The Riverpod provider that holds your mock data
final recentDecisionsProvider = Provider<List<DecisionMock>>((ref) {
  return [
    DecisionMock(
      title: 'Evaluate new job offer',
      date: 'Added 2 days ago',
      status: 'Pending',
      statusColor: AppColors.warning,
      icon: Icons.work_outline,
    ),
    DecisionMock(
      title: 'Select database architecture',
      date: 'Updated yesterday',
      status: 'Researching',
      statusColor: AppColors.info,
      icon: Icons.storage_outlined,
    ),
    DecisionMock(
      title: 'Renew apartment lease',
      date: 'Resolved last week',
      status: 'Resolved',
      statusColor: AppColors.success,
      icon: Icons.home_outlined,
    ),
  ];
});