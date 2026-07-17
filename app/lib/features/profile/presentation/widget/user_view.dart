import 'dart:ui';
import 'package:app/core/func/Navigate.dart';
import 'package:app/features/auth/presentation/pages/login_screen.dart';
import 'package:app/features/auth/presentation/provider/auth_di_providers.dart';
import 'package:app/features/profile/presentation/screen/account_setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserView extends ConsumerStatefulWidget {
  const UserView({super.key});

  @override
  ConsumerState<UserView> createState() => _UserViewState();
}

class _UserViewState extends ConsumerState<UserView> {
  @override
  Widget build(BuildContext context) {
    final authStateAsync = ref.watch(authStateStreamProvider);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return authStateAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Something went wrong',
            style: textTheme.bodyMedium?.copyWith(color: colors.error),
          ),
        ),
      ),
      data: (user) {
        if (user == null)
          return _LoggedOutCard(colors: colors, textTheme: textTheme);

        final String? photoUrl = user.imgUrl;
        final String name = user.name ?? "Reader";
        final String email = user.email ?? "No email linked";

        return _LoggedInCard(
          colors: colors,
          textTheme: textTheme,
          photoUrl: photoUrl,
          name: name,
          email: email,
          onSignOut: () => ref.read(authControllerProvider.notifier).logout(),
        );
      },
    );
  }
}

// ─── GLASS CARD SHELL ────────────────────────────────────────────────────
// Shared frosted shell so both states sit consistently on top of
// AppBackground's soft gradient glow instead of as a flat opaque box.
class _GlassShell extends StatelessWidget {
  final Widget child;
  final ColorScheme colors;

  const _GlassShell({required this.child, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface.withOpacity(0.55),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: colors.onSurface.withOpacity(0.06),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.onSurface.withOpacity(0.04),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ─── LOGGED OUT STATE ────────────────────────────────────────────────────
class _LoggedOutCard extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme textTheme;

  const _LoggedOutCard({required this.colors, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return _GlassShell(
      colors: colors,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.primary.withOpacity(0.16),
                    colors.primary.withOpacity(0.04),
                  ],
                ),
                border: Border.all(
                  color: colors.primary.withOpacity(0.18),
                  width: 0.5,
                ),
              ),
              child: Icon(
                Icons.menu_book_rounded,
                size: 26,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              "Read without limits",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Sign in to sync your progress, bookmarks, and premium collections across devices.",
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: colors.primary,
                  foregroundColor: colors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                onPressed: () =>
                    moveTo(context, const LoginPage(), "login-page"),
                child: Text(
                  "Continue to account",
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── LOGGED IN STATE ─────────────────────────────────────────────────────
class _LoggedInCard extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme textTheme;
  final String? photoUrl;
  final String name;
  final String email;
  final VoidCallback onSignOut;

  const _LoggedInCard({
    required this.colors,
    required this.textTheme,
    required this.photoUrl,
    required this.name,
    required this.email,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassShell(
      colors: colors,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colors.primary.withOpacity(0.5),
                        colors.primary.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: ClipOval(
                    child: photoUrl != null && photoUrl!.isNotEmpty
                        ? Image.network(
                            photoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, _, __) =>
                                _FallbackAvatar(colors: colors),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: colors.surfaceContainerHighest,
                                child: const Center(
                                  child: SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : _FallbackAvatar(colors: colors),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _MemberBadge(colors: colors, textTheme: textTheme),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Divider(
                height: 1,
                thickness: 0.5,
                color: colors.onSurface.withOpacity(0.08),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // In _LoggedInCard, replace the static "Manage account" Text with:
                InkWell(
                  onTap: () => moveTo(
                    context,
                    const AccountSettingsPage(),
                    "account-settings-page",
                  ),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "Manage account",
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: onSignOut,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          size: 15,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Sign out",
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberBadge extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme textTheme;

  const _MemberBadge({required this.colors, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: colors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "PRO",
        style: textTheme.labelSmall?.copyWith(
          color: colors.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _FallbackAvatar extends StatelessWidget {
  final ColorScheme colors;
  const _FallbackAvatar({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.surfaceContainerHighest,
      child: Icon(Icons.person_rounded, size: 26, color: colors.primary),
    );
  }
}
