import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investor_deal_managemen/injection_container.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_state.dart';
import 'package:investor_deal_managemen/presentation/bloc/deal/deal_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/deal/deal_event.dart';
import 'package:investor_deal_managemen/presentation/screens/corporate/corporate_dashboard_screen.dart';
import 'package:investor_deal_managemen/presentation/screens/corporate/corporate_profile_screen.dart';
import 'package:investor_deal_managemen/presentation/screens/corporate/my_deals_screen.dart';
// Add the import for your profile screen here!
// import 'package:investor_deal_managemen/presentation/screens/corporate/corporate_profile_screen.dart'; 

class CorporateBottomNav extends StatefulWidget {
  const CorporateBottomNav({super.key});

  @override
  State<CorporateBottomNav> createState() => _CorporateBottomNavState();
}

class _CorporateBottomNavState extends State<CorporateBottomNav> {
  int _currentIndex = 0;

  // ✅ Updated to use your external CorporateProfileScreen class
  static const List<Widget> _screens = [
    DealDashboardScreen(),
    MyDealsScreen(),
    CorporateProfileScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final String corporateEmail = authState is AuthAuthenticated
        ? authState.user.email
        : '';

    return BlocProvider<DealBloc>(
      create: (_) => sl<DealBloc>()..add(LoadMyDealsEvent(corporateEmail)),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0E1A),
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: const Color(0xFF1E2A45),
          selectedItemColor: const Color(0xFF6366F1),
          unselectedItemColor: const Color(0xFF94A3B8),
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
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
      ),
    );
  }
}