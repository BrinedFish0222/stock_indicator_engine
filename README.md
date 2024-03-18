# stock_indicator_engine

## 介绍

一个麦语法股票指标引擎，它只是对K线数据和输入的麦语法公式计算出对应的结果。

如果你需要画K线图，可以参考我另一个开源项目：[GitHub - BrinedFish0222/flutter_kline: 股票K线图](https://github.com/BrinedFish0222/flutter_kline)

如果该指标引擎项目思路对你有帮助，希望能给个 :star: :star: :star:



## 注意事项

1. 

只支持麦语法，依赖第三方包：`math_expressions`。

**它只是提供了一种思路**，作者只是一个菜鸡，需要解决吃饭问题，只能尽可能有空闲时间增强引擎的健壮性，无法实现所有的麦语法函数底层计算逻辑。



## 快速入门

参考测试文件：`test\main_test.dart`

使用示例：

```dart
    String formula = """
      DIF:CLOSE-TESTONE(SHORT,2)-1;
      DEA:TESTONE(DIF,LONG),COLORSTICK;
      MACD:=TESTONE(TESTONE(DEA,MID),DIF);
  """;

    RunFormulaResult result = StockIndicatorEngine(
      chart: chart,
      formula: formula,
      inputParameters: parameters,
    ).run();
```



## 扩展函数库

步骤：

1. 新建函数类，例如叫`FunctionClose`，继承`StockIndicatorFunction`，实现所有抽象方法。
2. 将`FunctionClose`注册进入函数库中。

---

新建CLOSE函数类：

```
class FunctionClose extends StockIndicatorFunction {

  @override
  String get code => 'CLOSE';

  @override
  List<double?> compute({
    required KChart chart,
    required List<List<double?>> params,
  }) {
    if (chart.dataList.isEmpty) {
      return [];
    }

    return chart.dataList.map((e) => e?.close).toList();
  }

  @override
  StockIndicatorFunctionType get type => StockIndicatorFunctionType.compute;
}
```

- code：函数名
- compute：计算实现逻辑，参数chart是K线图数据，参数params是调用函数传入的参数。
- type：该函数类型，CLOSE属于需要计算的函数。



将CLOSE函数注册进入函数库中：

```dart
StockIndicatorFunctionLibrary().register([FunctionClose()]);
```










