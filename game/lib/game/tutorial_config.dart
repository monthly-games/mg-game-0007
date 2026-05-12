import 'package:mg_common_game/systems/tutorial/tutorial.dart';

/// Tutorial configuration for MG-0007: Pixel Farm Idle RPG.
///
/// Placeholder tutorial steps -- replace with localized strings
/// and add targetSelector for highlight positioning in production.
const kOnboardingTutorial = TutorialConfig(
  id: 'onboarding',
  name: 'Pixel Farm Idle RPG Tutorial',
  steps: [
    TutorialStep(
      id: 'welcome',
      title: 'Welcome!',
      description: 'Have fun and enjoy the game.',
      actionHint: 'Tap to continue',
    ),
    TutorialStep(
      id: 'how_to_play',
      title: 'How to Play',
      description: 'Follow on-screen prompts to play.',
      actionHint: 'Tap to play',
      targetSelector: 'game_area',
    ),
    TutorialStep(
      id: 'rewards',
      title: 'Earn Rewards',
      description: 'Complete stages to earn gold and gems.',
      actionHint: 'Tap to continue',
    ),
  ],
  skippable: true,
  showOnFirstLaunch: true,
  trigger: TutorialTrigger.firstLaunch,
);
