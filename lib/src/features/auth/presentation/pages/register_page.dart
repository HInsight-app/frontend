import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hinsight/core.dart';
import 'package:hinsight/src/core/widgets/app_snack_bar.dart';
import 'package:hinsight/src/features/auth/presentation/controllers/auth_controller.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Pop Up ERROR message
  void _showErrorPopup(String message) {
    showAppSnackBar(ScaffoldMessenger.of(context), message, isError: true);
  }

  // Validation Bouncer. These rules are stricter than the backend's (name 2+,
  // password 8+), so students never see the backend's raw validation errors.
  Future<void> _handleRegistration() async {
    final username = _nameController.text.trim();
    final email = _emailController.text.trim();
    // Not trimmed: spaces can be part of a password.
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (username.length < 4) {
      _showErrorPopup('Username must be at least 4 characters long.');
      return;
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      _showErrorPopup('Please enter a valid email address.');
      return;
    }
    // Regex looks for: (?=.*[A-Z]) -> Capital, (?=.*\d) -> Number, .{8,} -> 8+ length
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$');
    if (!passwordRegex.hasMatch(password)) {
      _showErrorPopup(
          'Password must be 8+ characters, with 1 capital letter and 1 number.');
      return;
    }
    if (password != confirmPassword) {
      _showErrorPopup('Passwords do not match.');
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _isLoading = true;
    });
    try {
      // Creates the account and signs in (the session is remembered)
      final user = await ref.read(authControllerProvider.notifier).register(
            displayName: username,
            email: email,
            password: password,
          );
      showAppSnackBar(messenger, 'Welcome to HInsight, ${user.displayName}!');
      // The router also does this on its own, except in the web preview.
      if (mounted) context.go('/');
    } catch (e) {
      // ApiException carries the backend's message
      showAppSnackBar(messenger, e.toString(), isError: true);
    } finally {
      // Stop loading spinner
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // HEADER
              Text(
                'Create Account',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Join HInsight to improve your decision-making.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              AppTextField(
                label: 'Username',
                hint: 'Enter your username',
                controller: _nameController,
              ),
              const SizedBox(height: 16),

              AppTextField(
                label: 'Email',
                hint: 'example@gmail.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              AppTextField(
                label: 'Password',
                hint: 'Enter your password',
                controller: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 16),

              AppTextField(
                label: 'Confirm Password',
                hint: 'Confirm your Password',
                controller: _confirmPasswordController,
                isPassword: true,
              ),

              const SizedBox(height: 32),

              // REGISTER BUTTON
              AppButton(
                text: 'Sign Up',
                isLoading: _isLoading,
                onPressed: _handleRegistration,
              ),

              const SizedBox(height: 32),

              // GO BACK TO LOGIN PAGE
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      // Back to Login; go there directly if Register was
                      // opened without Login underneath (e.g. from a URL).
                      context.canPop() ? context.pop() : context.go('/login');
                    },
                    // Purple and bold come from AppTheme's textButtonTheme
                    child: const Text('Login'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
