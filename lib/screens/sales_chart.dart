import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hack/models/auth_manager.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:editable/editable.dart';

class SalesChart extends StatefulWidget {
  const SalesChart({Key? key}) : super(key: key);

  @override
  _SalesChartState createState() => _SalesChartState();
}

class _PieData {
  _PieData(
    this.xData,
    this.yData,
  );

  final String xData;
  final num yData;
}

class _SalesChartState extends State<SalesChart>
    with SingleTickerProviderStateMixin {
  int _tabIndex = 0;
  List<_PieData> pieData = [
    // _PieData('Jan', 35, ),
    // _PieData('Feb', 28, ),
    // _PieData('Mar', 34, ),
    // _PieData('Apr', 32, ),
    // _PieData('May', 40, )
  ];
  String merchantId = '1000001';
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      print(_tabController.index);
      setState(() {
        _tabIndex = _tabController.index;
      });
    });
    merchantId =
        Provider.of<AuthManager>(context, listen: false).merchantId ?? '';
    http
        .get(Uri.parse(
            'https://safe-beach-59767.herokuapp.com/merchant/ctlg/?id=$merchantId'))
        .then((value) {
      var response = jsonDecode(value.body);
      print(response);
    }).catchError((error) {
      print('I diagnose you with gay');
    });

    // Future.delayed(Duration(seconds: 3));
    setState(() {
      List values = cashback(response);
      pieData = [
        _PieData('Bank', values[0]),
        _PieData('Card', values[1]),
        _PieData('Merchant', values[2]),
      ];
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool _value = false;
    int val = -1;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter chart'),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          unselectedLabelColor: Colors.black,
          tabs: [
            const Tab(
              child: Text('Cashback'),
            ),
            const Tab(
              child: Text('Продажи'),
            ),
            const Tab(
              child: Text('Настройки'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_tabIndex == 0)
            SfCircularChart(
                title: ChartTitle(text: 'Sales by sales person'),
                legend: Legend(isVisible: true),
                series: <PieSeries<_PieData, String>>[
                  PieSeries<_PieData, String>(
                      explode: true,
                      explodeIndex: 0,
                      dataSource: pieData,
                      xValueMapper: (_PieData data, _) => data.xData,
                      yValueMapper: (_PieData data, _) => data.yData,
                      // dataLabelMapper: (_PieData data, _) => data.text,
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true)),
                ]),
          if (_tabIndex == 2)
            TextButton(
              onPressed: () {
                //TODO save route
                print(Provider.of<AuthManager>(context, listen: false)
                    .merchantId);
              },
              child: const Text("Сохранить"),
            ),
          if (_tabIndex == 2)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Row(children: [
                //   Gesture
                // ],)
                ListTile(
                  title: Text("По количеству продаж"),
                  leading: Radio(
                    value: 1,
                    groupValue: val,
                    onChanged: (value) {
                      setState(() {
                        val = value == true ? 1 : 2;
                      });
                    },
                    activeColor: Colors.green,
                  ),
                ),
                ListTile(
                  title: Text("По общей сумме"),
                  leading: Radio(
                    value: 2,
                    groupValue: val,
                    onChanged: (value) {
                      setState(() {
                        val = value == true ? 2 : 1;
                      });
                    },
                    activeColor: Colors.green,
                  ),
                ),
              ],
            ),
          if (_tabIndex == 2)
            Expanded(
              child: Editable(
                columns: cols,
                rows: rows,
                zebraStripe: true,
                stripeColor1: Colors.blue.shade100,
                stripeColor2: Colors.grey.shade200,
                onRowSaved: (value) {
                  print(value);
                },
                onSubmitted: (value) {
                  print(value);
                },
                borderColor: Colors.blueGrey,
                tdStyle: const TextStyle(fontWeight: FontWeight.bold),
                trHeight: 80,
                thStyle:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                thAlignment: TextAlign.center,
                thVertAlignment: CrossAxisAlignment.end,
                thPaddingBottom: 3,
                saveIconColor: Colors.black,
                tdAlignment: TextAlign.left,
                tdEditableMaxLines: 100, // don't limit and allow data to wrap
                tdPaddingTop: 0,
                tdPaddingBottom: 14,
                tdPaddingLeft: 10,
                tdPaddingRight: 8,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(0))),
              ),
            ),
        ],
      ),
    );
  }
}

List<double> cashback(Map<String, dynamic> response) {
  List<double> cashback = [0.0, 0.0, 0.0];
  for (final item in response['data']) {
    double totalPercent = 0;
    double totalSumOfBank = 0;
    double totalSumOfMerchant = 0;
    double totalSumOfCard = 0;
    for (final key in item['cashback_percent'].keys) {
      totalPercent += item['cashback_percent'][key];
      if (key == 'bank') {
        totalSumOfBank += item['cashback_percent'][key] * item['cashback'];
      }
      if (key == 'payment_system') {
        totalSumOfCard += item['cashback_percent'][key] * item['cashback'];
      }
      if (key == 'merchant') {
        totalSumOfMerchant += item['cashback_percent'][key] * item['cashback'];
      }
    }
    cashback[0] += totalSumOfBank / totalPercent;
    cashback[1] += totalSumOfCard / totalPercent;
    cashback[2] += totalSumOfMerchant / totalPercent;
  }
  return cashback;
}

List<dynamic> getCustomers(Map<String, dynamic> response) {
  List<dynamic> customers = [];
  Set<String> customerId = {};
  for (final item in response['data']) {
    customerId.add(item['client_id']);
  }
  return customers;
}

Map<String, dynamic> settings = {
  "status": 200,
  "merchant_id": "100001",
  "cashback_type": "sum", // "count"
  "cashback": {
    "high": {
      "cashback": 5.0,
      "range": [21]
    },
    "medium": {
      "cashback": 3.5,
      "range": [11, 20]
    },
    "low": {
      "cashback": 1.5,
      "range": [1, 10]
    },
  },
};

Map<String, dynamic> response = {
  "status": 200,
  "data": [
    {
      "sku": "111445GA8",
      "title": "Apple iPhone 12 Pro 128Gb синий",
      "client_id": "1000003",
      "price": 10000,
      "cashback": 200,
      "cashback_percent": {"bank": 1, "payment_system": 0.5, "merchant": 0.5}
    },
    {
      "sku": "111445GA8",
      "title": "Apple iPhone 12 Pro 128Gb синий",
      "client_id": "1000001",
      "price": 100000,
      "cashback": 2000,
      "cashback_percent": {"bank": 1, "payment_system": 0.5, "merchant": 0.5}
    },
    {
      "sku": "111445GA8",
      "title": "Apple iPhone 12 Pro 128Gb синий",
      "client_id": "1000001",
      "price": 20000,
      "cashback": 400,
      "cashback_percent": {"bank": 1, "payment_system": 0.5, "merchant": 0.5}
    },
    {
      "sku": "111445GA8",
      "title": "Apple iPhone 12 Pro 128Gb синий",
      "client_id": "1000002",
      "price": 20000,
      "cashback": 600,
      "cashback_percent": {"bank": 1, "payment_system": 0.5, "merchant": 1.5}
    },
    {
      "sku": "111445GA8",
      "title": "Apple iPhone 12 Pro 128Gb синий",
      "client_id": "1000001",
      "price": 20000,
      "cashback": 600,
      "cashback_percent": {"bank": 1, "payment_system": 0.5, "merchant": 1.5}
    }
  ]
};

List rows = [
  {"name": 'low', "range_from": 1, "range_to": 10, "cashback": 2.0},
  {
    "name": 'medium',
    "range_from": 11,
    "range_to": 20,
    "cashback": 3.5,
  },
  {"name": 'high', "range_from": 21, "range_to": 500, "cashback": 5.0},
];

List cols = [
  {
    "title": 'Наименование',
    'widthFactor': 0.2,
    'key': 'name',
    'editable': false
  },
  {"title": 'От', 'widthFactor': 0.2, 'key': 'range_from'},
  {"title": 'До', 'widthFactor': 0.2, 'key': 'range_to'},
  {"title": 'cashback', 'key': 'cashback'},
];
