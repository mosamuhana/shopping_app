import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers.dart';
import '../pages.dart';

class StartupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return ErrorPage();
          }
          return _startup(context);
        }
        return SplashPage();
      },
    );
  }

  Widget _startup(BuildContext context) {
    Provider.of<ProductProvider>(context).init();
    final userProvider = Provider.of<AuthProvider>(context)..init();

    switch (userProvider.status) {
      case Status.Unauthenticated:
      case Status.Authenticating:
        return LoginPage();
      case Status.Authenticated:
        return HomePage();
      case Status.Uninitialized:
        return SplashPage();
      default:
        return LoginPage();
    }
  }
}
