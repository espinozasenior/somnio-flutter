import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:somnio/core/di/injection.dart';
import 'package:somnio/core/routing/route_paths.dart';
import 'package:somnio/features/auth/presentation/cubit/signup_cubit.dart';
import 'package:somnio/features/auth/presentation/cubit/signup_state.dart';
import 'package:somnio/features/auth/presentation/widgets/auth_form_field.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SignupCubit>(),
      child: const _SignupView(),
    );
  }
}

class _SignupView extends StatelessWidget {
  const _SignupView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SignupCubit, SignupState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == FormzSubmissionStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    state.failure?.message ?? 'Registration failed',
                  ),
                ),
              );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Create Account',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign up to get started',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<SignupCubit, SignupState>(
                    buildWhen: (previous, current) =>
                        previous.name != current.name,
                    builder: (context, state) {
                      return AuthFormField(
                        labelText: 'Name',
                        textInputAction: TextInputAction.next,
                        onChanged: context.read<SignupCubit>().nameChanged,
                        errorText: state.name.displayError != null
                            ? 'Name must be at least 2 characters'
                            : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<SignupCubit, SignupState>(
                    buildWhen: (previous, current) =>
                        previous.email != current.email,
                    builder: (context, state) {
                      return AuthFormField(
                        labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onChanged: context.read<SignupCubit>().emailChanged,
                        errorText: state.email.displayError != null
                            ? 'Invalid email'
                            : null,
                        prefixIcon: const Icon(Icons.email_outlined),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<SignupCubit, SignupState>(
                    buildWhen: (previous, current) =>
                        previous.password != current.password,
                    builder: (context, state) {
                      return AuthFormField(
                        labelText: 'Password',
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        onChanged: context.read<SignupCubit>().passwordChanged,
                        errorText: state.password.displayError != null
                            ? 'Password must be at least 8 characters'
                            : null,
                        prefixIcon: const Icon(Icons.lock_outlined),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<SignupCubit, SignupState>(
                    buildWhen: (previous, current) =>
                        previous.confirmedPassword != current.confirmedPassword,
                    builder: (context, state) {
                      return AuthFormField(
                        labelText: 'Confirm Password',
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        onChanged: context
                            .read<SignupCubit>()
                            .confirmedPasswordChanged,
                        errorText: state.confirmedPassword.displayError != null
                            ? 'Passwords do not match'
                            : null,
                        prefixIcon: const Icon(Icons.lock_outlined),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<SignupCubit, SignupState>(
                    builder: (context, state) {
                      final isLoading =
                          state.status == FormzSubmissionStatus.inProgress;
                      return FilledButton(
                        onPressed: isLoading
                            ? null
                            : () => context
                                .read<SignupCubit>()
                                .signupWithCredentials(),
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Sign Up'),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => context.go(RoutePaths.login),
                    child: const Text('Already have an account? Sign In'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
