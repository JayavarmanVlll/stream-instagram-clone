import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/app.dart';
import '../home/home.dart';

/// {@template login_screen}
/// Screen that presents an option of users to authenticate as.
/// {@endtemplate}
class LoginScreen extends StatefulWidget {
  /// {@macro login_screen}
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Demo users',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 42),
              for (final user in DemoAppUser.values)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 4.0),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      context.removeAndShowSnackbar('Loading User');

                      await context.read<FeedState>().connect(user);

                      context.removeAndShowSnackbar('User Loaded');

                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const HomeScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24.0, horizontal: 36.0),
                      child: SizedBox(
                        width: 200,
                        child: Text(
                          user.name!,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
