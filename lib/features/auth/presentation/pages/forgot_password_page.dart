import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:somnio/core/routing/route_paths.dart';
import 'package:somnio/features/auth/presentation/widgets/auth_form_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Reset your password',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your email address and we will send you a link '
                'to reset your password.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              const AuthFormField(
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                prefixIcon: Icon(Icons.email_outlined),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  // TODO(auth): Implement forgot password.
                },
                child: const Text('Send Reset Link'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go(RoutePaths.login),
                child: const Text('Back to Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
