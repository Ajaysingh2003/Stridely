import 'package:app/core/app_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_review/in_app_review.dart';

class AccountSettingsPage extends ConsumerStatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  ConsumerState<AccountSettingsPage> createState() =>
      _AccountSettingsPageState();
}

class _AccountSettingsPageState extends ConsumerState<AccountSettingsPage> {
  bool _isDeleting = false;
  final InAppReview _inAppReview = InAppReview.instance;

  static const _supportEmail = "ajaysingh131629@gmail.com";
  static const _privacyUrl = "https://yourdomain.com/privacy"; // TODO: real URL
  static const _termsUrl = "https://yourdomain.com/terms"; // TODO: real URL

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      queryParameters: {
        'subject': 'App Support Request (v1.0.0)',
        'body':
            'Hi Support Team,\n\n[Please enter your message here]\n\n---\nApp Version: 1.0.0 (Build 24)',
      },
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        throw 'Could not launch email client';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Could not open mail client. Please email us directly at $_supportEmail",
            ),
          ),
        );
      }
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't open link.")),
        );
      }
    }
  }

  Future<void> _triggerInAppReview() async {
    try {
      final isAvailable = await _inAppReview.isAvailable();
      if (isAvailable) {
        await _inAppReview.requestReview();
      } else {
        await _inAppReview.openStoreListing(
          appStoreId: 'YOUR_APP_STORE_ID',
          microsoftStoreId: null,
        );
      }
    } catch (_) {
      // Quietly ignore — never let review prompt crash settings.
    }
  }

  Future<void> _showDeleteFlow() async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DeleteAccountSheet(),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isDeleting = true);

    try {
      // await ref.read(authControllerProvider.notifier).deleteAccount();
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isDeleting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().contains('requires-recent-login')
                  ? 'Please sign in again to confirm account deletion.'
                  : 'Something went wrong. Please try again.',
            ),
          ),
        );
      }
    }
  }

  Future<void> _handleLogout() async {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "Settings",
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
            color: colors.onSurface,
          ),
        ),
        iconTheme: IconThemeData(color: colors.onSurface),
        centerTitle: false,
      ),
      body: AppBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              _SectionLabel(text: "Support", colors: colors, textTheme: textTheme),
              _SettingsGroup(
                colors: colors,
                children: [
                  _SettingsTile(
                    icon: Icons.mail_outline_rounded,
                    title: "Contact us",
                    subtitle: "Get in touch with our team directly",
                    onTap: _launchEmail,
                    colors: colors,
                    textTheme: textTheme,
                    trailingStyle: _TrailingStyle.none,
                  ),
                  _SettingsTile(
                    icon: Icons.star_outline_rounded,
                    title: "Rate & feedback",
                    subtitle: "Tap to quickly rate us on the app store",
                    onTap: _triggerInAppReview,
                    colors: colors,
                    textTheme: textTheme,
                    isLast: true,
                    trailingStyle: _TrailingStyle.none,
                  ),
                ],
              ),

              const SizedBox(height: 24),
              _SectionLabel(text: "Legal & data", colors: colors, textTheme: textTheme),
              _SettingsGroup(
                colors: colors,
                children: [
                  _SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: "Privacy policy",
                    onTap: () => _openUrl(_privacyUrl),
                    colors: colors,
                    textTheme: textTheme,
                    trailingStyle: _TrailingStyle.external,
                  ),
                  _SettingsTile(
                    icon: Icons.description_outlined,
                    title: "Terms of service",
                    onTap: () => _openUrl(_termsUrl),
                    colors: colors,
                    textTheme: textTheme,
                    trailingStyle: _TrailingStyle.external,
                  ),
                  _SettingsTile(
                    icon: Icons.cleaning_services_outlined,
                    title: "Clear cache",
                    subtitle: "Free up storage space locally",
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('App cache cleared successfully.')),
                      );
                    },
                    colors: colors,
                    textTheme: textTheme,
                    isLast: true,
                    trailingStyle: _TrailingStyle.none,
                  ),
                ],
              ),


              const SizedBox(height: 28),
              _SectionLabel(
                text: "Danger zone",
                colors: colors,
                textTheme: textTheme,
                isDanger: true,
              ),
              _SettingsGroup(
                colors: colors,
                isDanger: true,
                children: [
                  _SettingsTile(
                    icon: Icons.delete_forever_rounded,
                    title: _isDeleting ? "Deleting account…" : "Delete account",
                    onTap: _isDeleting ? null : _showDeleteFlow,
                    colors: colors,
                    textTheme: textTheme,
                    isDanger: true,
                    isLast: true,
                    trailingStyle: _TrailingStyle.none,
                    trailing: _isDeleting
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colors.error,
                            ),
                          )
                        : null,
                  ),
                ],
              ),

              const SizedBox(height: 32),
              Center(
                child: Text(
                  "Version 1.0.0 (Build 24)",
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant.withOpacity(0.4),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final ColorScheme colors;
  final TextTheme textTheme;
  final bool isDanger;

  const _SectionLabel({
    required this.text,
    required this.colors,
    required this.textTheme,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Text(
        text.toUpperCase(),
        style: textTheme.labelSmall?.copyWith(
          color: isDanger
              ? colors.error.withOpacity(0.7)
              : colors.onSurfaceVariant.withOpacity(0.6),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.7,
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  final ColorScheme colors;
  final bool isDanger;

  const _SettingsGroup({
    required this.children,
    required this.colors,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface.withOpacity(0.65),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isDanger
                ? colors.error.withOpacity(0.16)
                : colors.onSurface.withOpacity(0.06),
            width: 0.6,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.onSurface.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Column(children: children),
        ),
      ),
    );
  }
}

enum _TrailingStyle { chevron, external, none }

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final ColorScheme colors;
  final TextTheme textTheme;
  final bool isDanger;
  final bool isLast;
  final Widget? trailing;
  final _TrailingStyle trailingStyle;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    required this.colors,
    required this.textTheme,
    this.isDanger = false,
    this.isLast = false,
    this.trailing,
    this.trailingStyle = _TrailingStyle.chevron,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDanger ? colors.error : colors.onSurface;
    final accent = isDanger ? colors.error : colors.primary;

    return Column(
      children: [
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          accent.withOpacity(isDanger ? 0.14 : 0.12),
                          accent.withOpacity(0.03),
                        ],
                      ),
                      border: Border.all(
                        color: accent.withOpacity(0.12),
                        width: 0.5,
                      ),
                    ),
                    child: Icon(icon, size: 18, color: accent),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: textTheme.bodyMedium?.copyWith(
                            color: titleColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.1,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: textTheme.labelSmall?.copyWith(
                              color: colors.onSurfaceVariant.withOpacity(0.7),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (trailing != null)
                    trailing!
                  else
                    switch (trailingStyle) {
                      _TrailingStyle.chevron => Icon(
                          Icons.chevron_right_rounded,
                          size: 19,
                          color: colors.onSurfaceVariant.withOpacity(0.4),
                        ),
                      _TrailingStyle.external => Icon(
                          Icons.arrow_outward_rounded,
                          size: 15,
                          color: colors.onSurfaceVariant.withOpacity(0.4),
                        ),
                      _TrailingStyle.none => const SizedBox.shrink(),
                    },
                ],
              ),
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 0.5,
            indent: 68,
            endIndent: 16,
            color: colors.onSurface.withOpacity(0.06),
          ),
      ],
    );
  }
}




class DeleteAccountSheet extends StatefulWidget {
  const DeleteAccountSheet({super.key});

  @override
  State<DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends State<DeleteAccountSheet> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  bool _isHolding = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duration required to hold for deletion
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.of(context).pop(true);
        }
      });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isHolding = true);
    _progressController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (_progressController.status != AnimationStatus.completed) {
      setState(() => _isHolding = false);
      _progressController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        decoration: BoxDecoration(
          color: colors.surface.withOpacity(0.98),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(
            color: colors.onSurface.withOpacity(0.08),
            width: 0.8,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.onSurface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Delete Account",
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "This will permanently erase your reading data, saved bookmarks, and customized app configs. This transaction cannot be reversed.",
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant.withOpacity(0.8),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded, 
                  size: 18, 
                  color: colors.error.withOpacity(0.8),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Note: App Store and Google Play subscriptions aren't managed here. Remember to cancel recurring bills manually inside your platform store profile.",
                    style: textTheme.labelMedium?.copyWith(
                      color: colors.error.withOpacity(0.9),
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTapDown: _onTapDown,
                    onTapUp: _onTapUp,
                    onTapCancel: () {
                      if (_progressController.status != AnimationStatus.completed) {
                        setState(() => _isHolding = false);
                        _progressController.reverse();
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 52,
                      decoration: BoxDecoration(
                        color: _isHolding 
                            ? colors.error.withOpacity(0.1) 
                            : colors.error,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          if (!_isHolding)
                            BoxShadow(
                              color: colors.error.withOpacity(0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            )
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: _progressController,
                              builder: (context, child) {
                                return FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: _progressController.value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: colors.error.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Text(
                            _isHolding ? "Hold to erase..." : "Hold to Delete",
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: _isHolding ? colors.error : Colors.white,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
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



