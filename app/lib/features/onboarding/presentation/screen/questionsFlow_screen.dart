import 'dart:math' as math;
import 'dart:ui';
import 'package:app/core/widget/back_button.dart';
import 'package:app/features/auth/presentation/pages/login_screen.dart';
import 'package:flutter/material.dart';

class QuestionFlowScreen extends StatefulWidget {
  const QuestionFlowScreen({super.key});

  @override
  State<QuestionFlowScreen> createState() => _QuestionFlowScreenState();
}

class _QuestionFlowScreenState extends State<QuestionFlowScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  
  // Storage matrix: Maps Question ID -> Selected Option ID
  final Map<int, int> _answers = {};

  late final AnimationController _progressCtrl;
  late Animation<double> _progressAnim;

  final List<Question> _questions = onboardingQuestionList;

  bool get _canContinue => _answers.containsKey(_questions[_currentIndex].id);

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _progressAnim = Tween<double>(begin: 0, end: 1 / _questions.length).animate(
      CurvedAnimation(parent: _progressCtrl, curve: Curves.easeInOutCubic),
    );
    _progressCtrl.forward();
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _animateProgressTo(int index) {
    final from = _progressAnim.value;
    final to = (index + 1) / _questions.length;
    _progressAnim = Tween<double>(begin: from, end: to).animate(
      CurvedAnimation(parent: _progressCtrl, curve: Curves.easeInOutCubic),
    );
    _progressCtrl.forward(from: 0);
  }

  void _selectAnswer(int questionId, int optionId) {
    setState(() => _answers[questionId] = optionId);
  }

  void _next() {
    if (!_canContinue) return;
    if (_currentIndex < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
    } else {
      // ── 🎯 LOCAL STORAGE CAPTURE: Finalize answers mapping here ──
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, a, __) => const LoginPage(),
          transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  void _previous() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffD8F1FF), 
              Colors.white,
              Color.fromARGB(255, 149, 211, 249),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top Header Navigation Bar ──────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    // Back button featuring dynamic visibility fades
                    AnimatedOpacity(
                      opacity: _currentIndex > 0 ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 250),
                      child: IgnorePointer(
                        ignoring: _currentIndex == 0,
                        child: GestureDetector(
                          onTap: _previous,
                          child: const CustomBackButton(),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Modern Linear Progress Indicator
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _progressAnim,
                        builder: (_, __) => ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _progressAnim.value,
                            minHeight: 6,
                            backgroundColor: const Color(0xff4A8FE8).withValues(alpha: 0.12),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xff4A8FE8),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Digital Step Metric Tracking String
                    Text(
                      '${_currentIndex + 1}/${_questions.length}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff4A8FE8),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Page Slider Stack ──────────────────────────────────
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _questions.length,
                  onPageChanged: (i) {
                    setState(() => _currentIndex = i);
                    _animateProgressTo(i);
                  },
                  itemBuilder: (_, i) => _QuestionPage(
                    question: _questions[i],
                    selectedOptionId: _answers[_questions[i].id],
                    onSelect: _selectAnswer,
                  ),
                ),
              ),

              // ── Bottom Action Button Pipeline ──────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                child: AnimatedOpacity(
                  opacity: _canContinue ? 1.0 : 0.45,
                  duration: const Duration(milliseconds: 250),
                  child: SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff4C9FFF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: _canContinue ? _next : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentIndex < _questions.length - 1 ? 'Continue' : 'Get Started',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _currentIndex < _questions.length - 1
                                ? Icons.arrow_forward_rounded
                                : Icons.rocket_launch_rounded,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Single Question Intercept Interface Page ──────────────────────────────────
class _QuestionPage extends StatelessWidget {
  const _QuestionPage({
    required this.question,
    required this.selectedOptionId,
    required this.onSelect,
  });

  final Question question;
  final int? selectedOptionId;
  final void Function(int questionId, int optionId) onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (question.tag != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xff4A8FE8).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                question.tag!.toUpperCase(),
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                  color: Color(0xff4A8FE8),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Question Headline
          Text(
            question.text,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.6,
                  color: const Color(0xff12284A),
                  height: 1.25,
                ),
          ),

          if (question.subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              question.subtitle!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ],

          const SizedBox(height: 28),

          // Options Stream List
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: question.options.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final opt = question.options[i];
                final isSelected = selectedOptionId == opt.id;
                return _OptionCard(
                  option: opt,
                  isSelected: isSelected,
                  onTap: () => onSelect(question.id, opt.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Glassmorphic Selection Component Card ──────────────────────────────────────
class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final QuestionOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 140),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xff4A8FE8).withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xff4A8FE8) : Colors.white.withValues(alpha: 0.8),
              width: isSelected ? 1.6 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? const Color(0xff4A8FE8).withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.02),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Row(
                children: [
                  // Vector Icon Bubble (Upgraded from Emojis)
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xff4A8FE8).withValues(alpha: 0.15)
                          : const Color(0xff4A8FE8).withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        option.icon,
                        size: 20,
                        color: isSelected ? const Color(0xff4A8FE8) : const Color(0xff6B7E8F),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Text Block
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          option.text,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? const Color(0xff4A8FE8) : const Color(0xff12284A),
                          ),
                        ),
                        if (option.subtitle != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            option.subtitle!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? const Color(0xff4A8FE8).withValues(alpha: 0.8) : const Color(0xff6B7E8F),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Animated Check Radio Circle
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? const Color(0xff4A8FE8) : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? const Color(0xff4A8FE8) : const Color(0xffCBD5E0),
                        width: 1.5,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check_rounded,
                            size: 14,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Data Architecture Specifications ──────────────────────────────────────────
class Question {
  final int id;
  final String text;
  final String? tag;       
  final String? subtitle;  
  final List<QuestionOption> options;

  const Question({
    required this.id,
    required this.text,
    this.tag,
    this.subtitle,
    required this.options,
  });
}

class QuestionOption {
  final int id;
  final String text;
  final IconData icon; // Enforced native icon requirements
  final String? subtitle;  

  const QuestionOption({
    required this.id,
    required this.text,
    required this.icon,
    this.subtitle,
  });
}

// ── Curated Micro-Learning & Growth Marketing Questionnaire Matrix ────────────
final onboardingQuestionList = [
  const Question(
    id: 1,
    tag: 'Your Growth Goal',
    text: 'What is your primary reading objective?',
    subtitle: 'We will curate summaries matching this intent.',
    options: [
      QuestionOption(id: 1, icon: Icons.rocket_launch_rounded, text: 'Accelerate Career Growth', subtitle: 'Leadership, strategy, tech, productivity'),
      QuestionOption(id: 2, icon: Icons.psychology_rounded, text: 'Expand Mental Horizons', subtitle: 'Psychology, philosophy, critical thinking'),
      QuestionOption(id: 3, icon: Icons.monetization_on_rounded, text: 'Master Wealth & Finance', subtitle: 'Investing, business cycles, personal finance'),
      QuestionOption(id: 4, icon: Icons.spa_rounded, text: 'Optimize Habits & Mindset', subtitle: 'Health, daily consistency, mindfulness'),
    ],
  ),
  const Question(
    id: 2,
    tag: 'The Obstacle',
    text: 'What stops you from reading more?',
    subtitle: 'Our summary mechanics help you bypass this block.',
    options: [
      QuestionOption(id: 5, icon: Icons.hourglass_bottom_rounded, text: 'Lack of Free Time', subtitle: 'Can\'t commit to full length 300 page books'),
      QuestionOption(id: 6, icon: Icons.track_changes_rounded, text: 'Difficulty Staying Consistent', subtitle: 'Starting books but rarely finish them'),
      QuestionOption(id: 7, icon: Icons.memory_rounded, text: 'Information Retention Overload', subtitle: 'Forgetting core concepts days after reading'),
      QuestionOption(id: 8, icon: Icons.dashboard_customize_rounded, text: 'Paralysis by Book Choices', subtitle: 'Struggling to find actionable content collections'),
    ],
  ),
  const Question(
    id: 3,
    tag: 'Learning Format',
    text: 'How do you absorb ideas best?',
    subtitle: 'You can swap layout styles on your home deck anytime.',
    options: [
      QuestionOption(id: 9, icon: Icons.text_snippet_rounded, text: 'Text Textures & Bullet Insights', subtitle: 'Fast scannability on small screens'),
      QuestionOption(id: 10, icon: Icons.headset_rounded, text: 'Premium Audio Narratives', subtitle: 'Ideal for commutes or workout periods'),
      QuestionOption(id: 11, icon: Icons.style_rounded, text: 'Interactive Flash Card Decks', subtitle: 'Bite-sized micro-sessions for quick absorption'),
    ],
  ),
  const Question(
    id: 4,
    tag: 'Routine Anchoring',
    text: 'When is your ideal summary drop?',
    subtitle: 'We will configure notifications around your habit loops.',
    options: [
      QuestionOption(id: 12, icon: Icons.coffee_rounded, text: 'Morning Focus Window', subtitle: 'Fuel your perspective before work starts'),
      QuestionOption(id: 13, icon: Icons.refresh_rounded, text: 'Mid-Day Reset Breaks', subtitle: 'A fast 10-minute professional boost'),
      QuestionOption(id: 14, icon: Icons.dark_mode_rounded, text: 'Evening Winding Down Sessions', subtitle: 'Reflect on ideas before going to sleep'),
    ],
  ),
  const Question(
    id: 5,
    tag: 'Discovery Channel',
    text: 'Where did you find us?',
    subtitle: 'Help us know where our community grows fastest.',
    options: [
      QuestionOption(id: 15, icon: Icons.share_rounded, text: 'Friend or Colleague Referral'),
      QuestionOption(id: 16, icon: Icons.tag_rounded, text: 'Social Media (Instagram / X / LinkedIn)'),
      QuestionOption(id: 17, icon: Icons.search_rounded, text: 'Search Engine or Blog Post'),
      QuestionOption(id: 18, icon: Icons.auto_stories_rounded, text: 'App Store Recommendations'),
    ],
  ),
];