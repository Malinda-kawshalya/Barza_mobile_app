import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordSecurityPage extends StatefulWidget {
  const PasswordSecurityPage({Key? key}) : super(key: key);

  @override
  _PasswordSecurityPageState createState() => _PasswordSecurityPageState();
}

class _PasswordSecurityPageState extends State<PasswordSecurityPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  double _passwordStrength = 0.0;
  String _passwordStrengthLabel = 'Weak';
  Color _passwordStrengthColor = Colors.red;

  void _checkPasswordStrength(String password) {
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = 0.0;
        _passwordStrengthLabel = 'Weak';
        _passwordStrengthColor = Colors.red;
      });
      return;
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    int length = password.length;

    double strength = 0.0;

    if (length >= 8) strength += 0.2;
    if (length >= 12) strength += 0.2;
    if (hasUppercase) strength += 0.2;
    if (hasLowercase) strength += 0.1;
    if (hasDigits) strength += 0.2;
    if (hasSpecialCharacters) strength += 0.3;

    setState(() {
      _passwordStrength = strength.clamp(0.0, 1.0);

      if (_passwordStrength < 0.3) {
        _passwordStrengthLabel = 'Weak';
        _passwordStrengthColor = Colors.red;
      } else if (_passwordStrength < 0.7) {
        _passwordStrengthLabel = 'Moderate';
        _passwordStrengthColor = Colors.orange;
      } else {
        _passwordStrengthLabel = 'Strong';
        _passwordStrengthColor = Colors.green;
      }
    });
  }

  Future<void> _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        User? user = FirebaseAuth.instance.currentUser;
        String email = user?.email ?? '';

        // Reauthenticate the user
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: _currentPasswordController.text.trim(),
        );
        await user?.reauthenticateWithCredential(credential);

        // Update the password
        await user?.updatePassword(_newPasswordController.text.trim());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password updated successfully'),
            backgroundColor: Colors.green,
          ),
        );

        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        setState(() {
          _passwordStrength = 0.0;
          _passwordStrengthLabel = 'Weak';
          _passwordStrengthColor = Colors.red;
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password & Security'),
        backgroundColor: const Color(0xFF0C969C),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  const Icon(
                    Icons.security,
                    size: 80,
                    color: Color(0xFF0C969C),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Change Your Password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0C969C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please enter your current password and choose a new secure password',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (_errorMessage != null) const SizedBox(height: 24),

                  // Current password field
                  TextFormField(
                    controller: _currentPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureCurrentPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureCurrentPassword = !_obscureCurrentPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureCurrentPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your current password';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // New password field
                  TextFormField(
                    controller: _newPasswordController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                      helperText:
                          'Use at least 8 characters with uppercase, numbers and symbols',
                    ),
                    obscureText: _obscureNewPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your new password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                    onChanged: _checkPasswordStrength,
                  ),

                  const SizedBox(height: 10),

                  // Password strength indicator
                  LinearProgressIndicator(
                    value: _passwordStrength,
                    backgroundColor: Colors.grey.shade200,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(_passwordStrengthColor),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Password Strength: $_passwordStrengthLabel',
                        style: TextStyle(
                          color: _passwordStrengthColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Confirm password field
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.lock_clock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureConfirmPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // Update button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _updatePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0C969C),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Update Password',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),

                  const SizedBox(height: 16),

                  // Security tips section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Password Security Tips:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF0C969C),
                          ),
                        ),
                        SizedBox(height: 8),
                        PasswordTipItem(
                          icon: Icons.check_circle_outline,
                          text: 'Use at least 8 characters',
                        ),
                        PasswordTipItem(
                          icon: Icons.check_circle_outline,
                          text: 'Include uppercase and lowercase letters',
                        ),
                        PasswordTipItem(
                          icon: Icons.check_circle_outline,
                          text: 'Include numbers and special characters',
                        ),
                        PasswordTipItem(
                          icon: Icons.check_circle_outline,
                          text: 'Avoid using personal information',
                        ),
                        PasswordTipItem(
                          icon: Icons.check_circle_outline,
                          text: 'Don\'t reuse passwords across sites',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordTipItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const PasswordTipItem({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: const Color(0xFF0C969C),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
