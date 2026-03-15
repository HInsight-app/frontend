import 'package:flutter/material.dart';
import 'package:hinsight/core.dart';

class SandboxPage extends StatelessWidget {
  const SandboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Component Sandbox'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.p24),
        children: [
          Text('Buttons', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSizes.p16),
          AppButton(
            text: 'Primary Button',
            onPressed: () {},
          ),
          const SizedBox(height: AppSizes.p16),
          AppButton(
            text: 'Secondary Button',
            type: ButtonType.secondary,
            onPressed: () {},
          ),
          const SizedBox(height: AppSizes.p16),
          AppButton(
            text: 'Outline Button',
            type: ButtonType.outline,
            onPressed: () {},
          ),
          const SizedBox(height: AppSizes.p16),
          AppButton(
            text: 'Loading State',
            isLoading: true,
            onPressed: () {},
          ),
          const Divider(height: 64),
          Text('Input Fields',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSizes.p16),
          const AppTextField(
            label: 'Decision Title',
            hint: 'e.g., Should I buy a new laptop?',
            prefixIcon: Icons.settings,
          ),
          const SizedBox(height: AppSizes.p16),
          const AppTextField(
            label: 'Notes',
            hint: 'Brain dump here...',
            maxLines: 4,
          ),
          const SizedBox(height: AppSizes.p16),
          AiInsightCard(
            insightText:
                "You are heavily weighing the time you've already spent on this code rather than the time it will take to fix it. Consider a rewrite.",
            primaryBias: "Sunk Cost Fallacy",
            emotionalTone: "Frustrated",
            riskLevel: "High Risk",
          ),
        ],
      ),
    );
  }
}
