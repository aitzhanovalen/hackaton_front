import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hack/screens/product_detail.dart';

class ProductTile extends StatelessWidget {
  final Map<String, dynamic> item;

  const ProductTile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> prices = (List.from(item['merchants'])..sort((a, b) => a['price'] - b['price'])).toList();
    print('your prices $prices');
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(item: item)));
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Image.network(
              'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6009/6009925_sd.jpg',
              width: 100,
              height: 200,
            ),
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['title']),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(item['description'], maxLines: 2, textAlign: TextAlign.justify,),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                    Text(prices.first['price'].toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(' - ${prices.last['price']} TG', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
