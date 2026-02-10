import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/widgets/glass_card.dart';
import '../../auth/providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authServiceProvider).signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      // Navigation is handled by AuthGate listening to stream
       // But we might want to pop the signup screen if it was pushed? 
       // AuthGate will handle the root replacement.
       if (mounted) {
         Navigator.of(context).popUntil((route) => route.isFirst);
       }
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: AppGradients.background,
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Join Khelify", style: AppTypography.displayLarge.copyWith(color: AppColors.gold)),
                    const SizedBox(height: 8),
                    Text(
                      "Start your athletic journey today",
                      style: AppTypography.bodyLarge.copyWith(color: AppColors.textTertiary),
                    ),
                    const SizedBox(height: 48),

                    // Signup Form Card
                    GlassCard(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text("Create Account", style: AppTypography.h2),
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
                              validator: (val) => val != null && val.length > 5 ? null : "Password too short (min 6 chars)",
                            ),
                            const SizedBox(height: 16),
                             // Confirm Password
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: true,
                              style: AppTypography.bodyMedium.copyWith(color: Colors.white),
                              decoration: _inputDecoration("Confirm Password"),
                              validator: (val) {
                                if (val != _passwordController.text) return "Passwords do not match";
                                return null;
                              },
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

                            // Signup Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _signup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: AppGradients.blue,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: _isLoading 
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : Text("SIGN UP", style: AppTypography.button),
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
                        Navigator.of(context).pop(); // Go back to Login
                      },
                      child: Text(
                        "Already have an account? Login",
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
