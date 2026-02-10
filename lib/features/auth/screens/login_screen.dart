import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/widgets/glass_card.dart';
import '../../auth/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authServiceProvider).signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      // Navigation is handled by AuthGate listening to stream
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    } finally {
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
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.background, AppColors.surface],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo / Title
                    Text("KHELIFY", style: AppTypography.displayLarge.copyWith(color: AppColors.gold)),
                    const SizedBox(height: 8),
                    Text(
                      "Unleash Your Potential",
                      style: AppTypography.bodyLarge.copyWith(color: AppColors.textTertiary),
                    ),
                    const SizedBox(height: 48),

                    // Login Form Card
                    GlassCard(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text("Welcome Back", style: AppTypography.h2),
                            const SizedBox(height: 24),
                            
                            // Email
                            TextFormField(
                              controller: _emailController,
                              style: AppTypography.bodyMedium.copyWith(color: Colors.white),
                              decoration: _inputDecoration("Email"),
                              validator: (val) => val != null && val.contains('@') ? null : "Enter a valid email",
                            ),
                            const SizedBox(height: 16),
                            
                            // Password
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              style: AppTypography.bodyMedium.copyWith(color: Colors.white),
                              decoration: _inputDecoration("Password"),
                              validator: (val) => val != null && val.length > 5 ? null : "Password too short",
                            ),
                            const SizedBox(height: 24),

                            // Error Message
                            if (_errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Text(
                                  _errorMessage!,
                                  style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent, // Gradient handled by Container but checking ElevatedButton support
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: AppGradients.blue, // Blue as primary action per update
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: _isLoading 
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : Text("LOGIN", style: AppTypography.button),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                         Navigator.of(context).pushNamed('/signup');
                      },
                      child: Text(
                        "Don't have an account? Sign Up",
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.blueLight),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
      filled: true,
      fillColor: AppColors.surfaceLight.withOpacity(0.5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.blue, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}

extension on Color { // Helper for Color(0xFF...) used above as AppColors define custom Color class maybe? No, AppColors uses Color. 
// Just using the AppColors constants.
}
