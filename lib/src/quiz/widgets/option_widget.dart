import 'package:davar/src/quiz/models/models.dart';
import 'package:flutter/material.dart';

// every single OptionWidget key have to be different! If previews question contains option with the same key
// and this option was tapped, in new questions this option will be locked at start!
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
    if (_isOptionLocked) return;
    setState(() {
      _isOptionLocked = true;
    });
    widget.onTapedOption(widget.option);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(), // lock the question and set selected option
      child: Container(
        height: 58,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 1.5, color: _getColor()),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(
            child: Center(child: Text(widget.option.text, textAlign: TextAlign.center)),
          ),
          _getIcon(),
        ]),
      ),
    );
  }

  Color _getColor() {
    if (widget.option.isSelected) {
      return widget.option.isCorrect ? Colors.green : Colors.red;
    }
    return Colors.white;
  }

  Widget _getIcon() {
    const Icon correct = Icon(Icons.check_circle, color: Colors.green);
    const Icon bad = Icon(Icons.cancel_outlined, color: Colors.red);
    if (widget.option.isSelected) {
      return widget.option.isCorrect ? correct : bad;
    }
    return const SizedBox(width: 10.0);
  }
}
