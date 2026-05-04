import 'package:flutter/material.dart';
import 'package:investor_deal_managemen/presentation/screens/auth/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

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
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
            colors: [Color(0xFF0D1B3E), Color(0xFF0A0F2C), Color(0xFF060B1E)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: deviceHeight * 0.06),

                    // Logo
                    Container(
                      width: deviceWidth * 0.22,
                      height: deviceWidth * 0.22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withOpacity(0.3),
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
                            fontSize: deviceWidth * 0.08,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: deviceHeight * 0.02),

                    Text(
                      'DEALFLOW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: deviceWidth * 0.055,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4,
                      ),
                    ),

                    SizedBox(height: deviceHeight * 0.04),

                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: deviceWidth * 0.065,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: deviceHeight * 0.008),

                    Text(
                      'Sign in to explore investment deals',
                      style: TextStyle(
                        color: const Color(0xFF94A3B8),
                        fontSize: deviceWidth * 0.038,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    SizedBox(height: deviceHeight * 0.045),

                    _buildTextField(
                      controller: _emailController,
                      hint: 'Enter your email',
                      prefixIcon: Icons.mail_outline_rounded,
                      deviceWidth: deviceWidth,
                      deviceHeight: deviceHeight,
                    ),

                    SizedBox(height: deviceHeight * 0.018),

                    _buildTextField(
                      controller: _passwordController,
                      hint: 'Enter your password',
                      prefixIcon: Icons.lock_outline_rounded,
                      deviceWidth: deviceWidth,
                      deviceHeight: deviceHeight,
                      isPassword: true,
                      obscureText: _obscurePassword,
                      onTogglePassword: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),

                    SizedBox(height: deviceHeight * 0.012),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: const Color(0xFF3B82F6),
                            fontSize: deviceWidth * 0.038,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: deviceHeight * 0.035),

                    GestureDetector(
                      onTap: _isLoading ? null : _handleSignIn,
                      child: Container(
                        width: deviceWidth,
                        height: deviceHeight * 0.068,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withOpacity(0.3),
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
                                  'Sign In',
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

                    SizedBox(height: deviceHeight * 0.045),

                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Color(0xFF1E2A45), thickness: 1),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.03),
                          child: Text(
                            'TRUST & SECURITY',
                            style: TextStyle(
                              color: const Color(0xFF94A3B8),
                              fontSize: deviceWidth * 0.028,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: Color(0xFF1E2A45), thickness: 1),
                        ),
                      ],
                    ),

                    SizedBox(height: deviceHeight * 0.03),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: const Color(0xFF94A3B8),
                            fontSize: deviceWidth * 0.038,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Zero-duration transition eliminates lag
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                    const SignUpScreen(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: const Color(0xFF3B82F6),
                              fontSize: deviceWidth * 0.038,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: deviceHeight * 0.06),
                  ],
                ),
              ),
            ),
          ),
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
  }) {
    return Container(
      width: deviceWidth,
      height: deviceHeight * 0.072,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A45),
        borderRadius: BorderRadius.circular(deviceWidth * 0.035),
        border: Border.all(color: const Color(0xFF2A3A55), width: 1),
      ),
      child: Row(
        children: [
          SizedBox(width: deviceWidth * 0.04),
          Icon(prefixIcon, color: const Color(0xFF94A3B8), size: deviceWidth * 0.052),
          SizedBox(width: deviceWidth * 0.03),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword ? obscureText : false,
              keyboardType: isPassword
                  ? TextInputType.visiblePassword
                  : TextInputType.emailAddress,
              style: TextStyle(color: Colors.white, fontSize: deviceWidth * 0.04),
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

  void _handleSignIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Color(0xFF1E2A45),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() => _isLoading = false);

    // TODO: Connect to AuthBloc
  }
}