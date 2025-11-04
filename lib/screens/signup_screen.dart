import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _agreeTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              SizedBox(height: 30),
              
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFFD2B68B), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFD2B68B).withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Icon(Icons.directions_run, size: 60, color: Color(0xFFD2B68B)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'KHELIFY',
                      style: GoogleFonts.spaceMono(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD2B68B),
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Sign Up',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 40),
              
              Text(
                'Full Name',
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
                  controller: _nameController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your full name',
                    hintStyle: GoogleFonts.montserrat(
                      color: Colors.grey[700],
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(Icons.person, color: Color(0xFFD2B68B)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              
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
              
              SizedBox(height: 16),
              
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
                    hintText: 'Create a password',
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
              
              Text(
                'Confirm Password',
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
                  controller: _confirmPasswordController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    hintText: 'Confirm your password',
                    hintStyle: GoogleFonts.montserrat(
                      color: Colors.grey[700],
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(Icons.lock, color: Color(0xFFD2B68B)),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      child: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
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
                    value: _agreeTerms,
                    onChanged: (val) => setState(() => _agreeTerms = val ?? false),
                    activeColor: Color(0xFFD2B68B),
                  ),
                  Expanded(
                    child: Text(
                      'I agree to Terms & Conditions',
                      style: GoogleFonts.montserrat(
                        color: Colors.grey[600],
                        fontSize: 12,
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
              
              SizedBox(height: 20),
              
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _handleSignup(),
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
                          'Sign Up',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),
              
              SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[800])),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or',
                      style: GoogleFonts.montserrat(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[800])),
                ],
              ),
              
              SizedBox(height: 16),
              
              SizedBox(
                height: 54,
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Google Sign Up coming soon!')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFFD2B68B), width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.g_mobiledata, color: Color(0xFFD2B68B), size: 24),
                      SizedBox(width: 12),
                      Text(
                        'Continue with Google',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFD2B68B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: GoogleFonts.montserrat(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    ),
                    child: Text(
                      'Login',
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
  
  void _handleSignup() {
    String? emailError = _validateEmail(_emailController.text);
    
    setState(() {
      if (_nameController.text.isEmpty) {
        _errorMessage = 'Name is required';
      } else if (emailError != null) {
        _errorMessage = emailError;
      } else if (_passwordController.text.isEmpty) {
        _errorMessage = 'Password is required';
      } else if (_passwordController.text.length < 6) {
        _errorMessage = 'Password must be at least 6 characters';
      } else if (_passwordController.text != _confirmPasswordController.text) {
        _errorMessage = 'Passwords do not match';
      } else if (!_agreeTerms) {
        _errorMessage = 'Please agree to Terms & Conditions';
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
                'Account Created!',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Welcome to KHELIFY',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFA41D3C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Go to Login',
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