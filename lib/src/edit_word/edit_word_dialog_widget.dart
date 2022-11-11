import 'package:flutter/material.dart';

class EditWordDialogWidget extends StatefulWidget {
  const EditWordDialogWidget({
    Key? key,
    required this.itemId,
    this.description,
    this.value,
    required this.handle,
  }) : super(key: key);
  final int itemId;
  final String? description;
  final String? value;
  final Function handle;

  @override
  State<EditWordDialogWidget> createState() => _EditWordDialogWidgetState();
}

class _EditWordDialogWidgetState extends State<EditWordDialogWidget> {
  TextEditingController _ctr = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctr = TextEditingController(text: widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 140,
      child: Center(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(flex: 1, child: Text('Edit ${widget.description}:')),
              Expanded(
                flex: 3,
                child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _ctr,
                    autofocus: true,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (v) {
                      if (v == null || v.toString() == '') {
                        return '                    Cannot be empty!';
                      }
                      return null;
                    }),
              ),
              Expanded(
                flex: 2,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                  TextButton(
                      onPressed: () {
                        if (_ctr.value.text.isNotEmpty) {
                          widget.handle(_ctr.value.text);
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('OK'))
                ]),
              )
            ]),
      ),
    );
  }
}
