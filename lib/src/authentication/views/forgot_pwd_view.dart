import 'package:davar/src/authentication/auth_provider.dart';
import 'package:davar/src/authentication/forgot_pwd_provider.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/theme/theme.dart' as theme;
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  String _empty = 'cannot be empty';

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _empty = AppLocalizations.of(context)?.fieldNotEmpty ?? 'cannot be empty';
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider ap = Provider.of<AuthProvider>(context, listen: false);
    final String reset = AppLocalizations.of(context)?.pwdReset ?? 'Reset password';
    return ChangeNotifierProvider<ForgotPwdProvider>(
      create: (_) => ForgotPwdProvider(ap, widget.user),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(reset),
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
    final String name = utils.capitalize(AppLocalizations.of(context)?.authName ?? 'Username');
    final String whichLang =
        AppLocalizations.of(context)?.pwdResetWhichLang ?? 'Which language you learn';
    final String reset = AppLocalizations.of(context)?.pwdReset ?? 'Reset password';
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
            child:
                Column(children: [_nameField(context, name), _languageField(context, whichLang)]),
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
                  child: isLoading ? progress() : Text(reset),
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
          validator: (v) => (v != null && v.length >= 2) ? null : _empty,
          initialValue: '',
          keyboardType: TextInputType.text,
          obscureText: false,
          decoration: theme.inputDecoration(type: theme.InputType.email, label: label)),
    );
  }

  Widget _languageField(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
      child: TextFormField(
          cursorColor: Colors.black,
          maxLength: 30,
          onChanged: (val) => context.read<ForgotPwdProvider>().onLanguageChange(val),
          validator: (v) => (v != null && v.length >= 2) ? null : _empty,
          initialValue: '',
          keyboardType: TextInputType.text,
          decoration: theme.inputDecoration(type: theme.InputType.learnLang, label: label)),
    );
  }

  void showNewPasswordDialog(BuildContext context) {
    final String newPwd = AppLocalizations.of(context)?.pwdWasChanged ?? 'Password was changed';
    final String pwd = AppLocalizations.of(context)?.pwd ?? 'password';
    final String notStrong =
        AppLocalizations.of(context)?.pwdWasChanged ?? 'password is not strong!';
    final String change = AppLocalizations.of(context)?.changePwd ?? 'Change password';
    final String cancel = AppLocalizations.of(context)?.cancel ?? 'Cancel';

    final GlobalKey<FormState> resetPwdFormKey =
        GlobalKey<FormState>(debugLabel: 'Forgot-password-resetPwdFormKey');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          newPwd,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 17.0),
        ),
        titlePadding: const EdgeInsets.only(top: 6.0, bottom: 4.0),
        content: SingleChildScrollView(
          child: Form(
            key: resetPwdFormKey,
            child: Wrap(children: [
              TextFormField(
                  decoration: InputDecoration(hintText: pwd),
                  initialValue: '',
                  keyboardType: TextInputType.text,
                  maxLength: 40,
                  onChanged: (val) => context.read<ForgotPwdProvider>().onNewPasswordChange(val),
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (v) {
                    if (v == null || v.isEmpty) return _empty;
                    if (v.length < 6) return notStrong;
                    return null;
                  }),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                    onPressed: () {
                      resetPwdFormKey.currentState?.validate();
                      _handleSaveNewPassword(context);
                    },
                    child: Text(change)),
                TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(cancel)),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSaveNewPassword(BuildContext context) async {
    final String changed = AppLocalizations.of(context)?.pwdWasChanged ?? 'Password was changed';
    if (context.read<ForgotPwdProvider>().resetAttempts > 3) return;
    if (context.read<ForgotPwdProvider>().validateNewPassword()) {
      Navigator.of(context).pop();
      final bool isChanged = await context.read<ForgotPwdProvider>().changePassword();
      if (isChanged) {
        if (!mounted) return;
        utils.showSnackBarInfo(context, msg: changed);
      }
    }
  }

  Widget _buildStatusBlockedScreen() {
    final String noMore =
        AppLocalizations.of(context)?.cannotTryNoMore ?? 'Please register new user';
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(noMore),
        const SizedBox(height: 25),
        IconButton(
            iconSize: 28.0,
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_rounded))
      ]),
    );
  }

  Widget _buildErrorScreen(String errorMsg) {
    final String noData = AppLocalizations.of(context)?.noData ?? 'The data is not available';
    return Center(
      child: OverflowBar(
          overflowAlignment: OverflowBarAlignment.center,
          spacing: 25.0,
          overflowSpacing: 3.0,
          children: [
            Text(noData),
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
