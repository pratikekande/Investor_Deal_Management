import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;
  bool _isLoading = false;
  String _selectedRole = 'Investor'; // 'Investor' or 'Corporate'

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D1B3E),
              Color(0xFF0A0F2C),
              Color(0xFF060B1E),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Top App Bar
                  _buildAppBar(deviceWidth, deviceHeight),

                  // Divider
                  Divider(
                    color: const Color(0xFF1E2A45),
                    thickness: 1,
                    height: 1,
                  ),

                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: deviceWidth * 0.06,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: deviceHeight * 0.03),

                          // Header
                          Text(
                            'Create Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: deviceWidth * 0.075,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          SizedBox(height: deviceHeight * 0.008),

                          Text(
                            'Join DealFlow and start your investment journey',
                            style: TextStyle(
                              color: const Color(0xFF94A3B8),
                              fontSize: deviceWidth * 0.038,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          SizedBox(height: deviceHeight * 0.03),

                          // Role label
                          Text(
                            'I AM A...',
                            style: TextStyle(
                              color: const Color(0xFF94A3B8),
                              fontSize: deviceWidth * 0.032,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),

                          SizedBox(height: deviceHeight * 0.015),

                          // Role selection cards
                          Row(
                            children: [
                              Expanded(
                                child: _buildRoleCard(
                                  role: 'Investor',
                                  icon: Icons.person_outline_rounded,
                                  deviceWidth: deviceWidth,
                                  deviceHeight: deviceHeight,
                                ),
                              ),
                              SizedBox(width: deviceWidth * 0.04),
                              Expanded(
                                child: _buildRoleCard(
                                  role: 'Corporate',
                                  icon: Icons.business_outlined,
                                  deviceWidth: deviceWidth,
                                  deviceHeight: deviceHeight,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: deviceHeight * 0.03),

                          // Full Name field
                          _buildTextField(
                            controller: _nameController,
                            hint: 'Full Name',
                            prefixIcon: Icons.person_outline_rounded,
                            deviceWidth: deviceWidth,
                            deviceHeight: deviceHeight,
                            keyboardType: TextInputType.name,
                          ),

                          SizedBox(height: deviceHeight * 0.016),

                          // Email field
                          _buildTextField(
                            controller: _emailController,
                            hint: 'Email Address',
                            prefixIcon: Icons.mail_outline_rounded,
                            deviceWidth: deviceWidth,
                            deviceHeight: deviceHeight,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          SizedBox(height: deviceHeight * 0.016),

                          // Password field
                          _buildTextField(
                            controller: _passwordController,
                            hint: 'Password',
                            prefixIcon: Icons.lock_outline_rounded,
                            deviceWidth: deviceWidth,
                            deviceHeight: deviceHeight,
                            isPassword: true,
                            obscureText: _obscurePassword,
                            onTogglePassword: () {
                              setState(
                                  () => _obscurePassword = !_obscurePassword);
                            },
                          ),

                          SizedBox(height: deviceHeight * 0.016),

                          // Confirm Password field
                          _buildTextField(
                            controller: _confirmPasswordController,
                            hint: 'Confirm Password',
                            prefixIcon: Icons.lock_outline_rounded,
                            deviceWidth: deviceWidth,
                            deviceHeight: deviceHeight,
                            isPassword: true,
                            obscureText: _obscureConfirmPassword,
                            onTogglePassword: () {
                              setState(() => _obscureConfirmPassword =
                                  !_obscureConfirmPassword);
                            },
                          ),

                          SizedBox(height: deviceHeight * 0.025),

                          // Terms & Conditions row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(
                                      () => _agreedToTerms = !_agreedToTerms);
                                },
                                child: Container(
                                  width: deviceWidth * 0.055,
                                  height: deviceWidth * 0.055,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        deviceWidth * 0.012),
                                    border: Border.all(
                                      color: _agreedToTerms
                                          ? const Color(0xFF3B82F6)
                                          : const Color(0xFF94A3B8),
                                      width: 1.5,
                                    ),
                                    color: _agreedToTerms
                                        ? const Color(0xFF3B82F6)
                                            .withOpacity(0.2)
                                        : Colors.transparent,
                                  ),
                                  child: _agreedToTerms
                                      ? Icon(
                                          Icons.check_rounded,
                                          color: const Color(0xFF3B82F6),
                                          size: deviceWidth * 0.038,
                                        )
                                      : null,
                                ),
                              ),
                              SizedBox(width: deviceWidth * 0.03),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: const Color(0xFF94A3B8),
                                      fontSize: deviceWidth * 0.036,
                                      height: 1.5,
                                    ),
                                    children: [
                                      const TextSpan(text: 'I agree to the '),
                                      TextSpan(
                                        text: 'Terms & Conditions',
                                        style: TextStyle(
                                          color: const Color(0xFF3B82F6),
                                          fontWeight: FontWeight.w600,
                                          fontSize: deviceWidth * 0.036,
                                        ),
                                      ),
                                      const TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          color: const Color(0xFF3B82F6),
                                          fontWeight: FontWeight.w600,
                                          fontSize: deviceWidth * 0.036,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: deviceHeight * 0.03),

                          // Create Account button
                          GestureDetector(
                            onTap: _isLoading ? null : _handleSignUp,
                            child: Container(
                              width: deviceWidth,
                              height: deviceHeight * 0.068,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.04),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF1E3A8A),
                                    Color(0xFF3B82F6),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF3B82F6)
                                        .withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        'Create Account',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: deviceWidth * 0.045,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                              ),
                            ),
                          ),

                          SizedBox(height: deviceHeight * 0.03),

                          // Sign In row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: const Color(0xFF94A3B8),
                                  fontSize: deviceWidth * 0.038,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // TODO: Navigate back to SignIn
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: const Color(0xFF3B82F6),
                                    fontSize: deviceWidth * 0.038,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: deviceHeight * 0.03),
                        ],
                      ),
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

  Widget _buildAppBar(double deviceWidth, double deviceHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: deviceWidth * 0.04,
        vertical: deviceHeight * 0.015,
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: deviceWidth * 0.06,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'DealFlow',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: deviceWidth * 0.052,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          // Empty space to balance back button
          SizedBox(width: deviceWidth * 0.06),
        ],
      ),
    );
  }

  Widget _buildRoleCard({
    required String role,
    required IconData icon,
    required double deviceWidth,
    required double deviceHeight,
  }) {
    final bool isSelected = _selectedRole == role;

    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: deviceHeight * 0.13,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1E3A8A).withOpacity(0.3)
              : const Color(0xFF1E2A45),
          borderRadius: BorderRadius.circular(deviceWidth * 0.035),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3B82F6)
                : const Color(0xFF2A3A55),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            // Checkmark top right
            if (isSelected)
              Positioned(
                top: deviceWidth * 0.025,
                right: deviceWidth * 0.025,
                child: Container(
                  width: deviceWidth * 0.055,
                  height: deviceWidth * 0.055,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3B82F6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: deviceWidth * 0.035,
                  ),
                ),
              ),

            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: isSelected
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF94A3B8),
                    size: deviceWidth * 0.08,
                  ),
                  SizedBox(height: deviceHeight * 0.008),
                  Text(
                    role,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                      fontSize: deviceWidth * 0.04,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    required double deviceWidth,
    required double deviceHeight,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      width: deviceWidth,
      height: deviceHeight * 0.072,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A45),
        borderRadius: BorderRadius.circular(deviceWidth * 0.035),
        border: Border.all(
          color: const Color(0xFF2A3A55),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: deviceWidth * 0.04),
          Icon(
            prefixIcon,
            color: const Color(0xFF94A3B8),
            size: deviceWidth * 0.052,
          ),
          SizedBox(width: deviceWidth * 0.03),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword ? obscureText : false,
              keyboardType: keyboardType,
              style: TextStyle(
                color: Colors.white,
                fontSize: deviceWidth * 0.04,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: deviceWidth * 0.04,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (isPassword)
            GestureDetector(
              onTap: onTogglePassword,
              child: Padding(
                padding: EdgeInsets.only(right: deviceWidth * 0.04),
                child: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: const Color(0xFF94A3B8),
                  size: deviceWidth * 0.052,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleSignUp() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Color(0xFF1E2A45),
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Color(0xFF1E2A45),
        ),
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to Terms & Conditions'),
          backgroundColor: Color(0xFF1E2A45),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() => _isLoading = false);

    // TODO: Connect to AuthBloc
    // context.read<AuthBloc>().add(SignUpEvent(
    //   name: _nameController.text,
    //   email: _emailController.text,
    //   password: _passwordController.text,
    //   role: _selectedRole,
    // ));
  }
}