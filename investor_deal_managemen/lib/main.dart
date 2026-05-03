import 'package:flutter/material.dart';
import 'package:investor_deal_managemen/presentation/screens/auth/signin_screen.dart';
import 'package:investor_deal_managemen/presentation/screens/auth/signup_screen.dart';
import 'package:investor_deal_managemen/presentation/screens/corporate/corporate_dashboard_screen.dart';
import 'package:investor_deal_managemen/presentation/screens/corporate/deal_management_screen.dart';
import 'package:investor_deal_managemen/presentation/screens/corporate/post_deal_screen.dart';
import 'package:investor_deal_managemen/presentation/screens/investor/deal_detail_screen.dart';
import 'package:investor_deal_managemen/presentation/screens/investor/deal_listing_sceen.dart';
import 'package:investor_deal_managemen/presentation/screens/investor/my_intrest_screen.dart';
import 'package:investor_deal_managemen/presentation/screens/splash/splash_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyDealsScreen()
    );
  }
}
