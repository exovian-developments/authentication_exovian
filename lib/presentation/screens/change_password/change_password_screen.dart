import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/custom_error.dart';
import '../../../data/repository/auth_repository.dart';
import '../../../utils/error_dialog.dart';
import '../../widgets/buttons.dart';
import '../../widgets/form_fields.dart';
import '../reauthentication/reauthentication_screen.dart';
import 'change_password_viewmodel.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    ref
        .read(changePasswordViewModelProvider.notifier)
        .changePassword(_passwordController.text.trim());
  }

  void processSuccessCase() async {
    try {
      await ref.read(authRepositoryProvider).signOut();
    } on CustomError catch (error) {
      if (!mounted) return;
      errorDialog(context, error);
    }
  }

  void processRequiresRecentLogin() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return const ReauthenticationScreen();
        },
      ),
    );

    if (result == 'success') {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Successfully reauthenticated'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(
      changePasswordViewModelProvider,
      (previous, next) {
        next.whenOrNull(error: (e, st) {
          final err = e as CustomError;

          if (err.code == 'requires-recent-login') {
            processRequiresRecentLogin();
          } else {
            errorDialog(context, err);
          }
        }, data: (_) {
          processSuccessCase();
        });
      },
    );

    final changePasswordState = ref.watch(changePasswordViewModelProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Change password'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: ListView(
                shrinkWrap: true,
                reverse: true,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'If you change password',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'you will be',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(
                              text: 'signed out',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  PasswordFormField(
                    passwordController: _passwordController,
                    labelText: 'New password',
                  ),
                  const SizedBox(height: 20.0),
                  ConfirmPasswordFormField(
                    passwordController: _passwordController,
                    labelText: 'Confirm new password',
                  ),
                  const SizedBox(height: 20.0),
                  CustomFilledButton(
                    onPressed: changePasswordState.maybeWhen(
                      loading: () => null,
                      orElse: () => _submit,
                    ),
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    child: Text(
                      changePasswordState.maybeWhen(
                        loading: () => 'Submitting...',
                        orElse: () => 'Change password',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                ].reversed.toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
