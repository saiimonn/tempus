import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tempus/features/home/presentation/pages/home_page.dart';
import 'package:tempus/features/auth/presentation/pages/login_page.dart';
import 'package:tempus/features/onboarding/data/data_source/onboarding_local_data_source.dart';
import 'package:tempus/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:tempus/features/onboarding/domain/use_cases/check_onboarding_complete.dart';
import 'package:tempus/features/onboarding/domain/use_cases/mark_onboarding_complete.dart';
import 'package:tempus/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:tempus/features/onboarding/presentation/pages/onboarding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load and intialize the supabase .env file
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
  );

  final dataSource = OnboardingLocalDataSource();
  final repository = OnboardingRepositoryImpl(dataSource);
  final checkComplete = CheckOnboardingComplete(repository);
  final markComplete = MarkOnboardingComplete(repository);

  final bool onboardingDone = await checkComplete('guest_or_global');

  runApp(MyApp(onboardingDone: onboardingDone, markOnboardingComplete: markComplete));
}

class MyApp extends StatelessWidget {
  final bool onboardingDone;
  final MarkOnboardingComplete markOnboardingComplete;

  const MyApp({
    super.key, 
    required this.onboardingDone, 
    required this.markOnboardingComplete
  });

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
        ? BlocProvider(
          create: (context) => OnboardingBloc(
            markOnboardingComplete: markOnboardingComplete,
          ),
          child: const Onboarding(),
        )
        : (session != null ? const HomePage() : const LoginPage()),
    );
  }
}
