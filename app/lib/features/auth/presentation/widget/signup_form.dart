import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool showPasswordField = false;
  bool _isLoading = false;
  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 10),
          TextFormField(
            style: Theme.of(context).textTheme.bodySmall,
            controller: _nameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: 'Your name',
              hintStyle: TextStyle(
                color: themeColors.onSecondary,
                fontSize: 14,
              ),
              filled: true,
              fillColor: themeColors.secondary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter a Name';
              }

              if (value.length < 3) {
                return 'Name must be at least 3 characters long';
              }

              return null;
            },
          ),
          // --- EMAIL ---
          const SizedBox(height: 12),
          Text('Email', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          TextFormField(
            style: Theme.of(context).textTheme.bodySmall,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Enter your email address',
              hintStyle: TextStyle(
                color: themeColors.onSecondary,
                fontSize: 14,
              ),
              filled: true,
              fillColor: themeColors.secondary,
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
            const SizedBox(height: 20),
            Text('Password', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 10),
            TextFormField(
              style: Theme.of(context).textTheme.bodySmall,
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: _isPasswordObscured,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                hintStyle: TextStyle(
                  color: themeColors.onSecondary,
                  fontSize: 14,
                ),
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

            // const SizedBox(height: 10),
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
                          'Submit',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: themeColors.onPrimary),
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
