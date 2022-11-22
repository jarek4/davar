import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/theme/theme.dart' as theme;
import 'package:flutter/material.dart';

class WordItem extends StatelessWidget {
  const WordItem(
      {Key? key, required this.item, this.favHandle, this.deleteHandle, this.onTapHandle})
      : super(key: key);

  final Word item;
  final VoidCallback? favHandle;
  final VoidCallback? deleteHandle;
  final VoidCallback? onTapHandle;

  static const List<Color> _sentenceColors = theme.DavarColors.sentenceColors2;
  static const List<Color> _wordColors = theme.DavarColors.wordColors2;



  @override
  Widget build(BuildContext context) {
    // final Brightness brightness = MediaQuery.of(context).platformBrightness;
    // final bool isDarkMode = brightness == Brightness.dark;
    return Card(
      key: key,
      borderOnForeground: false,
      color: Colors.grey.shade400,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 0.5),
          borderRadius: BorderRadius.circular(10)),
      child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          onTap: () {
            if (onTapHandle != null) {
              onTapHandle!();
            }
          },
          leading: Hero(
            key: Key('WordItem-hero_${item.catchword}_${item.id}'),
            tag: item,
            child: _buildHeroChild(),
          ),
          title: Text(item.catchword),
          subtitle: Text(item.userTranslation),
          trailing: _buildTrailingIcons(context)),
    );
  }

  Widget _buildHeroChild() {
    final bool isSentence = item.isSentence == 1;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: isSentence ? _sentenceColors : _wordColors),
          boxShadow: [
            BoxShadow(
                color: isSentence
                    ? _sentenceColors[0].withOpacity(0.5)
                    : _wordColors[0].withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(-2, 1)),
            BoxShadow(
                color: isSentence
                    ? _sentenceColors[1].withOpacity(0.5)
                    : _wordColors[1].withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(3, -1)),
          ]),
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.white,
          height: 35,
          width: 35,
          child: Align(
            alignment: Alignment.center,
            child: Text(item.catchword[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                  decoration: TextDecoration.underline,
                  decorationColor: isSentence ? _sentenceColors[1] : _wordColors[1],
                )),
          ),
        ),
      ),
    );
  }

  Padding _buildTrailingIcons(BuildContext context) {
    final bool isFavorite = item.isFavorite == 1 ? true : false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: IconButton(
                  iconSize: isFavorite ? 19 : 16,
                  onPressed: () {
                    if (favHandle != null) {
                      favHandle!();
                    }
                  },
                  icon: isFavorite
                      ? Icon(Icons.favorite, color: Colors.red.shade300)
                      : Icon(Icons.favorite_border_outlined, color: Colors.red.shade300))),
          Expanded(
              child: IconButton(
                  onPressed: () => _onDeleteDialog(context, item.userTranslation),
                  icon: const Icon(Icons.delete_forever),
                  iconSize: 18))
        ],
      ),
    );
  }

  _onDeleteDialog(BuildContext ctx, String word) => showDialog(
      barrierDismissible: true,
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(word)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              Text(
                'Are you sure, you want to delete this word? ',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              Text(
                'You cannot undo deleting!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.red),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (deleteHandle != null) {
                  deleteHandle!();
                }
                Navigator.of(context).pop();
              },
              child: const Text('Yes, delete', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No, cancel'),
            )
          ],
        );
      });
}
