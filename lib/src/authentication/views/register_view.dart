import 'package:davar/src/authentication/authentication.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/theme/theme.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);
  static const routeName = '/register';

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _registerFormKye = GlobalKey<FormState>(debugLabel: 'Register form');
  bool _isHidden = true;
  String _native = 'My language';
  String _toLearn = 'I will learn';
  String _empty = 'cannot be empty';
  String _invalid = 'invalid value';
  static const _passPattern2 = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{5,}$';
  static const _emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  void initState() {
    super.initState();
    _native = utils.capitalize(AppLocalizations.of(context)?.authYourLanguage ?? 'My language');
    _toLearn = utils.capitalize(AppLocalizations.of(context)?.languageToLearn ?? 'I will learn');
    _empty = AppLocalizations.of(context)?.fieldNotEmpty ?? 'cannot be empty';
    _invalid = AppLocalizations.of(context)?.invalidEmail ?? 'invalid value';
  }

  @override
  Widget build(BuildContext context) {
    final String profile =
        AppLocalizations.of(context)?.createLearningProfile ?? 'Create your learning profile';
    final String name = utils.capitalize(AppLocalizations.of(context)?.authName ?? 'Name');
    final String pwd = utils.capitalize(AppLocalizations.of(context)?.pwd ?? 'Password');
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            Form(
              key: _registerFormKye,
              child: Padding(
                padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 30.0),
                child: Column(children: <Widget>[
                  Text(profile,
                      textAlign: TextAlign.center, style: const TextStyle(fontSize: 18.0)),
                  const SizedBox(height: 20.0),
                  _nameField(context, name),
                  const SizedBox(height: 8.0),
                  _emailField(context, 'Email'),
                  const SizedBox(height: 8.0),
                  _passwordField(context, pwd),
                  const SizedBox(height: 15.0),
                  Text(_native,
                      style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                  _buildMyLanguageDropdown(context),
                  const SizedBox(height: 8.0),
                  Text(_toLearn,
                      style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                  _buildWantLearnDropdown(context),
                  _buildSubmitButton(),
                  _buildSignInOption(context),
                  _buildErrorInformation(),
                ]),
              ),
            )
          ]),
        ),
      ]),
    );
  }

  Padding _buildSignInOption(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: TextButton(
        child: const Text(
          'Sign In',
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        onPressed: () => context.read<AuthProvider>().onLoginRequest(),
      ),
    );
  }

  // the form text fields are responsible for validation!

  Widget _nameField(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
      child: TextFormField(
          cursorColor: Colors.black,
          maxLength: 30,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp('[ a-zA-Z0-9 -]'))
          ],
          onChanged: (val) => context.read<RegistrationProvider>().onNameChange(val),
          validator: (v) => (v != null && v.length > 2) ? null : _empty,
          initialValue: '',
          keyboardType: TextInputType.text,
          obscureText: false,
          decoration: inputDecoration(label: label)),
    );
  }

  Widget _emailField(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
      child: TextFormField(
          cursorColor: Colors.black,
          maxLength: 40,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.deny(RegExp("['+;=?!*^%#([\\)<>/&/,\":]"))
          ],
          onChanged: (val) => context.read<RegistrationProvider>().onEmailChange(val),
          validator: (v) {
            if (v == null || v.isEmpty) return _empty;
            bool emailValid = RegExp(_emailPattern).hasMatch(v);
            if (!emailValid) return _invalid;
            return null;
          },
          initialValue: '',
          keyboardType: TextInputType.emailAddress,
          obscureText: false,
          decoration: inputDecoration(label: label)),
    );
  }

  Widget _passwordField(BuildContext context, String label) {
    final String invalid =
        '${AppLocalizations.of(context)?.invalidPwd ?? 'Invalid password!Example:'} Aa!123';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
      child: TextFormField(
          cursorColor: Colors.black,
          onChanged: (val) => context.read<RegistrationProvider>().onPasswordChange(val),
          validator: (v) {
            if (v == null || v.isEmpty) return _empty;
            bool passValid = RegExp(_passPattern2).hasMatch(v);
            if (!passValid) return invalid;
            return null;
          },
          initialValue: '',
          keyboardType: TextInputType.visiblePassword,
          obscureText: _isHidden,
          decoration: inputDecoration(
              label: label, togglePassVisibility: _togglePasswordView, isPassHidden: _isHidden)),
    );
  }

  Widget _buildMyLanguageDropdown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 35),
      child: Consumer<RegistrationProvider>(
          builder: (BuildContext context, RegistrationProvider provider, _) {
        return LanguageDropdown<String>(
            hintText: _native,
            options: [...SupportedLanguages.names],
            value: provider.native,
            onChanged: (String? newValue) => provider.onNativeChange(newValue ?? 'English'),
            getLabel: (String value) => value,
            key: const Key('LanguageDropdown-My-language'));
      }),
    );
  }

  Widget _buildWantLearnDropdown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 35),
      child: Consumer<RegistrationProvider>(
          builder: (BuildContext context, RegistrationProvider provider, _) {
        return LanguageDropdown<String>(
            hintText: _toLearn,
            options: [...SupportedLanguages.names],
            value: provider.learning,
            onChanged: (String? newValue) => provider.onLearningChange(newValue ?? 'other'),
            getLabel: (String value) => value,
            key: const Key('LanguageDropdown-I-want-to-learn'));
      }),
    );
  }

  Padding _buildSubmitButton() {
    final String wait = '${AppLocalizations.of(context)?.wait ?? 'Please wait'}...';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 35),
      child: Consumer<RegistrationProvider>(
          builder: (BuildContext context, RegistrationProvider provider, _) {
        switch (provider.status) {
          case RegistrationStatus.success:
            return FormSubmitBtn(
              key: const Key('register-view-submit'),
              formState: _registerFormKye.currentState,
              txt: 'Sign Up',
              onSubmit: () => _onFormSubmit(context, _registerFormKye.currentState),
            );
          case RegistrationStatus.submitting:
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.grey,
            ));
          default:
            return FormSubmitBtn(
              key: const Key('register-view-submit - wait'),
              formState: _registerFormKye.currentState,
              txt: wait,
              onSubmit: () {},
            );
        }
      }),
    );
  }

  void _onFormSubmit(BuildContext context, FormState? fs) {
    final String again = AppLocalizations.of(context)?.tryFromBeginniing ?? 'Please try again';
    if (fs == null) {
      context.read<RegistrationProvider>().registrationErrorMsg = again;
      return;
    }
    fs.save();
    context.read<RegistrationProvider>().onSubmit();
  }

  Consumer<RegistrationProvider> _buildErrorInformation() {
    return Consumer<RegistrationProvider>(
        builder: (BuildContext context, RegistrationProvider provider, _) {
      final String error = provider.registrationError;
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
