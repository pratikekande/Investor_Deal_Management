import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investor_deal_managemen/injection_container.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_state.dart';
import 'package:investor_deal_managemen/presentation/bloc/deal/deal_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/deal/deal_event.dart';
import 'package:investor_deal_managemen/presentation/bloc/interest/interest_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/interest/interest_event.dart';
import 'package:investor_deal_managemen/presentation/screens/investor/deal_listing_sceen.dart';
import 'package:investor_deal_managemen/presentation/screens/investor/investor_profile_screen.dart';
import 'package:investor_deal_managemen/presentation/screens/investor/my_intrest_screen.dart';

class InvestorBottomNav extends StatefulWidget {
  const InvestorBottomNav({super.key});

  @override
  State<InvestorBottomNav> createState() => _InvestorBottomNavState();
}

class _InvestorBottomNavState extends State<InvestorBottomNav> {
  int _currentIndex = 0;

  late final DealBloc _dealBloc;
  late final InterestBloc _interestBloc;

  static const List<Widget> _screens = [
    DealListingScreen(),
    MyInterestsScreen(),
    InvestorProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _dealBloc = sl<DealBloc>();
    _interestBloc = sl<InterestBloc>();

    _dealBloc.add(LoadAllDealsEvent());

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _interestBloc.add(LoadMyInterestsEvent(authState.user.email));
    }
  }

  @override
  void dispose() {
    _dealBloc.close();
    _interestBloc.close();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == 1) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        _interestBloc.add(LoadMyInterestsEvent(authState.user.email));
      }
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DealBloc>.value(value: _dealBloc),
        BlocProvider<InterestBloc>.value(value: _interestBloc),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0E1A),
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          backgroundColor: const Color(0xFF1E2A45),
          selectedItemColor: const Color(0xFF6366F1),
          unselectedItemColor: const Color(0xFF94A3B8),
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
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
      ),
    );
  }
}