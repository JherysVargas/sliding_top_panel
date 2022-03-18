import 'package:flutter/material.dart';

class Panel extends StatefulWidget {
  final Widget child;
  final Color backdropColor;
  final double backdropOpacity;
  final Color backgroundColorPanel;
  final bool backdropEnabledToClose;
  final SlidingPanelTopController? controller;

  const Panel({
    Key? key,
    required this.child,
    required this.backdropColor,
    required this.backdropOpacity,
    required this.backdropEnabledToClose,
    this.controller,
    this.backgroundColorPanel = Colors.white,
  }) : super(key: key);

  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<double>? _heightContentAnimation;
  final GlobalKey _expansionContainerListKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.controller?._addState(this);
    _initAnimation();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    WidgetsBinding.instance?.addPostFrameCallback(_calculateHeightAvailable);
  }

  void _calculateHeightAvailable(Duration _) {
    _heightContentAnimation = Tween<double>(
      begin: 0,
      end: _getHeightHeaderRenderProducts(),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  double _getHeightHeaderRenderProducts() {
    final RenderBox renderBoxListSubCategories =
        _expansionContainerListKey.currentContext!.findRenderObject()
            as RenderBox;
    return renderBoxListSubCategories.size.height / 2;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return Expanded(
          child: Stack(
            children: [
              IgnorePointer(
                ignoring: !_animationController.isCompleted,
                child: InkWell(
                  onTap: widget.backdropEnabledToClose ? close : null,
                  child: Container(
                    key: _expansionContainerListKey,
                    color: Color.lerp(
                      Colors.transparent,
                      widget.backdropColor.withOpacity(widget.backdropOpacity),
                      _animationController.value,
                    ),
                  ),
                ),
              ),
              Container(
                color: widget.backgroundColorPanel,
                width: MediaQuery.of(context).size.width,
                height: _heightContentAnimation?.value ?? 0,
                child: child,
              ),
            ],
          ),
        );
      },
      child: widget.child,
    );
  }

  void open() {
    _animationController.forward();
  }

  void close() {
    _animationController.reverse();
  }

  void toggle() {
    if (_animationController.isCompleted) {
      close();
    } else {
      open();
    }
  }
}

class SlidingPanelTopController {
  late _PanelState _panelState;

  void _addState(_PanelState panelState) {
    _panelState = panelState;
  }

  void open() {
    _panelState.open();
  }

  void close() {
    _panelState.close();
  }

  void toggle() {
    _panelState.toggle();
  }
}
