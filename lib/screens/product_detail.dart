import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ProductDetail extends StatelessWidget {
  final Map<String, dynamic> item;
  final List<String> images = [
    'assets/images/iphone1.png',
    'assets/images/iphone2.png',
  ];

  ProductDetail({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(item['title']),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: CarouselSlider(
                  options: CarouselOptions(),
                  items: images
                      .map((item) => Container(
                            child: Center(
                              child: Image.asset(item),
                            ),
                            color: Colors.white,
                          ))
                      .toList(),
                ),
              ),
              Text(
                item['title'],
                style: TextStyle(
                    fontWeight: FontWeight.bold, height: 1.5, fontSize: 18.0),
              ),
              SizedBox(
                height: 15,
              ),
              Text(item['description'].replaceAll('-', '\n')),
              // Text(
              //   item['description'],
              //   style: TextStyle(height: 1.2),
              // ),
              SizedBox(
                height: 15,
              ),
              _renderMerchants(context, item['merchants']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderMerchants(BuildContext context, List<dynamic> merchants) {
    return Column(
      children: merchants.map((merchant) {
        print(merchant);
        //Merchant item = Merchant.fromJson(merchant);
        return Container(
          // decoration: BoxDecoration(
          //   border: Border(
          //     top: BorderSide(width: .3, color: Colors.grey),
          //     // bottom: BorderSide(width: 16.0, color: Colors.lightBlue.shade900),
          //   ),
          //   color: Colors.white,
          // ),
          // padding: const EdgeInsets.symmetric(vertical: 8.0),
          // child: GestureDetector(
          //   onTap: () {
          //     showDialog(
          //         context: context,
          //         builder: (context) {
          //           return AlertDialog(
          //             title: Text(item.name),
          //             content: Text('Хотите купить у ${item.name} за ${item.price} тг и получить кэшбэк в размере ${item.cashback} тг?'),
          //             actions: [
          //               TextButton(
          //                 child: Text('Отмена'),
          //                 onPressed: (){
          //                   Navigator.pop(context);
          //                 },
          //               ),
          //               TextButton(
          //                 child: Text('ОК'),
          //                 onPressed: () {
          //                   Navigator.pop(context);
          //                 },
          //               ),
          //             ],
          //           );
          //         });
          //   },
          //   child: Container(
          //     color: Colors.transparent,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text('Продавец:  '),
          //             SizedBox(
          //               height: 8.0,
          //             ),
          //             Text(item.name),
          //           ],
          //         ),
          //         Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Row(children: [
          //               Text('Цена:  '),
          //               Text(item.price.toString()),
          //             ]),
          //             SizedBox(
          //               height: 8.0,
          //             ),
          //             Row(children: [
          //               Text('Cashback:  '),
          //               Text(item.cashback.toString()),
          //             ]),
          //           ],
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        );
      }).toList(),
    );
  }
}

class Merchant {
  final String merchantId;
  final double price;
  final double cashBackPercent;
  final double cashback;
  final String name;

  const Merchant(
      {required this.merchantId,
      required this.price,
      required this.cashBackPercent,
      required this.cashback,
      required this.name});

  factory Merchant.fromJson(Map<String, dynamic> item) {
    return Merchant(
        merchantId: item['m_id'],
        price: item['price'],
        cashBackPercent: item['cashback_percent'],
        cashback: item['cashback'],
        name: item['name']);
  }
}
