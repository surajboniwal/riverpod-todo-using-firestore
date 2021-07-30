import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/controllers/auth_controller.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer(builder: (context, watch, child) {
          final authController = watch(AuthController.authControllerProvider);
          return ElevatedButton(
            onPressed: () async {
              if (authController == null) {
                context.read(AuthController.authControllerProvider.notifier).signInWithGoogle();
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.network(
                    'https://img-authors.flaticon.com/google.jpg',
                    height: 42.0,
                  ),
                  SizedBox(width: 8.0),
                  Text('Sign in with Google'),
                  SizedBox(width: 8.0),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
