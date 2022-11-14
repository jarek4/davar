import 'package:flutter/material.dart';

class RotatableSection extends StatefulWidget {
  const RotatableSection(
      {Key? key,
      required this.child,
      this.rotated = false,
      this.initialSpin = 0,
      this.endingSpin = 0.5})
      : super(key: key);

  final Widget child;
  final bool rotated;
  final double initialSpin;
  final double endingSpin;

  @override
  State<RotatableSection> createState() => _RotatableSectionState();
}

class _RotatableSectionState extends State<RotatableSection> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runCheck();
  }

  final double _oneSpin = 6.283184;

  ///Setting up the animation
  void prepareAnimations() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: _oneSpin * widget.initialSpin,
      upperBound: _oneSpin * widget.endingSpin,
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    );
  }

  void _runCheck() {
    if (widget.rotated) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  @override
  void didUpdateWidget(RotatableSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runCheck();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: widget.child,
      builder: (BuildContext context, Widget? widget) {
        return Transform.rotate(
          angle: animationController.value,
          child: widget,
        );
      },
    );
  }
}
