import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages.dart';
import '../providers.dart';
import '../styles.dart';
import '../utils/nav.dart';
import '../utils/utils.dart';
import '../widgets/loading.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _busy = false;
  bool hidePassword = true;
  AuthProvider userProvider;

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
        Padding(
          padding: _insets0,
          child: Container(
            decoration: _containerDecoration,
            child: _form,
          ),
        ),
      ],
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

  Widget get _form {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          _logo,
          _nameField,
          _emailField,
          _passwordField,
          _submitButton,
          _haveAccountButton,
        ],
      ),
    );
  }

  Widget get _nameField {
    return Padding(
      padding: _insetsH30V10,
      child: Material(
        borderRadius: _circularBorder10,
        color: Colors.grey.withOpacity(0.3),
        elevation: 0,
        child: Padding(
          padding: _insetsL12,
          child: ListTile(
            title: TextFormField(
              controller: _name,
              decoration: InputDecoration(
                hintText: "Full name",
                icon: Icon(Icons.person_outline),
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value.isEmpty) return "Enter name";
                return null;
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget get _emailField {
    return Padding(
      padding: _insetsH30V10,
      child: Material(
        borderRadius: _circularBorder10,
        color: Colors.grey.withOpacity(0.2),
        elevation: 0,
        child: Padding(
          padding: _insetsL12,
          child: ListTile(
            title: TextFormField(
              controller: _email,
              decoration: InputDecoration(
                hintText: "Email",
                icon: Icon(Icons.alternate_email),
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value.isEmpty) return 'Enter email';
                if (!isEmail(value)) return 'Make sure your email address is valid';
                return null;
              },
            ),
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
          child: ListTile(
            title: TextFormField(
              controller: _password,
              obscureText: hidePassword,
              decoration: InputDecoration(
                hintText: "Password",
                icon: Icon(Icons.lock_outline),
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value.isEmpty) return "Enter password";
                if (value.length < 6) return "Password must be at least 6 characters";
                return null;
              },
            ),
            trailing: IconButton(
              icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => hidePassword = !hidePassword),
            ),
          ),
        ),
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
          onPressed: _busy ? null : () => onSubmit(),
          minWidth: MediaQuery.of(context).size.width,
          child: Text(
            "Sign up",
            textAlign: TextAlign.center,
            style: _whiteBoldS20Style,
          ),
        ),
      ),
    );
  }

  Widget get _haveAccountButton {
    return Padding(
      padding: _insets8,
      child: InkWell(
        onTap: () => Nav.replacePage(context, LoginPage()),
        child: Text(
          "I already have an account",
          textAlign: TextAlign.center,
          style: _blackS16Style,
        ),
      ),
    );
  }

  Future<void> onSubmit() async {
    if (!_formKey.currentState.validate()) return;

    try {
      busy = true;
      final ok = await userProvider.signUp(_name.text, _email.text, _password.text);
      if (!ok) {
        _key.currentState.showSnackBar(SnackBar(content: Text("Sign up failed")));
        return;
      }
    } catch (e) {
      // ...
    } finally {
      busy = false;
    }

    Nav.replacePage(context, HomePage());
  }

  final _insetsH30V10 = EdgeInsets.symmetric(horizontal: 30, vertical: 10);
  final _insets0 = EdgeInsets.all(0);
  final _insets8 = EdgeInsets.all(8);
  final _insets16 = EdgeInsets.all(16);
  final _insetsL12 = EdgeInsets.only(left: 12);

  final _circularBorder10 = BorderRadius.circular(10);
  final _circularBorder20 = BorderRadius.circular(20);

  final _whiteBoldS20Style = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20);
  final _blackS16Style = TextStyle(color: Colors.black, fontSize: 16);

  final _containerDecoration = BoxDecoration(
    color: Styles.colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(color: Colors.grey[350], blurRadius: 20),
    ],
  );
}
