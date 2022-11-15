import 'package:flutter/material.dart';

class NeonButton extends StatefulWidget {
  const NeonButton(
      {Key? key,
      required this.onPressed,
      required this.gradientColor1,
      required this.gradientColor2,
      this.isGlowing = true,
      this.child = const SizedBox()})
      : super(key: key);
  final Function onPressed;
  final Color gradientColor1;
  final Color gradientColor2;
  final bool isGlowing;
  final Widget child;

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> {

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        animationDuration: const Duration(milliseconds: 200),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        elevation: 0.0,
        disabledElevation: 0.0,
        onPressed: () => widget.onPressed(),
        child: AnimatedContainer(
          alignment: AlignmentDirectional.center,
          duration: const Duration(milliseconds: 200),
          height: 40,
          width: 130,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              gradient: LinearGradient(colors: [widget.gradientColor1, widget.gradientColor2]),
              boxShadow: [
                BoxShadow(
                    color: widget.gradientColor1.withOpacity(0.3),
                    spreadRadius: widget.isGlowing ? 8 : 2,
                    blurRadius: widget.isGlowing ? 32 : 12,
                    offset: const Offset(-8, 0)),
                BoxShadow(
                    color: widget.gradientColor2.withOpacity(0.3),
                    spreadRadius: widget.isGlowing ? 8 : 2,
                    blurRadius: widget.isGlowing ? 32 : 12,
                    offset: const Offset(8, 0)),
              ]),
          child: widget.child,
        ));
  }
}
