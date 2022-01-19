import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

import 'firebase_options.dart';

/// Link your own firebase project using the following commands:
/// 1- dart pub global activate flutterfire_cli
/// 2- flutterfire configure
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return const SignInScreen(providerConfigs: [
            EmailProviderConfiguration(),
          ]);
        }

        return const YourApplication();
      },
    );
  }
}

class YourApplication extends StatelessWidget {
  const YourApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Signed in as ${FirebaseAuth.instance.currentUser?.displayName}',
            ),
            const SizedBox(height: 16),
            Text(
              'User UID is\n[${FirebaseAuth.instance.currentUser?.uid}]',
            ),
            const SizedBox(height: 16),
            FutureBuilder<String>(
                future: FirebaseAuth.instance.currentUser?.getIdToken(true),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Icon(Icons.error);
                  }
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator.adaptive();
                  }
                  return Text(
                    'User token is\n${snapshot.data}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  );
                }),
            const SizedBox(height: 16),
            const SignOutButton(),
          ],
        ),
      ),
    );
  }
}
