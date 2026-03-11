import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/home_controller.dart';
import '../widgets/decision_card.dart';
import '../widgets/stat_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Fetch the data from the controller
    final decisions = ref.watch(recentDecisionsProvider);

    // 2. Define the color palette (Ideally, this moves to your core/theme folder later)
    const primaryBlue = Color(0xFF1E40AF); 
    const lightBlue = Color(0xFFDBEAFE); 
    const backgroundBlue = Color(0xFFF8FAFC); 
    const textDark = Color(0xFF0F172A); 

    return Scaffold(
      backgroundColor: backgroundBlue,
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'HInsight',
          style: TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: primaryBlue),
            onPressed: () {}, 
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {}, 
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 2,
        icon: const Icon(Icons.add),
        label: const Text(
          'New Decision',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back,',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'What are we tracking today?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: textDark,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 32),
            
            // Stats Row using extracted Widget
            const Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'In Progress',
                    count: '4',
                    color: primaryBlue,
                    bgColor: lightBlue,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    title: 'Resolved',
                    count: '12',
                    color: Colors.white,
                    bgColor: primaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),
            
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
            const SizedBox(height: 16),
            
            // 3. Dynamically map the data from the controller to the extracted widgets
            ...decisions.map((decision) => DecisionCard(
              title: decision.title,
              date: decision.date,
              status: decision.status,
              statusColor: decision.statusColor,
              icon: decision.icon,
            )),
            
            const SizedBox(height: 80), 
          ],
        ),
      ),
    );
  }
}