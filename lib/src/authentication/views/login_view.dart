import 'package:davar/src/authentication/authentication.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/theme/theme.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);
  static const routeName = '/login';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final ScrollController _controller = ScrollController();
  late GlobalKey<FormState> _loginFormKey;

  bool _isHidden = true;
  String _empty = 'cannot be empty';
  String _invalid = 'invalid value';
  String _errorInfo = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loginFormKey = GlobalKey<FormState>(debugLabel: 'Login form');
    _empty = AppLocalizations.of(context)?.fieldNotEmpty ?? 'cannot be empty';
    _invalid = AppLocalizations.of(context)?.invalidEmail ?? 'invalid value';
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String welcome = AppLocalizations.of(context)?.welcomeBack ?? 'Welcome back';
    final String pwd = utils.capitalize(AppLocalizations.of(context)?.pwd ?? 'Password');
    return Scaffold(
        key: const Key('Login scaffold'),
        body: CustomScrollView(
          key: const Key('Login CustomScrollView'),
          controller: _controller,
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                Form(
                  key: _loginFormKey,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 30.0),
                    child: Center(
                      child: Column(children: <Widget>[
                        Text(welcome,
                            textAlign: TextAlign.center, style: const TextStyle(fontSize: 18.0)),
                        const SizedBox(height: 40.0),
                        _emailField(context, 'Email'),
                        const SizedBox(height: 8.0),
                        _passwordField(context, pwd),
                        const SizedBox(height: 20.0),
                        _buildSubmitButton(),
                        _buildForgotPasswordBtn(context),
                        _buildSignUpBtn(context),
                        _errorInfo.isNotEmpty
                            ? SmallUserDialog(_errorInfo, _resetError)
                            : const SizedBox.shrink(),
                        Selector<LoginProvider, String>(
                            selector: (_, state) => state.loginError,
                            builder: (BuildContext context, err, __) {
                              if (err.isNotEmpty) {
                                return SmallUserDialog(
                                    err, context.read<LoginProvider>().confirmReadErrorMsg);
                              }
                              return const SizedBox.shrink();
                            }),
                      ]),
                    ),
                  ),
                )
              ]),
            )
          ],
        ));
  }

  Widget _passwordField(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
      child: TextFormField(
          onChanged: (pass) => context.read<LoginProvider>().onPasswordChange(pass),
          validator: (v) {
            if (v == null || v.isEmpty) return _empty;
            return null;
          },
          initialValue: '',
          keyboardType: TextInputType.visiblePassword,
          obscureText: _isHidden,
          decoration: inputDecoration(type: InputType.pwd,
              label: label, togglePassVisibility: _togglePasswordView, isPassHidden: _isHidden)),
    );
  }

  Widget _emailField(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
      child: TextFormField(
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.deny(RegExp("['+;=?!*^%#([)<>/&/,\":]"))
          ],
          onChanged: (e) => context.read<LoginProvider>().onEmailChange(e),
          autocorrect: false,
          validator: (v) {
            if (v == null || v.isEmpty) return _empty;
            if (v.length < 4 || !v.contains('@')) return '$v $_invalid';
            return null;
          },
          initialValue: '',
          keyboardType: TextInputType.emailAddress,
          decoration: inputDecoration(type: InputType.email, label: label)),
    );
  }

  Widget _buildForgotPasswordBtn(BuildContext context) {
    final String forgotPwd = AppLocalizations.of(context)?.forgotPwd ?? 'Forgot password?';
    return Consumer<LoginProvider>(builder: (BuildContext context, LoginProvider lp, _) {
      bool isLoading = lp.status == LoginStatus.submitting;
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: TextButton(
              onPressed: isLoading ? null : () => _forgotPasswordRequest(lp),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Text(forgotPwd,
                      style: const TextStyle(
                          color: Colors.black54, fontSize: 10, fontStyle: FontStyle.italic))));
    });
  }

  Future<void> _forgotPasswordRequest(LoginProvider lp) async {
    lp.onForgotPassword().then((User? user) => _navigateToReset(user));
  }

  void _navigateToReset(User? u) {
    if (u != null && u.id > 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ForgotPwdView(user: u)),
      );
    }
  }

  Padding _buildSignUpBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          // horizontal: MediaQuery.of(context).size.width * 34.0 / 100
          horizontal: 2.0),
      child: TextButton(
        child: const Text('Register',
            style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
        onPressed: () => context.read<AuthProvider>().onRegisterRequest(),
      ),
    );
  }

  Padding _buildSubmitButton() {
    final String wait = '${AppLocalizations.of(context)?.wait ?? 'Please wait'}...';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 35),
      child: Consumer<LoginProvider>(builder: (BuildContext context, LoginProvider provider, _) {
        switch (provider.status) {
          case LoginStatus.success:
            return FormSubmitBtn(
                key: const Key('login-view-submit'),
                formState: _loginFormKey.currentState,
                txt: 'Login',
                onSubmit: () => _onFormSubmit(context, _loginFormKey.currentState));
          case LoginStatus.submitting:
            return const Center(
                child: CircularProgressIndicator.adaptive());
          default:
            return FormSubmitBtn(
                key: const Key('login-view-wait'),
                formState: _loginFormKey.currentState,
                txt: wait,
                onSubmit: () {});
        }
      }),
    );
  }

  void _resetError() {
    setState(() {
      _errorInfo = '';
    });
  }

  void _onFormSubmit(BuildContext context, FormState? fs) {
    final String again = AppLocalizations.of(context)?.tryFromBeginning ?? 'Please try again';
    if (fs == null) {
      setState(() {
        _errorInfo = again;
      });
      return;
    }
    fs.save();
    context.read<LoginProvider>().onSubmit();
  }
}
