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
  String val = '';
  List<_PieData> pieData = [];
  String merchantId = '1000001';
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });
    merchantId =
        Provider.of<AuthManager>(context, listen: false).merchantId ?? '';
    http
        .get(Uri.parse(
            'https://safe-beach-59767.herokuapp.com/merchant/orders/?id=$merchantId'))
        .then((value) {
      var responseOrders = jsonDecode(value.body);
      setState(() {
        List values = cashback(responseOrders);
        pieData = [
          _PieData('Bank', values[0]),
          _PieData('Card', values[1]),
          _PieData('Merchant', values[2]),
        ];
      });
    }).catchError((error) {
      print('I $error');
    });

    http
        .get(Uri.parse(
            'https://safe-beach-59767.herokuapp.com/merchant/show_cashback_percents?id=$merchantId'))
        .then((value) {
      var responseTable = jsonDecode(value.body);
      setState(() {
        makeRowsFromResponse(responseTable);
        val = responseTable['cashback_type'];
      });
      // print('responseTable: $responseTable');
    }).catchError((error) {
      print('I $error');
    });

    Future.delayed(const Duration(seconds: 3));

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter chart'),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          unselectedLabelColor: Colors.black,
          tabs: const [
            Tab(
              child: Text('Cashback'),
            ),
            Tab(
              child: Text('Продажи'),
            ),
            Tab(
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
                    dataLabelSettings:
                        const DataLabelSettings(isVisible: true)),
              ],
            ),
          if (_tabIndex == 2)
            TextButton(
              onPressed: () async {
                //TODO save route
                String merchantId =
                    Provider.of<AuthManager>(context, listen: false)
                            .merchantId ??
                        '';
                final kek = await http.post(
                  Uri.parse(
                      'https://safe-beach-59767.herokuapp.com/merchant/create_cashback_percents'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    "merchant_id": merchantId,
                    "cashback_type": "sum",
                    "cashback": {
                      "high": {
                        "cashback": rows[0]['cashback'],
                        "range": [
                          rows[0]['range_from'],
                          rows[0]['range_to'],
                        ]
                      },
                      "medium": {
                        "cashback": rows[1]['cashback'],
                        "range": [
                          rows[1]['range_from'],
                          rows[1]['range_to'],
                        ]
                      },
                      "low": {
                        "cashback": rows[2]['cashback'],
                        "range": [
                          rows[2]['range_from'],
                          rows[2]['range_to'],
                        ]
                      }
                    }
                  }),
                );
                print(kek.statusCode);
                print(kek.body);
                print(makeAnswerMap(rows, merchantId, 'sum'));

                print(merchantId);
              },
              child: const Text("Сохранить"),
            ),
          if (_tabIndex == 2)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text("По общей сумме"),
                  leading: Radio(
                    value: 'sum',
                    groupValue: val,
                    onChanged: (value) {
                      setState(() {
                        val = 'sum';
                      });
                    },
                    activeColor: Colors.green,
                  ),
                ),
                ListTile(
                  title: const Text("По количеству продаж"),
                  leading: Radio(
                    value: 'count',
                    groupValue: val,
                    onChanged: (value) {
                      setState(() {
                        val = 'count';
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
                  saveTable(value);
                },
                onSubmitted: (value) {
                  // print(rows);
                },
                borderColor: Colors.blueGrey,
                tdStyle: const TextStyle(fontWeight: FontWeight.bold),
                trHeight: 80,
                thStyle:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                thAlignment: TextAlign.center,
                thVertAlignment: CrossAxisAlignment.center,
                thPaddingBottom: 3,
                saveIcon: Icons.save,
                showSaveIcon: true,
                saveIconColor: Colors.black,
                tdAlignment: TextAlign.center,
                tdEditableMaxLines: 100, // don't limit and allow data to wrap
                tdPaddingTop: 0,
                tdPaddingBottom: 14,
                tdPaddingLeft: 10,
                tdPaddingRight: 8,
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(0))),
              ),
            ),
        ],
      ),
    );
  }
}

List<double> cashback(Map response) {
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

void makeRowsFromResponse(Map response) {
  rows.clear();
  rows.add({
    "name": "high",
    "range_from": response['cashback']['high']['range'][0],
    "range_to": '',
    "cashback": response['cashback']['high']['cashback']
  });
  rows.add({
    "name": "medium",
    "range_from": response['cashback']['medium']['range'][0],
    "range_to": response['cashback']['medium']['range'][1],
    "cashback": response['cashback']['medium']['cashback']
  });
  rows.add({
    "name": "low",
    "range_from": response['cashback']['low']['range'][0],
    "range_to": response['cashback']['low']['range'][1],
    "cashback": response['cashback']['low']['cashback']
  });
}

Map makeAnswerMap(List rows, String merchantId, String cashbackType) {
  Map map = {};
  for (int i = 0; i < rows.length; i++) {
    map.addAll({
      rows[i]['name']: {
        "cashback": rows[i]['cashback'],
        "range": [rows[i]['range_from'], rows[i]['range_to']]
      }
    });
  }
  Map temp = {
    "merchant_id": merchantId,
    "cashback_type": cashbackType,
    "cashback": map
  };
  return temp;
}

List rows = [];

void saveTable(Map map) {
  for (final item in map.keys) {
    if (item != 'row') {
      rows[map['row']][item] = map[item];
    }
  }
}

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
