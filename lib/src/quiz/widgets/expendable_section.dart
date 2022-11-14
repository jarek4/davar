import 'package:flutter/material.dart';

class ExpandableSection extends StatefulWidget {
  const ExpandableSection({this.expand = false, required this.child, Key? key}) : super(key: key);
  final Widget child;
  final bool expand;

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> sizeAnimation;
  late Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    sizeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.fastOutSlowIn,
    );
    opacityAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.slowMiddle,
    );
  }

  void _runExpandCheck() {
    if (widget.expand) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandableSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: opacityAnimation,
        child: SizeTransition(axisAlignment: 1.0, sizeFactor: sizeAnimation, child: widget.child));
  }
}
