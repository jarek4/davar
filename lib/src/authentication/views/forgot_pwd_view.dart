import 'package:davar/src/authentication/auth_provider.dart';
import 'package:davar/src/authentication/forgot_pwd_provider.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/theme/theme.dart' as theme;
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ForgotPwdView extends StatefulWidget {
  const ForgotPwdView({Key? key, required this.user}) : super(key: key);
  static const routeName = '/forgot_password';

  final User user;

  @override
  State<ForgotPwdView> createState() => _ForgotPwdViewState();
}

class _ForgotPwdViewState extends State<ForgotPwdView> {
  final GlobalKey<FormState> _forgotPwdFormKye =
      GlobalKey<FormState>(debugLabel: 'Forgot-password-form');

  @override
  Widget build(BuildContext context) {
    AuthProvider ap = Provider.of<AuthProvider>(context, listen: false);
    return ChangeNotifierProvider<ForgotPwdProvider>(
      create: (_) => ForgotPwdProvider(ap, widget.user),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Reset password'),
            centerTitle: true,
          ),
          body:
              Consumer<ForgotPwdProvider>(builder: (BuildContext context, ForgotPwdProvider fp, _) {
            final bool hasError = fp.status == ForgotPwdStatus.error || fp.error.isNotEmpty;
            if (hasError) {
              utils.showSnackBarInfo(context, msg: fp.error, isError: true);
            }
            if (fp.status == ForgotPwdStatus.disabled) return _buildStatusBlockedScreen();
            if (fp.status == ForgotPwdStatus.error) return _buildErrorScreen(fp.error);
            return _buildForm(context);
          }),
        );
      },
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<ForgotPwdProvider>(builder: (BuildContext context, ForgotPwdProvider fp, _) {
        final bool isLoading = fp.status == ForgotPwdStatus.loading;
        final bool isPwdChanged = fp.status == ForgotPwdStatus.passwordChanged;
        final bool hasError = fp.status == ForgotPwdStatus.error || fp.error.isNotEmpty;
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(height: 15.0),
          Text('You can try ${fp.resetAttempts} times!'),
          const SizedBox(height: 15.0),
          Form(
            key: _forgotPwdFormKye,
            child: Column(children: [
              _nameField(context, 'Username'),
              _languageField(context, 'Witch language you learn')
            ]),
          ),
          isPwdChanged
              ? MaterialButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(color: Colors.green),
                  ),
                  onPressed: isLoading ? null : () => _handleLoginRequest(context),
                  child: isLoading ? progress() : const Text('Login'),
                )
              : MaterialButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(color: Colors.green),
                  ),
                  onPressed: isLoading ? null : () => _handleResetPasswordRequest(context),
                  child: isLoading ? progress() : const Text('Reset password'),
                ),
          hasError
              ? Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Text(fp.error),
                )
              : const SizedBox.shrink()
        ]);
      }),
    );
  }

  Widget progress() => const SizedBox(width: 22, height: 22, child: CircularProgressIndicator());

  void _handleResetPasswordRequest(BuildContext context) {
    // to show no valid form info
    final bool isFormValid = validateForm();
    if (!isFormValid) return;
    // onResetPasswordRequest compares username and language  with the data provided by the user
    final isValidated = context.read<ForgotPwdProvider>().onResetPasswordRequest();
    if (isValidated) showNewPasswordDialog(context);
  }

  void _handleLoginRequest(BuildContext context) {
    context.read<ForgotPwdProvider>().redirectToLoginPage();
    Navigator.of(context).pop();
  }

  bool validateForm() {
    if (_forgotPwdFormKye.currentState != null) {
      return _forgotPwdFormKye.currentState!.validate();
    }
    return false;
  }

  Widget _nameField(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
      child: TextFormField(
          cursorColor: Colors.black,
          maxLength: 30,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp('[ a-zA-Z0-9 -]'))
          ],
          onChanged: (val) => context.read<ForgotPwdProvider>().onUserNameChange(val),
          validator: (v) => (v != null && v.length >= 2) ? null : 'Enter name',
          initialValue: '',
          keyboardType: TextInputType.text,
          obscureText: false,
          decoration: theme.inputDecoration(label: label)),
    );
  }

  Widget _languageField(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
      child: TextFormField(
          cursorColor: Colors.black,
          maxLength: 30,
          onChanged: (val) => context.read<ForgotPwdProvider>().onLanguageChange(val),
          validator: (v) => (v != null && v.length >= 2) ? null : 'Enter language',
          initialValue: '',
          keyboardType: TextInputType.text,
          decoration: theme.inputDecoration(label: label)),
    );
  }

  void showNewPasswordDialog(BuildContext context) {
    final GlobalKey<FormState> resetPwdFormKey =
        GlobalKey<FormState>(debugLabel: 'Forgot-password-resetPwdFormKey');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'New password',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 17.0),
        ),
        titlePadding: const EdgeInsets.only(top: 6.0, bottom: 4.0),
        content: SingleChildScrollView(
          child: Form(
            key: resetPwdFormKey,
            child: Wrap(children: [
              TextFormField(
                  decoration: const InputDecoration(hintText: 'password'),
                  initialValue: '',
                  keyboardType: TextInputType.text,
                  maxLength: 40,
                  onChanged: (val) => context.read<ForgotPwdProvider>().onNewPasswordChange(val),
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Cannot be empty!';
                    if (v.length < 6) return 'the password is not strong!';
                    return null;
                  }),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                    onPressed: () {
                      resetPwdFormKey.currentState?.validate();
                      _handleSaveNewPassword(context);
                    },
                    child: const Text('Change password')),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSaveNewPassword(BuildContext context) async {
    if (context.read<ForgotPwdProvider>().resetAttempts > 3) return;
    if (context.read<ForgotPwdProvider>().validateNewPassword()) {
      Navigator.of(context).pop();
      final bool isChanged = await context.read<ForgotPwdProvider>().changePassword();
      if (isChanged) {
        if (!mounted) return;
        utils.showSnackBarInfo(context, msg: 'Password was changed');
      }
    }
  }

  Widget _buildStatusBlockedScreen() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('You cannot try any more. Please register new user'),
        const SizedBox(height: 25),
        IconButton(
            iconSize: 28.0,
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_rounded))
      ]),
    );
  }

  Widget _buildErrorScreen(String errorMsg) {
    return Center(
      child: OverflowBar(
          overflowAlignment: OverflowBarAlignment.center,
          spacing: 25.0,
          overflowSpacing: 3.0,
          children: [
            const Text('Sorry! The data is not available'),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    iconSize: 28.0,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_rounded)),
                Text(errorMsg)
              ],
            ),
          ]),
    );
  }
}
