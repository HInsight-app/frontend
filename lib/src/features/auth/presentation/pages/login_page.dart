import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hinsight/core.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State variable for the checkbox
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),

              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
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
                          activeColor: const Color(0xFFBB86FC),
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
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(fontSize: 14),
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
                onPressed: () {
                  print(
                      "Email: ${_emailController.text}, Remember: $_rememberMe");
                },
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(
                      child: Divider(color: Color(0xFF2C2C2C), thickness: 2)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('OR',
                        style: TextStyle(color: Colors.grey.shade600)),
                  ),
                  const Expanded(
                      child: Divider(color: Color(0xFF2C2C2C), thickness: 2)),
                ],
              ),

              const SizedBox(height: 24),

              // --- GOOGLE LOGIN BUTTON ---
              AppButton(
                  type: ButtonType.outline,
                  icon: FontAwesomeIcons.google,
                  text: 'Continue with Google',
                  onPressed: () {}),
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
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Color(0xFFBB86FC),
                          fontWeight: FontWeight.bold),
                    ),
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
