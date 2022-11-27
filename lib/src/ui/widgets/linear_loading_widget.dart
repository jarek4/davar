import 'package:flutter/material.dart';

class LinearLoadingWidget extends StatelessWidget {
  const LinearLoadingWidget({
    Key? key,
    this.child,
    this.info,
    this.width = 45.0,
    this.isError = false,
  }) : super(key: key);
  final Widget? child;
  final String? info;
  final double width;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(children: [
          info == null ? const SizedBox() : Text(info!),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 5.0,
            width: width,
            child: LinearProgressIndicator(
              key: Key('LinearIndicator_$info-$width-isError:$isError'),
              color: isError ? Colors.red : Colors.green,
            ),
          ),
          const SizedBox(height: 3.0),
          child ?? const SizedBox(),
        ]),
      ),
    );
  }
}
