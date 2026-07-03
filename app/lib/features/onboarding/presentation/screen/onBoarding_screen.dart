import 'package:app/features/onboarding/presentation/widget/First_screen.dart';
import 'package:app/features/onboarding/presentation/widget/second_screen.dart'; // Fixed snake_case/PascalCase import check
import 'package:app/features/onboarding/presentation/widget/page_indicator.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _controller;
  int _currentPage = 0;

  // ── 🎯 TIP: Keep your screens in a list to dynamically compute item counts ──
  final List<Widget> _onboardingPages = const [
    FirstScreen(),
    SecondScreen(),
    // ThirdScreen(), // Simply uncomment these as you add them!
    // FourthScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _onboardingPages.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          // Background PageView Slider
          PageView(
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
                  // Drop this exact block inside the children array of your bottom Column layout:
children: [
  // ── 🎯 HEADING: High-Impact Typography ──
  Text(
    'Big ideas. Made simple.',
    textAlign: TextAlign.center,
    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.6,
          // Color choice matches standard professional dark themes smoothly
          // color: const Color.fromARGB(255, 22, 29, 46), 
        ),
  ),
  
  const SizedBox(height: 12), // Tighter layout binding gap

  // ── 🎯 DESCRIPTION: Optimized Contrast & Reading Line Height ──
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Text(
      'Discover bestselling books without reading 300 pages.',
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 16,
            height: 1.4, // Prevents text overlaps across lines
            fontWeight: FontWeight.w500,
            color: const Color(0xFF475569), // Slate deep grey for crisp contrast
          ),
    ),
  ),

  const SizedBox(height: 28), // Consistent layout breathing room

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
      style: ElevatedButton.styleFrom(
        // Dynamic background logic: Gives an extra premium snap on the final screen
        backgroundColor: Theme.of(context).colorScheme.primary, 
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18), // Modern rounded geometric look
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
      ).copyWith(
        overlayColor: WidgetStateProperty.all(
          Colors.white.withValues(alpha: 0.12),
        ),
      ),
      onPressed: () {
        if (!isLastPage) {
          _controller.nextPage(
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeInOutCubic, // Much smoother movement profile than standard easeOut
          );
        } else {
          // TODO: Implement your entry route swap (e.g., GoRouter / Navigator)
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          );
        },
        // Using distinct keys forces a clean fade animation when changing states
        key: ValueKey<bool>(isLastPage),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              isLastPage ? 'Get Started' : 'Continue',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    letterSpacing: 0.3,
                  ),
            ),
            const SizedBox(width: 8),
            Icon(
              isLastPage ? Icons.rocket_launch_rounded : Icons.arrow_forward_rounded,
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