import 'package:flutter/material.dart';
import 'package:hack/main.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class SalesChart extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  SalesChart({Key? key}) : super(key: key);

  @override
  _SalesChartState createState() => _SalesChartState();
}

class _PieData {
  _PieData(
    this.xData,
    this.yData,
  );

  // this.text);
  final String xData;
  final num yData;
// final String text;
}

class _SalesChartState extends State<SalesChart> {
  List<_PieData> pieData = [
    // _PieData('Jan', 35, ),
    // _PieData('Feb', 28, ),
    // _PieData('Mar', 34, ),
    // _PieData('Apr', 32, ),
    // _PieData('May', 40, )
  ];

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3));
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
