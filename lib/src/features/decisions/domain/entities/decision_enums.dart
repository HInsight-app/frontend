// Domain enums for decisions and AI insights. The data layer maps them to the
// API's snake_case values (e.g. lossAversion <-> loss_aversion).

/// Where a decision is in its lifecycle. Local only: the server derives it from
/// whether a decision_outcomes / evaluations row exists.
enum DecisionStatus { pending, decided, evaluated }

/// When an AI insight was requested: pre_decision | post_evaluation.
enum TriggerContext { preDecision, postEvaluation }

/// Progress of an AI insight request, as described in the paper. Local only:
/// the server stores only finished insights. While one is processing, the app
/// must not send another request for the same decision and trigger.
enum InsightStatus { processing, complete, failed }

/// Must match the ai_insights.primary_bias CHECK constraint in the backend.
enum BiasType { confirmation, lossAversion, sunkCost, overconfidence, recency }

enum EmotionalTone { neutral, anxious, confident, uncertain, regretful }

enum RiskLevel { low, medium, high }
