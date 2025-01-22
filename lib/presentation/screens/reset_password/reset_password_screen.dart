import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/router/route_names.dart';
import '../../../data/model/custom_error.dart';
import '../../../utils/error_dialog.dart';
import '../../widgets/buttons.dart';
import '../../widgets/form_fields.dart';
import 'reset_password_viewmodel.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _autovalidateMode = AutovalidateMode.always);

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    ref.read(resetPasswordViewModelProvider.notifier).resetPassword(
          email: _emailController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(
      resetPasswordViewModelProvider,
      (previous, next) {
        next.whenOrNull(
          error: (e, st) => errorDialog(
            context,
            e as CustomError,
          ),
          data: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password reset email has been sent'),
              ),
            );
            GoRouter.of(context).goNamed(RouteNames.signin);
          },
        );
      },
    );

    final resetPasswordState = ref.watch(resetPasswordViewModelProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: ListView(
                shrinkWrap: true,
                reverse: true,
                children: [
                  const FlutterLogo(size: 150),
                  const SizedBox(height: 20.0),
                  EmailFormField(emailController: _emailController),
                  const SizedBox(height: 20.0),
                  CustomFilledButton(
                    onPressed: resetPasswordState.maybeWhen(
                      loading: () => null,
                      orElse: () => _submit,
                    ),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    child: Text(
                      resetPasswordState.maybeWhen(
                        loading: () => 'Submitting...',
                        orElse: () => 'Reset Password',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Remember password? '),
                      CustomTextButton(
                        onPressed: resetPasswordState.maybeWhen(
                          loading: () => null,
                          orElse: () =>
                              () => context.goNamed(RouteNames.signin),
                        ),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                ].reversed.toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
