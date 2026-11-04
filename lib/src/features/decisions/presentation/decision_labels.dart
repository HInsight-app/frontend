import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/entities/decision_enums.dart';

// Names and descriptions shown to students. Bias definitions follow the
// paper's literature review (II-A); recency isn't defined there yet.

extension BiasTypeLabel on BiasType {
  String get label => switch (this) {
        BiasType.confirmation => 'Confirmation Bias',
        BiasType.lossAversion => 'Loss Aversion',
        BiasType.sunkCost => 'Sunk Cost Fallacy',
        BiasType.overconfidence => 'Overconfidence Bias',
        BiasType.recency => 'Recency Bias',
      };

  String get description => switch (this) {
        BiasType.confirmation =>
          'Favouring information that fits what you already believe, while '
              'overlooking evidence against it.',
        BiasType.lossAversion =>
          'Feeling a loss much more strongly than a gain of the same size.',
        BiasType.sunkCost =>
          'Sticking with a choice because of the time, money or effort you '
              'have already put in.',
        BiasType.overconfidence =>
          'Rating your own knowledge or predictions as more accurate than '
              'they really are.',
        BiasType.recency =>
          'Giving recent events more weight than earlier ones.',
      };
}

extension DecisionStatusLabel on DecisionStatus {
  String get label => switch (this) {
        DecisionStatus.pending => 'Pending',
        DecisionStatus.decided => 'Decided',
        DecisionStatus.evaluated => 'Evaluated',
      };

  Color get color => switch (this) {
        DecisionStatus.pending => AppColors.warning,
        DecisionStatus.decided => AppColors.info,
        DecisionStatus.evaluated => AppColors.success,
      };
}

extension RiskLevelLabel on RiskLevel {
  String get label => switch (this) {
        RiskLevel.low => 'Low risk',
        RiskLevel.medium => 'Medium risk',
        RiskLevel.high => 'High risk',
      };

  Color get color => switch (this) {
        RiskLevel.low => AppColors.mutedForeground,
        RiskLevel.medium => AppColors.warning,
        RiskLevel.high => AppColors.error,
      };
}

extension EmotionalToneLabel on EmotionalTone {
  String get label => switch (this) {
        EmotionalTone.neutral => 'Neutral',
        EmotionalTone.anxious => 'Anxious',
        EmotionalTone.confident => 'Confident',
        EmotionalTone.uncertain => 'Uncertain',
        EmotionalTone.regretful => 'Regretful',
      };
}

extension TriggerContextLabel on TriggerContext {
  String get label => switch (this) {
        TriggerContext.preDecision => 'Before deciding',
        TriggerContext.postEvaluation => 'Looking back',
      };
}
