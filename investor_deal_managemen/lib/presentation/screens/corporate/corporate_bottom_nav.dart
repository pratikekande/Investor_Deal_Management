import 'package:flutter/material.dart';
import 'package:investor_deal_managemen/presentation/screens/corporate/corporate_dashboard_screen.dart';
import 'package:investor_deal_managemen/presentation/screens/corporate/deal_management_screen.dart';
import 'package:investor_deal_managemen/presentation/screens/corporate/corporate_profile_screen.dart'; // extract profile here

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
        return const CorporateProfileScreen(); // moved to its own file
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