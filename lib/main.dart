import 'package:beepbeep_prototype/app.dart';
import 'package:beepbeep_prototype/features/auth/repository/auth_repository.dart';
import 'package:beepbeep_prototype/features/auth/service/auth_service.dart';
import 'package:beepbeep_prototype/features/auth/viewmodel/login_viewmodel.dart';
import 'package:beepbeep_prototype/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GoogleSignIn.instance.initialize();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (context) => AuthService()),
        Provider<AuthRepository>(
          create: (context) => AuthRepository(context.read<AuthService>()),
        ),
        ChangeNotifierProvider<LoginViewModel>(
          create: (context) => LoginViewModel(context.read<AuthRepository>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
