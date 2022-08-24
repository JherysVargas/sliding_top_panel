import 'package:flutter/material.dart';
import 'package:sliding_top_panel/src/sliding_panel_controller.dart';

class Panel extends StatefulWidget {
  final Widget child;
  final double? maxHeight;
  final Color backdropColor;
  final double backdropOpacity;
  final BoxDecoration? decoration;
  final Color? backgroundColorPanel;
  final bool backdropEnabledToClose;
  final SlidingPanelTopController controller;

  const Panel({
    Key? key,
    required this.child,
    required this.controller,
    required this.backdropColor,
    required this.backdropOpacity,
    required this.backdropEnabledToClose,
    this.maxHeight,
    this.decoration,
    this.backgroundColorPanel,
  }) : super(key: key);

  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<double>? _heightContentAnimation;
  final GlobalKey _backDropContainer = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      value: 0,
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    WidgetsBinding.instance.addPostFrameCallback(_calculateHeightAvailable);

    widget.controller.addListener(_listenerController);
  }

  void _calculateHeightAvailable(Duration _) {
    final double maxHeight = widget.maxHeight! > 0
        ? widget.maxHeight!
        : _getHeightHeaderRenderProducts();

    _heightContentAnimation = Tween<double>(
      begin: 0,
      end: maxHeight,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  double _getHeightHeaderRenderProducts() {
    final RenderBox renderBoxListSubCategories =
        _backDropContainer.currentContext!.findRenderObject() as RenderBox;
    return renderBoxListSubCategories.size.height / 2;
  }

  void _listenerController() {
    if (widget.controller.isPanelOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void didUpdateWidget(covariant Panel oldWidget) {
    if ((oldWidget.maxHeight != widget.maxHeight)) {
      _calculateHeightAvailable(Duration.zero);
    }
    if (oldWidget.controller != widget.controller) {
      _changeInstanceController(oldWidget);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _changeInstanceController(Panel oldWidget) {
    oldWidget.controller.removeListener(_listenerController);
    widget.controller.addListener(_listenerController);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listenerController);
    widget.controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Expanded(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          return Stack(
            children: [
              IgnorePointer(
                ignoring: !_animationController.isCompleted,
                child: InkWell(
                  onTap: widget.backdropEnabledToClose
                      ? widget.controller.close
                      : null,
                  child: Container(
                    key: _backDropContainer,
                    color: Color.lerp(
                      Colors.transparent,
                      widget.backdropColor.withOpacity(widget.backdropOpacity),
                      _animationController.value,
                    ),
                  ),
                ),
              ),
              Container(
                width: size.width,
                decoration: widget.decoration,
                color: widget.backgroundColorPanel,
                height: _heightContentAnimation?.value ?? 0,
                child: child,
              ),
            ],
          );
        },
        child: widget.child,
      ),
    );
  }
}
