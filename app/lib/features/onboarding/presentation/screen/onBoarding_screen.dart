import 'package:app/core/providers/shared_providers.dart';
import 'package:app/features/auth/presentation/pages/login_screen.dart';
import 'package:app/features/onboarding/presentation/screen/questionsFlow_screen.dart';
import 'package:app/features/onboarding/presentation/widget/First_screen.dart';
import 'package:app/features/onboarding/presentation/widget/Fourth_screen.dart';
import 'package:app/features/onboarding/presentation/widget/Third_screen.dart';
import 'package:app/features/onboarding/presentation/widget/second_screen.dart'; // Fixed snake_case/PascalCase import check
import 'package:app/features/onboarding/presentation/widget/page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _controller;
  int _currentPage = 0;

  // ── 🎯 TIP: Keep your screens in a list to dynamically compute item counts ──
  final List<Widget> _onboardingPages = const [
    FirstScreen(),
    SecondScreen(),
    ThirdScreen(),
    FourthScreen(),
  ];

  final List<String> _onboardingTitles = const [
    'Big ideas. Made simple.',
    'Thousands of books. All in one place.',
    'Listen, read, and highlight your way.',
    'Join a community of readers.',
  ];

  final List<String> _onboardingDescriptions = const [
    'Discover bestselling books without reading 300 pages.',
    'Access summaries, audio, and highlights for thousands of books.',
    'Turn summaries into audio and lean on your favorite books while on the go.',
    'Track your reading progress and set goals.',
  ];

  late final AnimationController _contentController;

  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleSlide;

  late final Animation<double> _descOpacity;
  late final Animation<Offset> _descSlide;
  @override
  void initState() {
    super.initState();

    _controller = PageController();

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _titleOpacity = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(.0, .55, curve: Curves.easeOut),
    );

    _titleSlide = Tween(begin: const Offset(0, .25), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(.0, .55, curve: Curves.easeOutCubic),
      ),
    );

    _descOpacity = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(.25, .9, curve: Curves.easeOut),
    );

    _descSlide = Tween(begin: const Offset(0, .18), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(.25, .9, curve: Curves.easeOutCubic),
      ),
    );

    _contentController.forward();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _onboardingPages.length - 1;
    double _contentOpacity = 1.0;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            // physics: const NeverScrollableScrollPhysics(),
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: _onboardingPages,
          ),

          // Floating Bottom Panel Overlay
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 28,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _titleOpacity,
                      child: SlideTransition(
                        position: _titleSlide,
                        child: Text(
                          textAlign: TextAlign.center,
                          _onboardingTitles[_currentPage],
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.6,
                              ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FadeTransition(
                        opacity: _descOpacity,
                        child: SlideTransition(
                          position: _descSlide,
                          child: Text(
                            textAlign: TextAlign.center,
                            _onboardingDescriptions[_currentPage],
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontSize: 16,
                                  height:
                                      1.4,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(
                                    0xFF475569,
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 28,
                    ), // Consistent layout breathing room
                    // ── 🎯 DOT MATRIX: Dynamic Progress Tracking ──
                    PremiumPageIndicator(
                      currentIndex: _currentPage,
                      itemCount: _onboardingPages.length,
                    ),

                    const SizedBox(height: 28),

                    // ── 🎯 PRIMARY ACTION CALL: Fluid CTA Button ──
                    SizedBox(
                      width: double.infinity,
                      height: 58, // Standard production tap target size
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                              // Dynamic background logic: Gives an extra premium snap on the final screen
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  18,
                                ), // Modern rounded geometric look
                              ),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                            ).copyWith(
                              overlayColor: WidgetStateProperty.all(
                                Colors.white.withValues(alpha: 0.12),
                              ),
                            ),

                        onPressed: () async {
                          if (isLastPage) {

                            await ref.read(onboardingStorageProvider).markOnboardingComplete();

                            if (!context.mounted) return;
                            
                            // Navigate to the next screen or perform any action for the last page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                            return;
                          };

                          // animate OUT
                          await _contentController.reverse();

                          // change page
                          await _controller.nextPage(
                            duration: const Duration(milliseconds: 450),
                            curve: Curves.easeInOutCubic,
                          );

                          // animate IN
                          _contentController.forward(from: 0);
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  ),
                                );
                              },

                          key: ValueKey<bool>(isLastPage),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                isLastPage ? 'Get Started' : 'Continue',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 17,
                                      letterSpacing: 0.3,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                isLastPage
                                    ? Icons.rocket_launch_rounded
                                    : Icons.arrow_forward_rounded,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Dynamic safety clearance buffer
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
