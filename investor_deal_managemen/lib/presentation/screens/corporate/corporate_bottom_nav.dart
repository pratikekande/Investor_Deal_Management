import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_event.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_state.dart';
import 'package:investor_deal_managemen/presentation/screens/auth/signin_screen.dart';
import 'package:investor_deal_managemen/presentation/screens/corporate/corporate_dashboard_screen.dart';
import 'package:investor_deal_managemen/presentation/screens/corporate/deal_management_screen.dart';

class CorporateBottomNav extends StatefulWidget {
  const CorporateBottomNav({super.key});

  @override
  State<CorporateBottomNav> createState() => _CorporateBottomNavState();
}

class _CorporateBottomNavState extends State<CorporateBottomNav> {
  int _currentIndex = 0;

  Widget get _currentPage {
    switch (_currentIndex) {
      case 0:
        return const DealDashboardScreen();
      case 1:
        return const MyDealsScreen();
      case 2:
        return const _CorporateProfileScreen();
      default:
        return const DealDashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF3B82F6),
        unselectedItemColor: const Color(0xFF94A3B8),
        backgroundColor: const Color(0xFF1E2A45),
        elevation: 8,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
        onTap: (value) => setState(() => _currentIndex = value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center_outlined),
            activeIcon: Icon(Icons.business_center_rounded),
            label: 'My Deals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _CorporateProfileScreen extends StatelessWidget {
  const _CorporateProfileScreen();

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    final String name = user?.name ?? 'Corporate';
    final String email = user?.email ?? '';
    final String role = user?.role ?? 'corporate';
    final String initial = name.isNotEmpty ? name[0].toUpperCase() : 'C';

    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    return Container(
      width: w,
      height: h,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D1B3E), Color(0xFF060B1E)],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: h * 0.05),

              // Page title
              Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.06,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),

              SizedBox(height: h * 0.04),

              // Avatar
              Container(
                width: w * 0.28,
                height: w * 0.28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.4),
                      blurRadius: 25,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              SizedBox(height: h * 0.025),

              // Name
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.055,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),

              SizedBox(height: h * 0.008),

              // Email
              Text(
                email,
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: w * 0.038,
                  fontWeight: FontWeight.w400,
                ),
              ),

              SizedBox(height: h * 0.02),

              // Role chip
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.05,
                  vertical: h * 0.008,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(w * 0.05),
                  border: Border.all(
                    color: const Color(0xFF3B82F6).withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Corporate',
                  style: TextStyle(
                    color: const Color(0xFF3B82F6),
                    fontSize: w * 0.034,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              SizedBox(height: h * 0.06),

              // Profile info card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(w * 0.05),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2A45),
                  borderRadius: BorderRadius.circular(w * 0.04),
                  border: Border.all(
                    color: const Color(0xFF2A3A55),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      icon: Icons.business_outlined,
                      label: 'Company Name',
                      value: name,
                      w: w,
                    ),
                    Divider(
                      color: const Color(0xFF2A3A55),
                      height: h * 0.03,
                      thickness: 1,
                    ),
                    _buildInfoRow(
                      icon: Icons.mail_outline_rounded,
                      label: 'Email',
                      value: email,
                      w: w,
                    ),
                    Divider(
                      color: const Color(0xFF2A3A55),
                      height: h * 0.03,
                      thickness: 1,
                    ),
                    _buildInfoRow(
                      icon: Icons.badge_outlined,
                      label: 'Role',
                      value: role.isNotEmpty
                          ? role[0].toUpperCase() + role.substring(1)
                          : 'Corporate',
                      w: w,
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.05),

              // Logout button
              GestureDetector(
                onTap: () {
                  context.read<AuthBloc>().add(SignOutEvent());
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const SignInScreen()),
                    (route) => false,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: h * 0.065,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(w * 0.04),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withOpacity(0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                      SizedBox(width: w * 0.025),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.042,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: h * 0.04),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required double w,
  }) {
    return Row(
      children: [
        Container(
          width: w * 0.1,
          height: w * 0.1,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withOpacity(0.1),
            borderRadius: BorderRadius.circular(w * 0.025),
          ),
          child: Icon(icon, color: const Color(0xFF3B82F6), size: w * 0.048),
        ),
        SizedBox(width: w * 0.04),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: w * 0.03,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.038,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
