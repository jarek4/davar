import 'package:flutter/material.dart';

class Slide extends StatelessWidget {
  const Slide({
    this.title = 'Welcome',
    this.subtitle,
    required this.content,
    required this.imgPath,
    this.color,
    Key? key,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final List<String> content;
  final String imgPath;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(flex: 2, child: _buildTopTextContent()),
          Expanded(flex: 2, child: _buildCenterImage()),
          Expanded(flex: 3, child: _buildBottomTextContent()),
        ]),
      ),
    );
  }

  Column _buildTopTextContent() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.blue,
              letterSpacing: 1.3,
              wordSpacing: 1.5)),
      const SizedBox(height: 7.0),
      if (subtitle != null)
        Text(
          subtitle!,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
              color: Colors.grey,
              letterSpacing: 1.3,
              wordSpacing: 1.5),
        ),
    ]);
  }

  Widget _buildCenterImage() {
    return Image.asset(imgPath, fit: BoxFit.fill, alignment: Alignment.topCenter);
  }

  Column _buildBottomTextContent() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: content
            .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(e, key: Key(e)),
                ))
            .toList());
  }
}
