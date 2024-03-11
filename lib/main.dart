import 'package:flutter/material.dart';
import 'package:stock_indicator_engine/stock_indicator.dart';
import 'package:stock_indicator_engine/stock_indicator_engine.dart';
import 'package:stock_indicator_engine/utils/kline_util.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  String formula = """
DIF:EMA(CLOSE,SHORT)-EMA(CLOSE,LONG);
DEA:EMA(DIF,MID);
MACD:(DIF-DEA)*2,COLORSTICK;
  """;

  List<StockIndicatorParameter> parameters = [
    StockIndicatorParameter(name: 'SHORT', value: 12),
    StockIndicatorParameter(name: 'LONG', value: 26),
    StockIndicatorParameter(name: 'MID', value: 9),
  ];

  var stockIndicatorEngine =
      StockIndicatorEngine(formula: formula, parameters: parameters);
  var test = stockIndicatorEngine.test();
  KlineUtil.logd('测试结果：${test.toString()}');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
