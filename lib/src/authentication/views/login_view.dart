import 'package:davar/src/authentication/authentication.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/theme/theme.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    _loginFormKey = GlobalKey<FormState>(debugLabel: 'Login form');
    super.initState();
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          const Text('Welcome back',
                              textAlign: TextAlign.center, style: TextStyle(fontSize: 18.0)),
                          const SizedBox(height: 40.0),
                          _emailField(context, 'Email'),
                          const SizedBox(height: 8.0),
                          _passwordField(context, 'Password'),
                          const SizedBox(height: 20.0),
                          _buildSubmitButton(),
                          _buildForgotPasswordBtn(context),
                          _buildSignUpBtn(context),
                          _buildErrorInformation(),
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
            if (v == null || v.isEmpty) return 'Password is empty!';
            return null;
          },
          initialValue: '',
          keyboardType: TextInputType.visiblePassword,
          obscureText: _isHidden,
          decoration: inputDecoration(
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
            if (v == null || v.isEmpty) return 'Email cannot be empty!';
            if (v.length < 4 || !v.contains('@')) return '$v is not valid email';
            return null;
          },
          initialValue: '',
          keyboardType: TextInputType.emailAddress,
          decoration: inputDecoration(label: label)),
    );
  }

  Widget _buildForgotPasswordBtn(BuildContext context) {
    return Consumer<LoginProvider>(builder: (BuildContext context, LoginProvider lp, _) {
      bool isLoading = lp.status == LoginStatus.submitting;
      return Padding(
          padding: const EdgeInsets.symmetric(
              // horizontal: MediaQuery.of(context).size.width * 28.0 / 100
              horizontal: 2.0),
          child: TextButton(
              onPressed: isLoading ?  null : () => _forgotPasswordRequest(lp),
              child: isLoading ? const CircularProgressIndicator() : const Text('Forgot password?',
                  style: TextStyle(
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
        MaterialPageRoute(
            builder: (context) =>
                ForgotPwdView(user: u)),
      );
    }
  }

  Padding _buildSignUpBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          // horizontal: MediaQuery.of(context).size.width * 34.0 / 100
          horizontal: 2.0),
      child: TextButton(
        child: const Text('Sign Up',
            style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
        onPressed: () => context.read<AuthProvider>().onRegisterRequest(),
      ),
    );
  }

  Padding _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 35),
      child: Consumer<LoginProvider>(builder: (BuildContext context, LoginProvider provider, _) {
        switch (provider.status) {
          case LoginStatus.success:
            return FormSubmitBtn(
                key: const Key('login-view-submit'),
                formState: _loginFormKey.currentState,
                txt: 'Sign In',
                onSubmit: () => _onFormSubmit(context, _loginFormKey.currentState));
          case LoginStatus.submitting:
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.grey,
            ));
          default:
            return FormSubmitBtn(
                key: const Key('login-view-wait'),
                formState: _loginFormKey.currentState,
                txt: 'Wait...',
                onSubmit: () {});
        }
      }),
    );
  }

  void _onFormSubmit(BuildContext context, FormState? fs) {
    if (fs == null) {
      context.read<LoginProvider>().loginErrorMsg = 'Please try again from the beginning';
      return;
    }
    fs.save();
    context.read<LoginProvider>().onSubmit();
  }

  Consumer<LoginProvider> _buildErrorInformation() {
    return Consumer<LoginProvider>(builder: (BuildContext context, LoginProvider provider, _) {
      final String error = provider.loginError;
      final bool isErrorMessage = error.isNotEmpty;
      switch (isErrorMessage) {
        case true:
          _showErrorSnackBar(context, error);
          return Text(error,
              style: const TextStyle(color: Colors.red), textAlign: TextAlign.center);
        default:
          return const SizedBox();
      }
    });
  }

  void _showErrorSnackBar(BuildContext context, String authenticationError) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.grey,
        content: Text(authenticationError, textAlign: TextAlign.center),
      ));
    });
  }
}
