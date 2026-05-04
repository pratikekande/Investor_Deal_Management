import 'package:flutter/material.dart';
import 'package:investor_deal_managemen/presentation/screens/corporate/corporate_dashboard_screen.dart';
import 'package:investor_deal_managemen/presentation/screens/corporate/deal_management_screen.dart';
import 'package:investor_deal_managemen/presentation/screens/corporate/corporate_profile_screen.dart';

class CorporateBottomNav extends StatefulWidget {
  const CorporateBottomNav({super.key});

  @override
  State<CorporateBottomNav> createState() => _CorporateBottomNavState();
}

class _CorporateBottomNavState extends State<CorporateBottomNav>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Widget> _pages = const [
    DealDashboardScreen(),
    MyDealsScreen(),
    CorporateProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    _animController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: _pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6366F1),
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
        onTap: _onTabTapped,
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