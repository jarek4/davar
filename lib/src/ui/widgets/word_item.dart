import 'package:davar/src/data/models/models.dart';
import 'package:flutter/material.dart';

class WordItem extends StatelessWidget {
  const WordItem(
      {Key? key, required this.item, this.favHandle, this.deleteHandle, this.onTapHandle})
      : super(key: key);

  final Word item;
  final VoidCallback? favHandle;
  final VoidCallback? deleteHandle;
  final VoidCallback? onTapHandle;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: key,
      color: Colors.grey.shade300,
      elevation: 2,
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
            tag: item,
            child: _buildHeroChild(),
          ),
          title: Text(item.catchword),
          subtitle: Text(item.userTranslation),
          trailing: _buildTrailingIcons(context)),
    );
  }

  ClipRRect _buildHeroChild() {
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: Colors.white,
        height: 35,
        width: 35,
        child: Align(
          alignment: Alignment.center,
          child: Text(item.userTranslation[0].toUpperCase(),
              style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                  decoration: TextDecoration.underline)),
        ),
      ),
    );
  }

  Padding _buildTrailingIcons(BuildContext context) {
    final bool isFavorite = item.isFavorite == 1 ? true : false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              flex: 2,
              child: IconButton(
                  onPressed: () {
                    if (favHandle != null) {
                      favHandle!();
                    }
                  },
                  icon: isFavorite
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_border_outlined))),
          Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () => _onDeleteDialog(context, item.userTranslation),
                  icon: const Icon(Icons.delete_forever),
                  iconSize: 17))
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
