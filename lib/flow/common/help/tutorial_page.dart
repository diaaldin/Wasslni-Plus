import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/services/tutorial_service.dart';
import 'package:wasslni_plus/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialPage extends StatefulWidget {
  final String? userRole;
  final VoidCallback? onComplete;

  const TutorialPage({
    super.key,
    this.userRole,
    this.onComplete,
  });

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final _pageController = PageController();
  final _tutorialService = TutorialService();
  final _authService = AuthService();

  int _currentPage = 0;
  late List<TutorialStep> _tutorialSteps;

  @override
  void initState() {
    super.initState();
    _loadTutorial();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadTutorial() {
    // Use provided role or default to customer
    final role = widget.userRole ?? 'customer';

    setState(() {
      _tutorialSteps = _tutorialService.getTutorialForRole(role);
    });
  }

  void _nextPage() {
    if (_currentPage < _tutorialSteps.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeTutorial();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeTutorial() async {
    // Mark tutorial as completed in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final user = _authService.currentUser;
    if (user != null) {
      await prefs.setBool('tutorial_completed_${user.uid}', true);
    }

    if (widget.onComplete != null) {
      widget.onComplete!();
    } else {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _skipTutorial() async {
    final languageCode = Localizations.localeOf(context).languageCode;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          languageCode == 'ar' ? 'تخطي الدليل التعليمي؟' : 'Skip Tutorial?',
        ),
        content: Text(
          languageCode == 'ar'
              ? 'يمكنك دائماً مشاهدة هذا الدليل لاحقاً من الإعدادات.'
              : 'You can always view this tutorial later from Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(languageCode == 'ar' ? 'إلغاء' : 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(languageCode == 'ar' ? 'تخطي' : 'Skip'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _completeTutorial();
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Skip button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo or Title
                  Text(
                    languageCode == 'ar' ? 'دليل البداية' : 'Getting Started',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppStyles.primaryColor,
                    ),
                  ),
                  // Skip button
                  TextButton(
                    onPressed: _skipTutorial,
                    child: Text(
                      languageCode == 'ar' ? 'تخطي' : 'Skip',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page Indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _tutorialSteps.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppStyles.primaryColor
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // Tutorial Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _tutorialSteps.length,
                itemBuilder: (context, index) {
                  final step = _tutorialSteps[index];
                  return _TutorialPageContent(
                    step: step,
                    languageCode: languageCode,
                  );
                },
              ),
            ),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Button
                  if (_currentPage > 0)
                    OutlinedButton.icon(
                      onPressed: _previousPage,
                      icon: Icon(
                        languageCode == 'ar'
                            ? Icons.arrow_forward
                            : Icons.arrow_back,
                      ),
                      label: Text(
                        languageCode == 'ar' ? 'السابق' : 'Previous',
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 100),

                  // Progress Text
                  Text(
                    '${_currentPage + 1} / ${_tutorialSteps.length}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),

                  // Next/Done Button
                  ElevatedButton.icon(
                    onPressed: _nextPage,
                    icon: Icon(
                      _currentPage == _tutorialSteps.length - 1
                          ? Icons.check
                          : (languageCode == 'ar'
                              ? Icons.arrow_back
                              : Icons.arrow_forward),
                    ),
                    label: Text(
                      _currentPage == _tutorialSteps.length - 1
                          ? (languageCode == 'ar' ? 'ابدأ' : 'Get Started')
                          : (languageCode == 'ar' ? 'التالي' : 'Next'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TutorialPageContent extends StatelessWidget {
  final TutorialStep step;
  final String languageCode;

  const _TutorialPageContent({
    required this.step,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppStyles.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              step.icon,
              size: 80,
              color: AppStyles.primaryColor,
            ),
          ),

          const SizedBox(height: 48),

          // Title
          Text(
            step.getTitle(languageCode),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppStyles.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Description
          Text(
            step.getDescription(languageCode),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Optional: Image placeholder (if image path is provided)
          if (step.imagePath != null)
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 64,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Function to check if user has completed tutorial
Future<bool> hasTutorialCompleted(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('tutorial_completed_$userId') ?? false;
}

/// Function to show tutorial on first app launch
Future<void> showTutorialIfNeeded(BuildContext context, String userId) async {
  final completed = await hasTutorialCompleted(userId);

  if (!completed && context.mounted) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TutorialPage(),
        fullscreenDialog: true,
      ),
    );
  }
}
