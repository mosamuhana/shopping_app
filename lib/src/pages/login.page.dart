import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages.dart';
import '../providers.dart';
import '../styles.dart';
import '../utils/nav.dart';
import '../utils/utils.dart';
import '../widgets/loading.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool _busy = false;

  AuthProvider userProvider;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  set busy(bool value) {
    if (_busy != value) {
      setState(() => _busy = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<AuthProvider>(context);

    return WillPopScope(
      onWillPop: () async => !_busy,
      child: IgnorePointer(
        ignoring: _busy,
        child: Scaffold(
          key: _key,
          body: _body,
        ),
      ),
    );
  }

  Widget get _body {
    if (userProvider.status == Status.Authenticating) return Loading();
    return Stack(
      children: [
        Container(
          child: Padding(
            padding: _insets0,
            child: Container(
              decoration: _containerDecoration,
              child: _form,
            ),
          ),
        ),
      ],
    );
  }

  Widget get _form {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          _logo,
          _emailField,
          _passwordField,
          _submitButton,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: _insets8,
                child: _forgotPasswordButton,
              ),
              Padding(
                padding: _insets8,
                child: _createAccountButton,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget get _emailField {
    return Padding(
      padding: _insetsH30V10,
      child: Material(
        borderRadius: _circularBorder10,
        color: Colors.grey.withOpacity(0.3),
        elevation: 0,
        child: Padding(
          padding: _insetsL12,
          child: TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Email",
              icon: Icon(Icons.alternate_email),
            ),
            validator: (value) {
              if (value.isEmpty) return 'Enter email';
              if (!isEmail(value)) return 'Make sure your email address is valid';
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget get _passwordField {
    return Padding(
      padding: _insetsH30V10,
      child: Material(
        borderRadius: _circularBorder10,
        color: Colors.grey.withOpacity(0.3),
        elevation: 0,
        child: Padding(
          padding: _insetsL12,
          child: TextFormField(
            controller: _password,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Password",
              icon: Icon(Icons.lock_outline),
            ),
            validator: (value) {
              if (value.isEmpty) return "Enter password";
              if (value.length < 6) return "Password must be at least 6 characters";
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget get _logo {
    return Padding(
      padding: _insets16,
      child: Container(
        alignment: Alignment.topCenter,
        child: Image.asset('assets/images/logo.png', width: 260),
      ),
    );
  }

  Widget get _submitButton {
    return Padding(
      padding: _insetsH30V10,
      child: Material(
        borderRadius: _circularBorder20,
        color: Colors.black,
        elevation: 0,
        child: MaterialButton(
          onPressed: _busy ? null : () => _onSubmit(),
          minWidth: MediaQuery.of(context).size.width,
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: _whiteBoldS20Style,
          ),
        ),
      ),
    );
  }

  Widget get _createAccountButton {
    return InkWell(
      onTap: () => Nav.replacePage(context, SignupPage()),
      child: Text(
        "Create an account",
        textAlign: TextAlign.center,
        style: _blackStyle,
      ),
    );
  }

  Widget get _forgotPasswordButton {
    return InkWell(
      onTap: () {
        print('Forgot password');
      },
      child: Text(
        "Forgot password",
        textAlign: TextAlign.center,
        style: _blackW400Style,
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState.validate()) return;

    try {
      busy = true;
      final ok = await userProvider.signIn(_email.text, _password.text);
      if (!ok) {
        _key.currentState.showSnackBar(SnackBar(content: Text("Sign in failed")));
      }
    } catch (e) {
      //...
    } finally {
      busy = false;
    }
  }

  final _insetsH30V10 = EdgeInsets.symmetric(horizontal: 30, vertical: 10);
  final _insets0 = EdgeInsets.all(0);
  final _insets8 = EdgeInsets.all(8);
  final _insets16 = EdgeInsets.all(16);
  final _insetsL12 = EdgeInsets.only(left: 12);

  final _circularBorder10 = BorderRadius.circular(10);
  final _circularBorder20 = BorderRadius.circular(20);

  final _whiteBoldS20Style = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20);
  final _blackStyle = TextStyle(color: Colors.black);
  final _blackW400Style = TextStyle(color: Styles.colors.black, fontWeight: FontWeight.w400);

  final _containerDecoration = BoxDecoration(
    color: Styles.colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(color: Colors.grey[350], blurRadius: 20),
    ],
  );
}
