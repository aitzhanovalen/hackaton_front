import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hack/models/auth_manager.dart';
import 'package:hack/widgets/product_tile.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<dynamic> products = [];
  String customerId = '';

  @override
  void initState() {
    customerId =
        Provider.of<AuthManager>(context, listen: false).customerId ?? '';
    http
        .get(Uri.parse('https://safe-beach-59767.herokuapp.com/product/ctlg/?c_id=$customerId'))
        .then((value) {
      Map<String, dynamic> response = jsonDecode(value.body);
      print(jsonDecode(value.body));
      if (response['status'] == 200) {
        setState(() {
          products = response['data'];
        });
      }
    }).catchError((error) {
      print('Your: $error');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Товары'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => ProductTile(item: products[index]),
        itemCount: products.length,
      ),
    );
  }
}
