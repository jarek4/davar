import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  late String _edit, _cancel, _empty;

  @override
  void initState() {
    super.initState();
    _ctr = TextEditingController(text: widget.value);
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _edit = utils.capitalize(AppLocalizations.of(context)?.edit ?? 'Edit');
    _cancel = utils.capitalize(AppLocalizations.of(context)?.cancel ?? 'Cancel');
    _empty = AppLocalizations.of(context)?.fieldNotEmpty ?? 'Cannot be empty';
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 140,
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Expanded(flex: 1, child: Text('$_edit ${widget.description}:')),
          Expanded(
            flex: 3,
            child: TextFormField(
                textAlign: TextAlign.center,
                controller: _ctr,
                autofocus: true,
                autovalidateMode: AutovalidateMode.always,
                validator: _validateInput),
          ),
          Expanded(
            flex: 2,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(_cancel)),
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

  String? _validateInput(String? v) {
    if (v == null || v.toString() == '') {
      return '                    $_empty!';
    }
    return null;
  }
}
