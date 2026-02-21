import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tempus/features/home/presentation/pages/home_page.dart';
import 'package:tempus/features/auth/presentation/pages/login_page.dart';
import 'package:tempus/features/onboarding/data/onboarding_service.dart';
import 'package:tempus/features/onboarding/presentation/pages/onboarding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load and intialize the supabase .env file
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
  );

  final bool onboardingDone = await OnboardingService.isComplete('guest_or_global') ?? false;

  runApp(MyApp(onboardingDone: onboardingDone));
}

class MyApp extends StatelessWidget {
  final bool onboardingDone;
  const MyApp({super.key, required this.onboardingDone});

  @override
  Widget build(BuildContext context) {

    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tempus',
      theme: ThemeData(
        primaryColor: const Color(0xFF1A56DB),
        useMaterial3: true,
      ),
      home: !onboardingDone
        ? const Onboarding()
        : (session != null ? const HomePage() : const LoginPage()),
    );
  }
}
