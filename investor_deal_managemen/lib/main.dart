import 'package:flutter/material.dart';
import 'package:investor_deal_managemen/presentation/screens/investor/deal_listing_sceen.dart';
import 'package:investor_deal_managemen/presentation/screens/investor/investor_bottom_nav.dart';
import 'package:investor_deal_managemen/presentation/screens/splash/splash_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InvestorBottomNav()
    );
  }
}
