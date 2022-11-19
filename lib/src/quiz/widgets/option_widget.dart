import 'package:davar/src/quiz/models/models.dart';
import 'package:flutter/material.dart';

class OptionWidget extends StatefulWidget {
  const OptionWidget({
    Key? key,
    required this.option,
    required this.onTapedOption,
  }) : super(key: key);

  final Option option;
  final ValueChanged<Option> onTapedOption;
  @override
  State<OptionWidget> createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget> {
  // lock after it is tapped, to prevent multiple calling onTapedOption function
 bool _isOptionLocked = false;

 void _handleTap() {
   if(_isOptionLocked) return;
   setState(() {
     _isOptionLocked = true;
   });
   widget.onTapedOption(widget.option);
 }
  @override
  Widget build(BuildContext context) {
    return  _layoutBuilderWrapper(GestureDetector(
      // onTap: () => widget.onTapedOption(widget.option), // lock the question and set selected option
      onTap: () => _handleTap(),
      child: Container(
        height: 58,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 1.5, color: _getColor()),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(widget.option.text,)),
            _getIcon(),
          ],
        ),
      ),
    ));
  }

  LayoutBuilder _layoutBuilderWrapper(Widget child) {
    return LayoutBuilder(builder: (context, constraint) {
      final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
      final double maxWidth = constraint.maxWidth;
      final double landscapeMaxW = (maxWidth * 3) / 4;
      return SizedBox(width: isPortrait ? maxWidth - 40 : landscapeMaxW, child: child);
    });
  }

  Color _getColor() {
    if (widget.option.isSelected) {
      return widget.option.isCorrect ? Colors.green : Colors.red;
    }
    // return Colors.grey;
    return widget.option.isCorrect ? Colors.green : Colors.red;
  }

  Widget _getIcon() {
    const Icon ok = Icon(Icons.check_circle, color: Colors.green);
    const Icon bad = Icon(Icons.cancel_outlined, color: Colors.red);
    if (widget.option.isSelected) {
      return widget.option.isCorrect ? ok : bad;
    }
    return const SizedBox.shrink();
    // return option.isCorrect ? ok : bad;
  }
}
