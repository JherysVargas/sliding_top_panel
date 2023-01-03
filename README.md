# sliding_top_panel
[![pub package](https://img.shields.io/pub/v/sliding_top_panel.svg)](https://pub.dev/packages/sliding_top_panel)
[![GitHub Stars](https://img.shields.io/github/stars/JherysVargas/sliding_top_panel.svg?logo=github)](https://pub.dev/packages/sliding_top_panel)
[![Platform](https://img.shields.io/badge/platform-android%20|%20ios-green.svg)](https://img.shields.io/badge/platform-Android%20%7C%20iOS-green.svg)

A flutter widget that allows you to display a sliding top panel, this widget works on both Android & iOS.

## Installing
Add the following to your `pubspec.yaml` file:
```yaml
dependencies:
  sliding_top_panel: ^0.0.6
```

<br>

## Demo
<img width="250px" alt="Example" src="https://raw.githubusercontent.com/JherysVargas/sliding_top_panel/main/screenshots/example_ios.gif"/>

<br>

## How to use

```dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ValueNotifier<bool> _isPanelVisible = ValueNotifier(false);
  final SlidingPanelTopController _controller = SlidingPanelTopController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(listenerController);
  }

  void listenerController() {
    _isPanelVisible.value = _controller.isPanelOpen;
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
          color: Colors.white,
          child: ListTile(
            title: const Text("Header Panel"),
            trailing: _buildArrowIconHeader(),
            onTap: _controller.toggle,
          ),
        ),
        panel: (_) => _buildListPanel(),
        body: _buildGridList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _controller.toggle,
        tooltip: 'Increment',
        icon: const Icon(Icons.toggle_off),
        label: _buildTextFloatingButton(),
      ),
    );
  }

  Widget _buildArrowIconHeader() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isPanelVisible,
      builder: (BuildContext _, bool isVisible, Widget? __) {
        return Icon(
          isVisible
              ? Icons.keyboard_arrow_up_rounded
              : Icons.keyboard_arrow_down_rounded,
          size: 20,
          color: Colors.black45,
        );
      },
    );
  }

  Widget _buildTextFloatingButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isPanelVisible,
      builder: (BuildContext _, bool isVisible, Widget? __) {
        return Text(isVisible ? 'Close Panel' : 'Open Panel');
      },
    );
  }

  Widget _buildGridList() => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext _, int __) => Container(
          color: _getColor(),
        ),
      );

  Widget _buildListPanel() => ListView.builder(
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
```