import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hack/models/auth_manager.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class SalesChart extends StatefulWidget {
  SalesChart({Key? key}) : super(key: key);

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

class _SalesChartState extends State<SalesChart> {
  List<_PieData> pieData = [
    // _PieData('Jan', 35, ),
    // _PieData('Feb', 28, ),
    // _PieData('Mar', 34, ),
    // _PieData('Apr', 32, ),
    // _PieData('May', 40, )
  ];
  String merchantId = '1000001';

  @override
  void initState() {
    merchantId = Provider.of<AuthManager>(context, listen: false).merchantId ?? '';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter chart'),
      ),
      body: Column(
        children: [
          //Initialize the chart widget
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
                    dataLabelSettings: DataLabelSettings(isVisible: true)),
              ]),
          // SfCartesianChart(
          //   primaryXAxis: CategoryAxis(),
          //   // Chart title
          //   title: ChartTitle(text: 'Half yearly sales analysis'),
          //   // Enable legend
          //   legend: Legend(isVisible: true),
          //   // Enable tooltip
          //   tooltipBehavior: TooltipBehavior(enable: true),
          //   series: <ChartSeries<_SalesData, String>>[
          //     LineSeries<_SalesData, String>(
          //         dataSource: data,
          //         xValueMapper: (_SalesData sales, _) => sales.year,
          //         yValueMapper: (_SalesData sales, _) => sales.sales,
          //         name: 'Sales',
          //         // Enable data label
          //         dataLabelSettings: DataLabelSettings(isVisible: true))
          //   ],
          // ),
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     //Initialize the spark charts widget
          //     child: SfSparkLineChart.custom(
          //       //Enable the trackball
          //       trackball: SparkChartTrackball(
          //           activationMode: SparkChartActivationMode.tap),
          //       //Enable marker
          //       marker: SparkChartMarker(
          //           displayMode: SparkChartMarkerDisplayMode.all),
          //       //Enable data label
          //       labelDisplayMode: SparkChartLabelDisplayMode.all,
          //       xValueMapper: (int index) => data[index].year,
          //       yValueMapper: (int index) => data[index].sales,
          //       dataCount: 5,
          //     ),
          //   ),
          // )
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
  "merchant_id":"100001",
  "cashback_type":"sum",// "count"
  "data":[
    {"sum_min":0,
      "sum_max":50000,
      "cashback":1.0
    },
    {"sum_min":50001,
      "sum_max":100000,
      "cashback":1.5
    },
    {"sum_min":100001,
      "sum_max":500000000000,
      "cashback":2.0
    }
  ]
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
      "cashback_percent": {
        "bank": 1,
        "payment_system": 0.5,
        "merchant": 0.5
      }
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
