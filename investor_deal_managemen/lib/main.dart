import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investor_deal_managemen/core/route_observer.dart'; // ← add this
import 'package:investor_deal_managemen/injection_container.dart' as di;
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_event.dart';
import 'package:investor_deal_managemen/presentation/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<AuthBloc>()..add(CheckSessionEvent()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        navigatorObservers: [routeObserver], // ← add this
        home: const SplashScreen(),
      ),
    );
  }
}