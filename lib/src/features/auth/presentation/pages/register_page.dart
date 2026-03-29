import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                      color: Colors.grey,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // INPUT FIELDS'
              Text(
                'Username',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Display name'),
              ),
              const SizedBox(height: 16),
              Text(
                'Email',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: 'Enter your email'),
              ),
              const SizedBox(height: 16),
              Text(
                'Password',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration:
                    const InputDecoration(hintText: 'Enter your password'),
              ),
              const SizedBox(height: 16),
              Text(
                'Confirm Password',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(hintText: 'Confirm your Password'),
              ),

              const SizedBox(height: 32),

              // REGISTER BUTTON
              AppButton(
                text: 'Sign Up',
                isLoading: _isLoading,
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });

                  // Simulate network request
                  await Future.delayed(const Duration(seconds: 2));

                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
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
                      // Pops the register screen off, returning to Login
                      context.pop();
                    },
                    child: const Text(
                      'Login',
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
