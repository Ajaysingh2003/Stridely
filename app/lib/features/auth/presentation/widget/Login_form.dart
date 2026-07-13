import 'package:app/features/auth/presentation/provider/auth_di_providers.dart';
import 'package:app/features/auth/presentation/widget/auth_banner.dart';
import 'package:app/features/home/presentation/pages/home_screen.dart';
import 'package:app/features/subscriptions/service/init.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool showPasswordField = false;
  bool _isLoading = false;
  bool _isPasswordObscured = true;
  String? _errorMessage;
  bool _showSuccess = false;

  @override
  void dispose() {
    // Simple, clean disposal without worrying about lingering listeners
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Future<void> _handleSubmit() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   setState(() {
  //     _showSuccess = false;
  //     _errorMessage = "";
  //   });

  //   setState(() => _isLoading = true);

  //   try {
  //     await ref
  //         .read(authControllerProvider.notifier)
  //         .login(
  //           email: _emailController.text.trim(),
  //           password: _passwordController.text.trim(),
  //         );

  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => const HomePage()),
  //         );
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text(e.toString())));
  //     }
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }
  // }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _showSuccess = false;
      _errorMessage = "";
      _isLoading = true; // Unified state execution
    });

    try {
      // 1. Await network authentication response
      await ref
          .read(authControllerProvider.notifier)
          .login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      final user = ref.read(authControllerProvider).user;

      if (user != null) {
        // Pass the real Firebase UID instead of the '/' placeholder
        await RevenueCatService.instance.loginUser(user);
      } else {
        debugPrint("⚠️ Auth succeeded, but user object or UID was null.");
      }
      // RevenueCatService.instance.loginUser(userId);

      // ── 🎯 CRITICAL FIX: Verify widget tree state after async operation ──
      if (!mounted) return;

      // 2. Perform safe context-driven navigation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleContinueAction() {
    if (!showPasswordField) {
      final emailInput = _emailController.text.trim();

      if (emailInput.contains('@')) {
        setState(() {
          _formKey.currentState!.validate();
          showPasswordField = true;
        });
      } else {
        _formKey.currentState!.validate();
      }
    } else {
      if (_formKey.currentState!.validate()) {
        setState(() => _isLoading = true);

        // Simulate API login sequence
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Login Successful')));
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;

    final authState = ref.watch(authControllerProvider);

    final isAppLoading = authState.isLoading;

    ref.listen(authControllerProvider, (previous, next) {
      if (next.failure != null) {
        setState(() {
          _errorMessage = next.failure?.message;
          _showSuccess = false;
        });
      } else if (next.user != null) {
        setState(() {
          _errorMessage = null;
          _showSuccess = true;
        });
      }
    });
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- EMAIL ---
          Text('Email', style: Theme.of(context).textTheme.headlineSmall),

          const SizedBox(height: 12),
          TextFormField(
            style: Theme.of(context).textTheme.bodySmall,

            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Enter your email address',
              hintStyle: const TextStyle(color: Colors.black, fontSize: 14),
              filled: true,
              fillColor: const Color(0xFFF3F3F3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || !value.contains('@')) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          // --- CONDITIONAL PASSWORD SECTION ---
          if (showPasswordField) ...[
            const SizedBox(height: 12),
            Text('Password', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            TextFormField(
              style: Theme.of(context).textTheme.bodySmall,
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: _isPasswordObscured,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                filled: true,
                fillColor: themeColors.secondary,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordObscured
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordObscured = !_isPasswordObscured;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor:
                      Colors.white70, // Text color (and ripple color)
                  minimumSize:
                      Size.zero, // Removes default padding restrictions
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  tapTargetSize: MaterialTapTargetSize
                      .shrinkWrap, // Shrinks the hit test box to fit nicely
                ),
                onPressed: () {
                  // Navigate to reset password screen
                },
                child: Text(
                  "Forgot Password?",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ),
          ],

          if (authState.failure != null) ...[
            const SizedBox(height: 16),
            AuthBanner(
              message: _errorMessage ?? 'An unknown error occurred',
              isError: true,
            ),
          ],
          if (authState.user != null) ...[
            const SizedBox(height: 16),
            AuthBanner(message: 'Login successfully!', isError: false),
          ],

          const SizedBox(height: 15),

          // --- CONTROL BUTTON ---
          if (!showPasswordField)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      // Your exact custom Color rgb(33, 33, 33)
                      color: const Color.fromARGB(
                        255,
                        33,
                        33,
                        33,
                      ).withOpacity(0.1),

                      blurRadius: 1,

                      // Increased slightly so it evenly expands outwards past the button edges
                      spreadRadius: 1.5,

                      // Changed to zero so the shadow doesn't drop down to the bottom
                      offset: Offset.zero,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColors.primary,
                    // foregroundColor: Colors.black,
                    elevation: 0,
                    // shadowColor: themeColors.secondary.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _handleContinueAction,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Continue',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: themeColors.onPrimary),
                        ),
                ),
              ),
            ),

          if (showPasswordField)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _handleSubmit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Login',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: themeColors.onPrimary),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
