import 'package:flutter/material.dart';
import 'package:sliding_top_panel/src/panel.dart';
import 'package:sliding_top_panel/src/sliding_panel_controller.dart';

class SlidingTopPanel extends StatefulWidget {
  /// The Widget that lies underneath the sliding panel.
  final Widget body;

  /// Optional, will be displayed above the [panel]
  final Widget? header;

  /// Background [Color] when the panel is displayed.
  final Color? backdropColor;

  /// If different from null, it will allow to
  /// close the panel by clicking on the [body].
  final bool? backdropEnabledToClose;

  /// The widget that is displayed when the [panel] is displayed.
  final WidgetBuilder panel;

  /// Opacity applied to the [backdropColor].
  final double? backdropOpacity;

  /// The [Color] of the [body].
  final Color? backgroundColor;

  /// The [Color] of the [panel].
  final Color? backgroundColorPanel;

  /// If not null, it can be used to access [panel] methods.
  final SlidingPanelTopController controller;

  /// If not null, will apply [Decoration] to the [panel].
  final BoxDecoration? decorationPanel;

  /// If true, the touch action will be enabled on the [header].
  final bool? onTapHeaderEnabled;

  /// Maximum [panel] height.
  final double maxHeight;

  SlidingTopPanel({
    Key? key,
    required this.body,
    required this.panel,
    required this.controller,
    this.header,
    this.maxHeight = 0,
    this.decorationPanel,
    this.backgroundColorPanel,
    this.backdropOpacity = 0.7,
    this.onTapHeaderEnabled = true,
    this.backdropEnabledToClose = true,
    this.backdropColor = Colors.black,
    this.backgroundColor = Colors.white,
  })  : assert(0 <= backdropOpacity! && backdropOpacity <= 1.0),
        assert(!maxHeight.isNegative),
        assert(
          backgroundColorPanel == null || decorationPanel == null,
          'Cannot provide both a backgroundColorPanel and a decoration\n'
          'To provide both, use "decoration: BoxDecoration(color: color)".',
        ),
        super(key: key);

  @override
  State<SlidingTopPanel> createState() => _SlidingTopPanelState();
}

class _SlidingTopPanelState extends State<SlidingTopPanel> {
  final GlobalKey _headerKey = GlobalKey();
  final ValueNotifier<double> _marginTopBody = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_getMarginBody);
  }

  @override
  void didUpdateWidget(covariant SlidingTopPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.header.hashCode != oldWidget.header.hashCode) {
      WidgetsBinding.instance.addPostFrameCallback(_getMarginBody);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ValueListenableBuilder<double>(
          valueListenable: _marginTopBody,
          builder: (BuildContext context, double marginTop, Widget? child) {
            return AnimatedContainer(
              duration: kThemeAnimationDuration,
              color: widget.backgroundColor,
              margin: EdgeInsets.only(top: marginTop),
              child: child,
            );
          },
          child: widget.body,
        ),
        Column(
          children: [
            if (widget.header != null) _buildHeader(),
            Panel(
              maxHeight: widget.maxHeight,
              controller: widget.controller,
              decoration: widget.decorationPanel,
              backdropColor: widget.backdropColor!,
              backdropOpacity: widget.backdropOpacity!,
              backgroundColorPanel: widget.backgroundColorPanel,
              backdropEnabledToClose: widget.backdropEnabledToClose!,
              child: widget.panel(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader() => GestureDetector(
        key: _headerKey,
        onTap: widget.onTapHeaderEnabled! ? widget.controller.toggle : null,
        child: widget.header,
      );

  void _getMarginBody(Duration _) {
    if (_headerKey.currentContext != null) {
      final RenderBox renderBoxHeader =
          _headerKey.currentContext!.findRenderObject() as RenderBox;

      if (_marginTopBody.value != renderBoxHeader.size.height) {
        _marginTopBody.value = renderBoxHeader.size.height;
      }
    }
  }
}
