import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hinsight/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:hinsight/src/features/auth/auth.dart';

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

  // Pop Up ERROR message
  void _showErrorPopup(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
      backgroundColor: Colors.redAccent.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    ));
  }

  // Validation Bouncer
  void _handleRegistration() async {
    final username = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

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
      _showErrorPopup('Password do not match.');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      // Setup the Tools
      final baseUrl = dotenv.env['BASE_URL'] ?? '';
      final dio = Dio(BaseOptions(baseUrl: baseUrl));
      const secureStorage = FlutterSecureStorage();

      // Setup the Assembly Line
      final remoteDataSource = AuthRemoteDataSourceImpl(dio: dio);
      final localDataSource =
          AuthLocalDataSourceImpl(secureStorage: secureStorage);
      final repository = AuthRepositoryImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
      );

      final registerUseCase = RegisterUseCase(repository);

      // Execute Registration
      final response = await registerUseCase.execute(username, email, password);

      // Handle Success
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Account Created! You can now login.'),
            backgroundColor: Colors.green),
      );

      // Pop back to the Login screen
      context.pop();
    } catch (e) {
      // Handle Failure
      _showErrorPopup(e.toString());
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
                      color: Colors.grey,
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
