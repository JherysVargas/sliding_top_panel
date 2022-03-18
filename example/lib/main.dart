import 'package:flutter/material.dart';
import 'package:sliding_top_panel/sliding_top_panel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  final SlidingPanelTopController _controller = SlidingPanelTopController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SlidingTopPanel(
        controller: _controller,
        panel: (context) => InkWell(
          onTap: _controller.close,
          child: const SizedBox(
            height: 300,
            child: Text(
              'Panel',
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text(
                  'You have pushed the button this many times:',
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _controller.toggle,
        tooltip: 'Increment',
        child: const Icon(Icons.toggle_off),
      ),
    );
  }
}
