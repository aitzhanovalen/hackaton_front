import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hack/models/auth_manager.dart';
import 'package:provider/provider.dart';
import 'screens.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    customerController.text = '1000001';
    merchantController.text = '1000001';
    super.initState();
  }

  final TextEditingController customerController = TextEditingController();
  final TextEditingController merchantController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Программа лояльности'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('покупатель'),
                Container(
                  padding: const EdgeInsets.all(20),
                  width: 150,
                  child: TextField(
                    decoration:
                        const InputDecoration(fillColor: Colors.transparent),
                    controller: customerController,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Provider.of<AuthManager>(context, listen: false)
                        .customerId = customerController.text;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Products()));
                  },
                  child: const Text("Войти"),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('продавец'),
                Container(
                  padding: const EdgeInsets.all(20),
                  width: 150,
                  child: TextField(
                    decoration:
                        const InputDecoration(fillColor: Colors.transparent),
                    controller: merchantController,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Provider.of<AuthManager>(context, listen: false)
                        .merchantId = merchantController.text;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SalesChart()));
                  },
                  child: const Text("Войти"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
