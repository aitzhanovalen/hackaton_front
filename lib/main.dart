import 'package:flutter/material.dart';
import '../screens/screens.dart';
import 'package:provider/provider.dart';

import 'models/auth_manager.dart';

void main() => runApp(OwnerApp());

class OwnerApp extends StatefulWidget {
  const OwnerApp({Key? key}) : super(key: key);

  @override
  _OwnerAppState createState() => _OwnerAppState();
}

class _OwnerAppState extends State<OwnerApp> {
  final _authManager = AuthManager();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _authManager),
      ],
      child: const MaterialApp(
        home: FirstScreen(),
      ),
    );
  }
}
