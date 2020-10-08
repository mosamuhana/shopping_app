import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/pages.dart';
import 'src/providers.dart';
import 'src/styles.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: AuthProvider()),
      ChangeNotifierProvider.value(value: ProductProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Shopping App',
      theme: Styles.theme,
      home: StartupPage(),
    );
  }
}
