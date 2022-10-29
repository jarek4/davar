import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void showSnackBarInfo(BuildContext context, {required String msg, bool isError = false}) {
  final String info = utils.trimTextIfLong(msg, maxCharacters: 100);
  SchedulerBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(!isError
        ? SnackBar(
            key: Key('${context.hashCode}_$msg'),
            content: Text(info, textAlign: TextAlign.center),
          )
        : _errorSnack(context, info));
  });
}

SnackBar _errorSnack(BuildContext context, String msg) => SnackBar(
      key: Key('${context.hashCode}_$msg'),
      backgroundColor: Colors.white10,
      content: Text(msg, textAlign: TextAlign.center, style: TextStyle(color: Colors.red.shade300)),
    );
