import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hack/widgets/product_tile.dart';
import 'package:http/http.dart' as http;

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);
  final String customerId = '';

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<dynamic> products = [];



  @override
  void initState() {
    http
        .get(Uri.parse('https://safe-beach-59767.herokuapp.com/product/ctlg/'))
        .then((value) {
      Map<String, dynamic> response = jsonDecode(value.body);
      print(jsonDecode(value.body));
      if (response['status'] == 200) {
        setState(() {
          products = response['data'];
        });
      }
    }).catchError((error) {
      print('You suck $error');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) => ProductTile(item: products[index]),
        itemCount: products.length,
      ),
    );
  }
}
