import 'dart:ui';
import 'package:app/features/home/presentation/pages/Collection_screen.dart';
import 'package:app/features/home/presentation/pages/explore_screen.dart';
import 'package:app/features/home/presentation/pages/home_screen.dart';
import 'package:app/features/profile/presentation/screen/profile_screen.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex; // Made non-nullable as it's required for proper rendering
  final ValueChanged<int> onTap; // Made non-nullable to guarantee execution

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface.withOpacity(0.85),
            border: const Border(
              top: BorderSide(
                color: Color(0x1A3B7BFB), 
                width: 0.5,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Color(0xFF3B7BFB),
                      Colors.transparent,
                    ],
                    stops: [0.1, 0.5, 0.9],
                  ),
                ),
              ),
              SafeArea(
                top: false, 
                child: SizedBox(
                  height: 64,
                  child: Row(
                    children: [
                      _buildNavItem(
                        index: 0,
                        icon: Icons.home_filled,
                        activeIcon: Icons.home_filled,
                        label: "Home",
                        context: context,
                      ),
                      _buildNavItem(
                        index: 1,
                        icon: Icons.explore_outlined,
                        activeIcon: Icons.explore,
                        label: "Discover",
                        context: context,
                      ),
                      _buildNavItem(
                        index: 2,
                        icon: Icons.menu_book_outlined,
                        activeIcon: Icons.menu_book,
                        label: "Collection",
                        context: context,
                      ),
                      _buildNavItem(
                        index: 3,
                        icon: Icons.person_outline_rounded,
                        activeIcon: Icons.person,
                        label: "Profile",
                        context: context,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required BuildContext context,
  }) {
    final colors = Theme.of(context).colorScheme;
    final isSelected = currentIndex == index;

    final activeColor = const Color(0xFF3B7BFB);
    final inactiveColor = colors.onSurface.withOpacity(0.45);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(index), // 🔥 FIXED: Un-commented and active!
          splashColor: activeColor.withOpacity(0.08),
          highlightColor: Colors.transparent,
          child: AnimatedScale(
            scale: isSelected ? 1.02 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    key: ValueKey<bool>(isSelected),
                    size: 24,
                    color: isSelected ? activeColor : inactiveColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        letterSpacing: -0.1,
                        color: isSelected ? activeColor : inactiveColor,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  final int initialIndex; // ◄ 1. Add this parameter

  const MainNavigationShell({
    super.key, 
    this.initialIndex = 0, // ◄ 2. Default it to 0 (Home)
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    // 4. Initialize it with the passed value when the widget boots up
    _currentIndex = widget.initialIndex; 
  }

  final List<Widget> _pages = const [
    HomePage(),
    ExplorePage(),
    CollectionPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, 
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; 
          });
        },
      ),
    );
  }
}

