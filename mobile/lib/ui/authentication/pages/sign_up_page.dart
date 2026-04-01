import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/providers/auth/auth_notifier_provider.dart';
import 'package:mobile/repositories/auth_repo/auth_repository.dart';
import 'package:mobile/router/app_router.gr.dart';
import 'package:mobile/services/error_logger/error_logger.dart';
import 'package:mobile/services/validator_service/validator_service.dart';
import 'package:mobile/ui/shared_widgets/custom_filled_button.dart';
import 'package:mobile/ui/shared_widgets/custom_text_field.dart';
import 'package:mobile/ui/shared_widgets/loading_indicator.dart';
import 'package:mobile/ui/theme/app_spacing.dart';

final signUpMutation = Mutation<void>();

@RoutePage()
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static const path = '/auth/sign_up';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Kenya')),
      body: Container(
        padding: AppSpacing.paddingAllBase,
        alignment: Alignment.center,
        child: const SignUpForm(),
      ),
    );
  }
}

class SignUpForm extends HookConsumerWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final obscurePassword = useState(true);
    final obscureConfirmPassword = useState(true);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final formKey = useMemoized(GlobalKey<FormState>.new);
    const minPasswordLength = 8;

    final signUpState = ref.watch(signUpMutation);

    Future<void> submit() async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final router = context.router;
      if (formKey.currentState?.validate() ?? false) {
        TextInput.finishAutofillContext();

        return signUpMutation.run(
          ref,
          (tsx) async {
            try {
              final notifier = tsx.get(authProvider.notifier);
              final session = await notifier.signUpWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
              if (session != null) {
                await router.replace(const HomeRoute());
                return;
              }

              scaffoldMessenger.showSnackBar(
                const SnackBar(
                  content: Text(
                    'Check your email to confirm your account before signing in.',
                  ),
                ),
              );
              await router.replace(const SignInRoute());
            } on AuthRepositoryException catch (error, stackTrace) {
              ErrorLoggerService.instance.logError(
                error,
                message: 'Error signing up',
                stackTrace: stackTrace,
              );
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  backgroundColor: theme.colorScheme.error,
                  content: Text(error.message),
                ),
              );
            } catch (error, stackTrace) {
              ErrorLoggerService.instance.logError(
                error,
                message: 'Error signing up',
                stackTrace: stackTrace,
              );
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  backgroundColor: theme.colorScheme.error,
                  content: const Text('An error occurred during signing up'),
                ),
              );
            }
          },
        );
      }
    }

    return Form(
      key: formKey,
      child: Semantics(
        label: 'Sign up form',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              header: true,
              child: Text(
                'Sign Up',
                style: textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            AutofillGroup(
              child: Column(
                children: [
                  CustomTextField(
                    controller: emailController,
                    labelText: 'Email',
                    hintText: 'example@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Email is required';
                      }

                      return ValidatorService.emailFormatValidator(v.trim());
                    },
                    fieldKey: const ValueKey('sign_up_email'),
                  ),
                  const SizedBox(height: AppSpacing.base),
                  CustomTextField(
                    controller: passwordController,
                    labelText: 'Password',
                    hintText: '********',
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                    obscureText: obscurePassword.value,

                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Password is required';
                      }

                      if (v.length < minPasswordLength) {
                        return 'Password must be at least $minPasswordLength '
                            'characters';
                      }

                      return null;
                    },
                    fieldKey: const ValueKey('sign_up_password'),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          obscurePassword.value = !obscurePassword.value,
                      tooltip: obscurePassword.value
                          ? 'Show password'
                          : 'Hide password',
                      icon: Icon(
                        obscurePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base),
                  CustomTextField(
                    controller: confirmPasswordController,
                    labelText: 'Confirm Password',
                    hintText: '********',
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.newPassword],
                    obscureText: obscureConfirmPassword.value,
                    enableSuggestions: false,
                    autocorrect: false,
                    onFieldSubmitted: (_) => submit(),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Confirm your password';
                      }

                      if (v != passwordController.text) {
                        return 'Passwords do not match';
                      }

                      return null;
                    },
                    fieldKey: const ValueKey('sign_up_confirm_password'),
                    suffixIcon: IconButton(
                      onPressed: () => obscureConfirmPassword.value =
                          !obscureConfirmPassword.value,
                      tooltip: obscureConfirmPassword.value
                          ? 'Show password'
                          : 'Hide password',
                      icon: Icon(
                        obscureConfirmPassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            CustomFilledButton(
              onPressed: switch (signUpState) {
                MutationPending() => null,
                _ => submit,
              },
              child: switch (signUpState) {
                MutationPending() => const LoadingIndicator(),
                _ => const Text('Sign up'),
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            Align(
              child: RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: const TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                      text: 'Sign In',
                      style: TextStyle(color: theme.colorScheme.tertiary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () =>
                            context.replaceRoute(const SignInRoute()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
