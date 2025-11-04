import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (email.isEmpty) return 'Email is required';
    if (!emailRegex.hasMatch(email)) return 'Invalid email format';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000000),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40),
              
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFFD2B68B), width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFD2B68B).withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(Icons.directions_run, size: 80, color: Color(0xFFD2B68B)),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'KHELIFY',
                      style: GoogleFonts.spaceMono(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD2B68B),
                        letterSpacing: 3,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Fuel Your Potential',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 60),
              
              Text(
                'Email',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color(0xFF1A1A1A),
                  border: Border.all(color: Color(0xFFD2B68B).withOpacity(0.3)),
                ),
                child: TextField(
                  controller: _emailController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: GoogleFonts.montserrat(
                      color: Colors.grey[700],
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(Icons.email, color: Color(0xFFD2B68B)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              
              SizedBox(height: 20),
              
              Text(
                'Password',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color(0xFF1A1A1A),
                  border: Border.all(color: Color(0xFFD2B68B).withOpacity(0.3)),
                ),
                child: TextField(
                  controller: _passwordController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: GoogleFonts.montserrat(
                      color: Colors.grey[700],
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(Icons.lock, color: Color(0xFFD2B68B)),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                      child: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Color(0xFFD2B68B),
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (val) => setState(() => _rememberMe = val ?? false),
                    activeColor: Color(0xFFD2B68B),
                  ),
                  Text(
                    'Remember me',
                    style: GoogleFonts.montserrat(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Forgot password feature coming soon!')),
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.montserrat(
                        color: Color(0xFFD2B68B),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              if (_errorMessage != null) ...[
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.red.withOpacity(0.1),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: GoogleFonts.montserrat(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              SizedBox(height: 28),
              
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _handleLogin(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA41D3C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 8,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Login',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),
              
              SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account? ',
                    style: GoogleFonts.montserrat(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen())),
                    child: Text(
                      'Sign up',
                      style: GoogleFonts.montserrat(
                        color: Color(0xFFD2B68B),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _handleLogin() {
    String? emailError = _validateEmail(_emailController.text);
    
    setState(() {
      if (emailError != null) {
        _errorMessage = emailError;
      } else if (_passwordController.text.isEmpty) {
        _errorMessage = 'Password is required';
      } else if (_passwordController.text.length < 6) {
        _errorMessage = 'Password must be at least 6 characters';
      } else {
        _errorMessage = null;
      }
    });

    if (_errorMessage != null) return;

    setState(() => _isLoading = true);
    
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSuccessDialog();
      }
    });
  }
  
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFA41D3C),
                ),
                child: Icon(Icons.check, color: Colors.white, size: 40),
              ),
              SizedBox(height: 16),
              Text(
                'Welcome!',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Login successful',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFA41D3C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Continue',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}