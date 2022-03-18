import 'package:flutter/material.dart';
import 'package:sliding_top_panel/src/panel.dart';

class SlidingTopPanel extends StatelessWidget {
  /// The Widget that lies underneath the sliding panel.
  final Widget body;

  /// Optional, will be displayed above the [panel]
  final Widget? header;

  /// Background [Color] when the panel is displayed.
  /// Default is [Colors.black].
  final Color? backdropColor;

  /// If different from null, it will allow to
  /// close the panel by clicking on the [body]
  final bool? backdropEnabledToClose;

  /// The widget that is displayed when the [panel] is displayed.
  final WidgetBuilder panel;

  /// Opacity applied to the [backdropColor].
  /// Default is [0.7].
  final double? backdropOpacity;

  /// The [Color] of the [body].
  /// Default is [Colors.white]
  final Color? backgroundColor;

  /// The [Color] of the [panel].
  /// Default is [Colors.white]
  final Color? backgroundColorPanel;

  /// If not null, it can be used to access [panel] methods
  final SlidingPanelTopController? controller;

  const SlidingTopPanel({
    Key? key,
    required this.body,
    required this.panel,
    this.header,
    this.controller,
    this.backdropOpacity = 0.7,
    this.backdropEnabledToClose = true,
    this.backdropColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.backgroundColorPanel = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          color: backgroundColor,
          child: body,
        ),
        Column(
          children: [
            header ?? const SizedBox(),
            Panel(
              controller: controller,
              child: panel(context),
              backdropColor: backdropColor!,
              backdropOpacity: backdropOpacity!,
              backdropEnabledToClose: backdropEnabledToClose!,
            ),
          ],
        ),
      ],
    );
  }
}
