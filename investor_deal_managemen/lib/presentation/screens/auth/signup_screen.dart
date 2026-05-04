import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_event.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_state.dart';
import 'package:investor_deal_managemen/presentation/screens/auth/signin_screen.dart';

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

  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  String _selectedRole = 'Investor';

  late AnimationController _fadeController;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _itemAnimations = List.generate(5, (i) {
      final start = i * 0.12;
      final end = (start + 0.45).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _fadeController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _animated(int index, Widget child) {
    return AnimatedBuilder(
      animation: _itemAnimations[index],
      builder: (context, _) {
        final v = _itemAnimations[index].value;
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, 16 * (1 - v)),
            child: child,
          ),
        );
      },
    );
  }

  void _handleSignUp(BuildContext context) {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please fill in all fields',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color(0xFF1E3A8A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please agree to Terms & Conditions',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color(0xFF1E3A8A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
          SignUpEvent(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            role: _selectedRole.toLowerCase(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                '🎉 Account created successfully! Please sign in.',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: const Color(0xFF22C55E),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          context.read<AuthBloc>().add(SignOutEvent());
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const SignInScreen()),
            (route) => false,
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: const Color(0xFFEF4444),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final bool isLoading = state is AuthLoading;

        return Scaffold(
          // ← resizeToAvoidBottomInset true so keyboard pushes content up
          resizeToAvoidBottomInset: true,
          body: Container(
            width: w,
            height: h,
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
              child: SingleChildScrollView(
                // ← scroll added
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: h * 0.03),

                    // Logo + App Name
                    _animated(
                      0,
                      Column(
                        children: [
                          Container(
                            width: w * 0.16,
                            height: w * 0.16,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(w * 0.036),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF3B82F6).withOpacity(0.35),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'DF',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: w * 0.058,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: h * 0.01),
                          Text(
                            'DEALFLOW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: w * 0.045,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: h * 0.022),

                    // Header
                    _animated(
                      1,
                      Column(
                        children: [
                          Text(
                            'Create Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: w * 0.062,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: h * 0.005),
                          Text(
                            'Join DealFlow and start your investment journey',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF94A3B8),
                              fontSize: w * 0.033,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: h * 0.022),

                    // Role selection
                    _animated(
                      2,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'I AM A...',
                            style: TextStyle(
                              color: const Color(0xFF94A3B8),
                              fontSize: w * 0.028,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: h * 0.01),
                          Row(
                            children: [
                              Expanded(
                                child: _buildRoleCard(
                                  role: 'Investor',
                                  icon: Icons.person_outline_rounded,
                                  w: w,
                                  h: h,
                                ),
                              ),
                              SizedBox(width: w * 0.04),
                              Expanded(
                                child: _buildRoleCard(
                                  role: 'Corporate',
                                  icon: Icons.business_outlined,
                                  w: w,
                                  h: h,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: h * 0.022),

                    // Form fields
                    _animated(
                      3,
                      Column(
                        children: [
                          _buildTextField(
                            controller: _nameController,
                            hint: 'Full Name',
                            prefixIcon: Icons.person_outline_rounded,
                            w: w,
                            h: h,
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(height: h * 0.014),
                          _buildTextField(
                            controller: _emailController,
                            hint: 'Email Address',
                            prefixIcon: Icons.mail_outline_rounded,
                            w: w,
                            h: h,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: h * 0.014),
                          _buildTextField(
                            controller: _passwordController,
                            hint: 'Password',
                            prefixIcon: Icons.lock_outline_rounded,
                            w: w,
                            h: h,
                            isPassword: true,
                            obscureText: _obscurePassword,
                            onTogglePassword: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: h * 0.018),

                    // Terms + button
                    _animated(
                      4,
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => setState(
                                    () => _agreedToTerms = !_agreedToTerms),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: w * 0.048,
                                  height: w * 0.048,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(w * 0.011),
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
                                          size: w * 0.032,
                                        )
                                      : null,
                                ),
                              ),
                              SizedBox(width: w * 0.025),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: const Color(0xFF94A3B8),
                                      fontSize: w * 0.031,
                                      height: 1.4,
                                    ),
                                    children: [
                                      const TextSpan(text: 'I agree to the '),
                                      TextSpan(
                                        text: 'Terms & Conditions',
                                        style: TextStyle(
                                          color: const Color(0xFF3B82F6),
                                          fontWeight: FontWeight.w600,
                                          fontSize: w * 0.031,
                                        ),
                                      ),
                                      const TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          color: const Color(0xFF3B82F6),
                                          fontWeight: FontWeight.w600,
                                          fontSize: w * 0.031,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: h * 0.022),

                          // Create Account button
                          GestureDetector(
                            onTap:
                                isLoading ? null : () => _handleSignUp(context),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: w,
                              height: h * 0.064,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(w * 0.04),
                                gradient: LinearGradient(
                                  colors: isLoading
                                      ? [
                                          const Color(0xFF1E3A8A)
                                              .withOpacity(0.6),
                                          const Color(0xFF3B82F6)
                                              .withOpacity(0.6),
                                        ]
                                      : const [
                                          Color(0xFF1E3A8A),
                                          Color(0xFF3B82F6),
                                        ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF3B82F6)
                                        .withOpacity(0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        'Create Account',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: w * 0.042,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                              ),
                            ),
                          ),

                          SizedBox(height: h * 0.02),

                          // Sign In row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: const Color(0xFF94A3B8),
                                  fontSize: w * 0.034,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: const Color(0xFF3B82F6),
                                    fontSize: w * 0.034,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: h * 0.04),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoleCard({
    required String role,
    required IconData icon,
    required double w,
    required double h,
  }) {
    final bool isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: h * 0.1,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1E3A8A).withOpacity(0.3)
              : const Color(0xFF1E2A45),
          borderRadius: BorderRadius.circular(w * 0.032),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF3B82F6) : const Color(0xFF2A3A55),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            if (isSelected)
              Positioned(
                top: w * 0.02,
                right: w * 0.02,
                child: Container(
                  width: w * 0.045,
                  height: w * 0.045,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3B82F6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: w * 0.028,
                  ),
                ),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: isSelected
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF94A3B8),
                    size: w * 0.065,
                  ),
                  SizedBox(height: h * 0.006),
                  Text(
                    role,
                    style: TextStyle(
                      color:
                          isSelected ? Colors.white : const Color(0xFF94A3B8),
                      fontSize: w * 0.034,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
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
    required double w,
    required double h,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      width: w,
      height: h * 0.065,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A45),
        borderRadius: BorderRadius.circular(w * 0.032),
        border: Border.all(color: const Color(0xFF2A3A55), width: 1),
      ),
      child: Row(
        children: [
          SizedBox(width: w * 0.04),
          Icon(prefixIcon, color: const Color(0xFF94A3B8), size: w * 0.047),
          SizedBox(width: w * 0.028),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword ? obscureText : false,
              keyboardType: keyboardType,
              style: TextStyle(color: Colors.white, fontSize: w * 0.036),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: w * 0.036,
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
                padding: EdgeInsets.only(right: w * 0.04),
                child: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: const Color(0xFF94A3B8),
                  size: w * 0.047,
                ),
              ),
            ),
        ],
      ),
    );
  }
}