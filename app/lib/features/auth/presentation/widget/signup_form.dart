import 'package:app/features/auth/presentation/provider/auth_di_providers.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_banner.dart';

class SignupForm extends ConsumerStatefulWidget {
  const SignupForm({super.key});

  @override
  ConsumerState<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends ConsumerState<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPasswordField = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  bool _showSuccess = false;
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _showSuccess = false;
      _errorMessage = "";
    });

    setState(() => _isLoading = true);

    try {
      await ref
          .read(authControllerProvider.notifier)
          .signup(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            displayName: _nameController.text.trim(),
          );

      // if (mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Account created successfully')),
      //   );
      // }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleContinue() {
    if (!_showPasswordField) {
      // Step 1: validate name + email, then reveal password field
      if (_formKey.currentState!.validate()) {
        setState(() => _showPasswordField = true);
      }
    } else {
      // Step 2: full form is visible — submit
      _handleSubmit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

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
          // Name
          Text('Name', style: tt.headlineSmall),
          const SizedBox(height: 10),
          _AuthField(
            controller: _nameController,
            hint: 'Your name',
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            enabled: !_isLoading,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Enter your name.';
              if (v.trim().length < 3)
                return 'Name must be at least 3 characters.';
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Email
          Text('Email', style: tt.headlineSmall),
          const SizedBox(height: 10),
          _AuthField(
            controller: _emailController,
            hint: 'Enter your email address',
            keyboardType: TextInputType.emailAddress,
            enabled: !_isLoading,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Enter your email.';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                return 'Enter a valid email address.';
              }
              return null;
            },
          ),

          // Password — only revealed after step 1
          if (_showPasswordField) ...[
            const SizedBox(height: 20),
            Text('Password', style: tt.headlineSmall),
            const SizedBox(height: 10),
            _AuthField(
              controller: _passwordController,
              hint: 'Enter your password',
              obscureText: _obscurePassword,
              enabled: !_isLoading,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: cs.onSurface.withValues(alpha: 0.4),
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter a password.';
                if (v.length < 6)
                  return 'Password must be at least 6 characters.';
                return null;
              },
            ),
          ],

          if (authState.failure != null) ...[
            const SizedBox(height: 16),
            AuthBanner(message: _errorMessage ?? 'An unknown error occurred', isError: true),
          ],
          if (authState.user != null) ...[
            const SizedBox(height: 16),
            AuthBanner(
              message: 'Account created successfully!',
              isError: false,
            ),
          ],

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _isLoading ? null : _handleContinue,
              child: _isLoading
                  ? SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        color: cs.onPrimary,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      _showPasswordField ? 'Create account' : 'Continue',
                      style: tt.headlineMedium?.copyWith(color: cs.onPrimary),
                    ),
                    
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.suffixIcon,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      textCapitalization: textCapitalization,
      style: Theme.of(context).textTheme.bodySmall,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: cs.onSecondary, fontSize: 14),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: cs.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error),
        ),
      ),
    );
  }
}
