import 'dart:ui';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = false;

    return Drawer(
      backgroundColor: Colors.grey[900]?.withOpacity(0.85),
      elevation: 0,
      child: Stack(
        children: [
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  border: Border(
                    right: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isLoggedIn, context),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _menuItem(context,Icons.home_rounded, "Home" ,isActive: true),
                      _menuItem(context,Icons.leaderboard_rounded ,"Leaderboard"),
                      _menuItem(context,Icons.insights_rounded ,"Activity"),
                      _menuItem(context,Icons.favorite_rounded ,"Favorites"),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        child: Divider(color: Colors.white10, thickness: 1),
                      ),
                      _menuItem(context,Icons.settings_suggest_rounded, "Settings"),
                      _menuItem(context, Icons.contact_support_rounded ,"Support"),
                    ],
                  ),
                ),
                if (isLoggedIn) _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isLoggedIn, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Gradient looks more premium than solid colors
          gradient: LinearGradient(
            colors: [Colors.blueAccent.withOpacity(0.8), Colors.blue.shade800],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24, width: 2),
              ),
              child: const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage('https://placehold.net/avatar.png'),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLoggedIn ? "Ajay Singh" : "Welcome!",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Text(
                    "Full Stack Dev",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context , IconData icon, String title, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isActive ? Colors.white.withOpacity(0.1) : Colors.transparent,
      ),
      child: ListTile(
        onTap: () {},
        dense: true,
        visualDensity: VisualDensity.compact,
        leading: Icon(
          icon,
          color: isActive ? Colors.blueAccent : Colors.white60,
          size: 22,
        ),
        title: Text(

          title,
          style:Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: isActive ? const Color(0xFFF5F5F5) : Colors.white.withOpacity(0.7),
            fontSize: 18,
            fontWeight: isActive ? FontWeight.w500 : FontWeight.w300,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white10, width: 1)),
      ),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: const [
            Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
            SizedBox(width: 12),
            Text(
              "Sign Out",
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}