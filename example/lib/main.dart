import 'dart:math' as math;
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
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Example Sliding Panel'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isPanelVisible = false;
  late final SlidingPanelTopController _controller;

  @override
  void initState() {
    _controller = SlidingPanelTopController()..addListener(listenerController);
    super.initState();
  }

  void listenerController() {
    setState(() {
      _isPanelVisible = _controller.isPanelOpen;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(listenerController);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SlidingTopPanel(
        // maxHeight: 100,
        decorationPanel: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        controller: _controller,
        header: Container(
          height: 55,
          color: Colors.white,
          child: ListTile(
            title: const Text("Header Panel"),
            trailing: Icon(
              _isPanelVisible
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: Colors.black45,
            ),
            onTap: _controller.toggle,
          ),
        ),
        panel: (_) => _listPanel(),
        body: _gridView(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _controller.toggle,
        tooltip: 'Increment',
        icon: const Icon(Icons.toggle_off),
        label: Text(_isPanelVisible ? 'Close Panel' : 'Open Panel'),
      ),
    );
  }

  Widget _gridView() => GridView.builder(
        padding: const EdgeInsets.only(top: 55),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext _, int __) => Container(
          color: _getColor(),
        ),
      );

  Widget _listPanel() => ListView.builder(
        itemCount: 20,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) => ListTile(
          title: Text("Item $index"),
          onTap: _controller.close,
        ),
      );

  Color _getColor() => Color.fromRGBO(
        math.Random().nextInt(255),
        math.Random().nextInt(255),
        math.Random().nextInt(255),
        1,
      );
}
