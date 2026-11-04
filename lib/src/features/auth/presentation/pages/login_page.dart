import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:hinsight/core.dart';
import 'package:hinsight/src/core/widgets/app_snack_bar.dart';
import 'package:hinsight/src/features/auth/presentation/controllers/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State variable for the checkbox
  bool _rememberMe = false;

  bool _isLoginLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final messenger = ScaffoldMessenger.of(context);
    final email = _emailController.text.trim();
    // Not trimmed: spaces can be part of a password.
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showAppSnackBar(messenger, 'Enter your email and password.',
          isError: true);
      return;
    }

    setState(() {
      _isLoginLoading = true;
    });

    try {
      final user = await ref.read(authControllerProvider.notifier).login(
            email: email,
            password: password,
            remember: _rememberMe,
          );
      showAppSnackBar(messenger, 'Welcome back, ${user.displayName}!');
      // The router also does this on its own, except in the web preview.
      if (mounted) context.go('/');
    } catch (e) {
      // ApiException carries the backend's message, e.g. "invalid credentials"
      showAppSnackBar(messenger, e.toString(), isError: true);
    } finally {
      // Stop loading spinner
      if (mounted) {
        setState(() {
          _isLoginLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold automatically pulls the dark background from AppTheme
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image placeholder, change to app logo later :>
              SvgPicture.asset(
                'assets/images/undraw_business-decisions.svg',
                height: 200,
              ),
              const SizedBox(height: 40),
              AppTextField(
                label: 'Email',
                hint: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),
              AppTextField(
                label: 'Password',
                hint: 'Password',
                controller: _passwordController,
                isPassword: true,
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Remember me',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- LOGIN BUTTON ---
              AppButton(
                type: ButtonType.primary,
                text: 'Login',
                isLoading: _isLoginLoading, // Hooks up the loading spinner
                onPressed: _login,
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('OR',
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 24),

              // --- GOOGLE LOGIN BUTTON ---
              // The paper (III-D) requires Google sign-in, but it needs a
              // backend endpoint and Google OAuth client IDs first.
              AppButton(
                  type: ButtonType.outline,
                  icon: FontAwesomeIcons.google,
                  text: 'Continue with Google',
                  onPressed: () => showAppSnackBar(
                        ScaffoldMessenger.of(context),
                        "Google sign-in isn't available yet. Please use your email.",
                      )),
              const SizedBox(height: 64),

              // --- ROUTE TO REGISTER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      context.push('/register');
                    },
                    // Purple and bold come from AppTheme's textButtonTheme
                    child: const Text('Sign Up'),
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
