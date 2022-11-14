import 'package:davar/src/quiz/models/models.dart';
import 'package:flutter/material.dart';

class OptionWidget extends StatelessWidget {
  const OptionWidget({
    Key? key,
    required this.option,
    required this.onTapedOption,
  }) : super(key: key);

  final Option option;
  final ValueChanged<Option> onTapedOption; // id

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapedOption(option), // lock the question and set selected option
      child: Container(
        height: 50,
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
            Text(option.text),
            _getIcon(),
          ],
        ),
      ),
    );
  }

  Color _getColor() {
    if (option.isSelected) {
      return option.isCorrect ? Colors.green : Colors.red;
    }
    // return Colors.grey;
    return option.isCorrect ? Colors.green : Colors.red;
  }

  Widget _getIcon() {
    const Icon ok = Icon(Icons.check_circle, color: Colors.green);
    const Icon bad = Icon(Icons.cancel_outlined, color: Colors.red);
    if (option.isSelected) {
      return option.isCorrect ? ok : bad;
    }
    return const SizedBox.shrink();
    // return option.isCorrect ? ok : bad;
  }
}
