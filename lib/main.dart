import 'dart:convert';

import 'package:flutter/material.dart';
import '../screens/screens.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'models/auth_manager.dart';

void main() => runApp(MaterialApp(
      home: OwnerApp(),
    ));

class OwnerApp extends StatefulWidget {
  const OwnerApp({Key? key}) : super(key: key);

  @override
  _OwnerAppState createState() => _OwnerAppState();
}

class _OwnerAppState extends State<OwnerApp> {
  final _authManager = AuthManager();
  @override
  void initState() {
    http
        .get(Uri.parse(
            'https://safe-beach-59767.herokuapp.com/merchant/ctlg/?id=1000001'))
        .then((value) {
      var response = jsonDecode(value.body);
      print(response);
    }).catchError((error) {
      print('I diagnose you with gay');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _authManager),
      ],
      child: Scaffold(
        // body: SalesChart(),
        // body: Products(),
        body: FirstScreen(),
      ),
    );
  }
}
