import 'package:flutter/material.dart';
import 'package:investor_deal_managemen/presentation/screens/investor/deal_listing_sceen.dart';
import 'package:investor_deal_managemen/presentation/screens/investor/my_intrest_screen.dart';
//import 'package:investor_deal_managemen/presentation/screens/investor/investor_profile_screen.dart';

class InvestorBottomNav extends StatefulWidget {
  const InvestorBottomNav({super.key});

  @override
  State<InvestorBottomNav> createState() => _InvestorBottomNavState();
}

class _InvestorBottomNavState extends State<InvestorBottomNav> {
  int _currentIndex = 0;

  Widget get _currentPage {
    switch (_currentIndex) {
      case 0:
        return const DealListingScreen();
      case 1:
        return const MyInterestsScreen();
      case 2:
        return const MyInterestsScreen();
      default:
        return const DealListingScreen();
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
            icon: Icon(Icons.handshake_outlined),
            activeIcon: Icon(Icons.handshake_rounded),
            label: 'Deals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border_rounded),
            activeIcon: Icon(Icons.bookmark_rounded),
            label: 'Interests',
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