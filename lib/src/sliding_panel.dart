import 'package:flutter/material.dart';
import 'package:sliding_top_panel/src/panel.dart';
import 'package:sliding_top_panel/src/sliding_panel_controller.dart';

class SlidingTopPanel extends StatelessWidget {
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
            header != null ? _header() : const SizedBox(),
            Panel(
              maxHeight: maxHeight,
              child: panel(context),
              controller: controller,
              decoration: decorationPanel,
              backdropColor: backdropColor!,
              backdropOpacity: backdropOpacity!,
              backgroundColorPanel: backgroundColorPanel,
              backdropEnabledToClose: backdropEnabledToClose!,
            ),
          ],
        ),
      ],
    );
  }

  Widget _header() => GestureDetector(
        onTap: onTapHeaderEnabled! ? controller.toggle : null,
        child: header,
      );
}
