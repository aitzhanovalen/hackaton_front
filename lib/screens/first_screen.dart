import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    customerController.text = '0000001';
    merchantController.text = '0000002';
    super.initState();
  }

  final TextEditingController customerController = TextEditingController();
  final TextEditingController merchantController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Программа лояльности'),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Text('логин покупателя'),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width:150,
                  child: TextField(
                    decoration:
                        const InputDecoration(fillColor: Colors.transparent),
                    controller: customerController,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Products()));
                  },
                  child: Text("Войти"),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text('логин продавца'),
            TextField(
              controller: merchantController,
            )
          ],
        ),
      ),
    );
  }
}
