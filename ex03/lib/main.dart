import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
String _text1 = '';
  String _text2 = '';

  void _handleButtonPress(String label) {
    setState(() {
      if (label == 'AC') {
        _text1 = '';
        _text2 = '';
      } else if (label == 'C') {
        if (_text1.isNotEmpty) {
          _text1 = _text1.substring(0, _text1.length - 1);
        }
      } else if (label == '=') {
        if (_text1.isNotEmpty) {
          _text2 = _evaluateExpression(_text1).toString();
        }
      } else {
        _text1 = _text1 + label;
      }
    });
  }



  double _evaluateExpression(String expression) {
    try {
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval;
    } catch (e) {
      print(e);
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var childAspectRatio = (width / 4) / 100;
    ;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        centerTitle: true, // This centers the title
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: _text1,
              ),
              obscureText: true,
              enabled: false,
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8.0),
            TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: _text2,
                ),
                obscureText: true,
                enabled: false,
                textAlign: TextAlign.right),
            //const SizedBox(height: 1.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: 18,
                itemBuilder: (context, index) {
                  if (index < 9) {
                    return TextButton(
                      child: Text('${index + 1}'),
                      onPressed: () {
                        _handleButtonPress('${index + 1}');
                        print('Button pressed: ${index + 1}');
                      },
                    );
                  } else {
                    var labels = ['0', '.', '-', '+', '=', 'AC', 'C', '*', '/'];
                    return TextButton(
                      child: Text(labels[index - 9]),
                      onPressed: () {
                        _handleButtonPress('${labels[index - 9]}');
                        print('Button pressed: ${labels[index - 9]}');
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
