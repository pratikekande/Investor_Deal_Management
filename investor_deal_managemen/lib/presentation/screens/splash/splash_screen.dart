import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_state.dart';
import 'package:investor_deal_managemen/presentation/screens/auth/signin_screen.dart';
import 'package:investor_deal_managemen/presentation/screens/corporate/corporate_bottom_nav.dart';
import 'package:investor_deal_managemen/presentation/screens/investor/investor_bottom_nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _progressValue;

  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    // Logo animation controller
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Text animation controller
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Progress bar controller
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    // Sequence the animations
    _logoController.forward().then((_) {
      _textController.forward();
      _progressController.forward();
    });

    // Navigate after splash
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted && !_hasNavigated) {
        _navigateBasedOnState();
      }
    });
  }

  void _navigateBasedOnState() {
    if (_hasNavigated) return;
    _hasNavigated = true;

    final authState = context.read<AuthBloc>().state;

    Widget destination;
    if (authState is AuthAuthenticated) {
      if (authState.user.role == 'investor') {
        destination = const InvestorBottomNav();
      } else if (authState.user.role == 'corporate') {
        destination = const CorporateBottomNav();
      } else {
        destination = const SignInScreen();
      }
    } else {
      destination = const SignInScreen();
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => destination),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated || state is AuthUnauthenticated) {
          Future.delayed(const Duration(milliseconds: 3200), () {
            if (mounted && !_hasNavigated) {
              _navigateBasedOnState();
            }
          });
        }
      },
      child: Scaffold(
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
            child: Stack(
              children: [
                // Subtle background glow
                Positioned(
                  top: deviceHeight * 0.25,
                  left: deviceWidth * 0.1,
                  child: Container(
                    width: deviceWidth * 0.8,
                    height: deviceWidth * 0.8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF3B82F6).withOpacity(0.08),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Main centered content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      AnimatedBuilder(
                        animation: _logoController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _logoOpacity.value,
                            child: Transform.scale(
                              scale: _logoScale.value,
                              child: Container(
                                width: deviceWidth * 0.28,
                                height: deviceWidth * 0.28,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      deviceWidth * 0.06),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF1E3A8A),
                                      Color(0xFF3B82F6),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF3B82F6)
                                          .withOpacity(0.4),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'DF',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: deviceWidth * 0.1,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: deviceHeight * 0.03),

                      // App name + tagline
                      AnimatedBuilder(
                        animation: _textController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _textOpacity,
                            child: SlideTransition(
                              position: _textSlide,
                              child: Column(
                                children: [
                                  Text(
                                    'DealFlow',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: deviceWidth * 0.09,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: deviceHeight * 0.01),
                                  Text(
                                    'Smart Investing, Simplified',
                                    style: TextStyle(
                                      color: const Color(0xFF94A3B8),
                                      fontSize: deviceWidth * 0.038,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Bottom progress bar
                Positioned(
                  bottom: deviceHeight * 0.08,
                  left: deviceWidth * 0.15,
                  right: deviceWidth * 0.15,
                  child: AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return Column(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.02),
                            child: LinearProgressIndicator(
                              value: _progressValue.value,
                              backgroundColor: const Color(0xFF1E2A45),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF3B82F6),
                              ),
                              minHeight: 3,
                            ),
                          ),
                          SizedBox(height: deviceHeight * 0.015),
                          Text(
                            'Loading...',
                            style: TextStyle(
                              color: const Color(0xFF94A3B8),
                              fontSize: deviceWidth * 0.03,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}