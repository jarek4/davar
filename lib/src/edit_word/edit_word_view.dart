import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:davar/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_word.dart';

/// receives the Word item to edition. Then through Navigator.pop returns edited item  -
/// only when changes are saved! Otherwise returns the received item or null!
class EditWordView extends StatefulWidget {
  const EditWordView(this.word, {Key? key}) : super(key: key);

  static const routeName = '/edit';
  final Word word;

  @override
  State<EditWordView> createState() => _EditWordViewState();
}

class _EditWordViewState extends State<EditWordView> {
  late ScrollController ctr;

  @override
  void initState() {
    super.initState();
    ctr = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditWordProvider>(
        create: (context) => EditWordProvider(widget.word),
        builder: (context, _) {
          return Scaffold(
            // resizeToAvoidBottomInset: true, // for bottomSheet above keyboard ?
            appBar: _buildAppBar(context),
            body: SingleChildScrollView(
              controller: ctr,
              padding: const EdgeInsets.all(5.0),
              child: Card(
                color: Colors.grey[300],
                elevation: 40,
                shadowColor: Colors.grey[700],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                margin: const EdgeInsets.fromLTRB(30, 70, 30, 5),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                      child: SizedBox(height: 40.0, child: Image.asset(AssetsPath.davarLogo)),
                    ),
                    buildHead(context),
                    const SizedBox(height: 10),
                    _buildCatchwordField(),
                    _buildUserTranslationField(),
                    const SizedBox(height: 10),
                    _buildMoreSection(),
                    const SizedBox(height: 4),
                    _buildId(widget.word.id.toString()),
                    const SizedBox(height: 6)
                  ],
                ),
              ),
            ),
          );
        });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: BackButton(
          // go back without saving
          onPressed: () => Navigator.pop<int>(context, null)),
      actions: [
        // save changes
        Consumer<EditWordProvider>(builder: (BuildContext context, EditWordProvider wep, _) {
          final bool isLoading = wep.status == EditWordProviderStatus.loading;
          return TextButton(
              onPressed: isLoading ? null : () => _onSave(wep),
              child: _buildSaveBtnChild(isLoading));
        }),
      ],
    );
  }

  Widget _buildSaveBtnChild(bool isWaiting) {
    if (!isWaiting) return const Text('Save', style: TextStyle(color: Colors.white));
    return Column(children: const [
      Text('Waiting...', style: TextStyle(color: Colors.grey)),
      SizedBox(height: 3, width: 20, child: LinearProgressIndicator(color: Colors.white))
    ]);
  }

  Future<void> _onSave(EditWordProvider wep) async {
    await wep.onSave().then((Word res) => Navigator.pop(context, res),
        onError: (e) => Navigator.pop(context, null));
  }

  Stack buildHead(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.topCenter, children: [
      _buildTitle(),
      Positioned(
        bottom: 2,
        child: Consumer<EditWordProvider>(builder: (BuildContext context, EditWordProvider wep, _) {
          final bool isChanged = wep.hasChanged;
          return isChanged
              ? const Text(
                  'Save your changes',
                  style: TextStyle(color: Colors.red),
                )
              : const SizedBox();
        }),
      ),
      Positioned(right: 3, top: 3, child: _buildMenuBtn(context)),
    ]);
  }

  Container _buildTitle() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 80.0,
      child: Align(
        alignment: Alignment.center,
        child: Text('edit'.toUpperCase(),
            style: const TextStyle(
                color: Color(0xff0E9447),
                letterSpacing: 1.4,
                fontWeight: FontWeight.w800,
                fontSize: 22)),
      ),
    );
  }

  Widget _buildMenuBtn(BuildContext ctx) {
    return PopupMenuButton(
      icon: const Icon(Icons.menu_outlined),
      itemBuilder: (context) {
        final bool isFav = context.read<EditWordProvider>().edited.isFavorite == 1;
        return [
          PopupMenuItem(
            onTap: () => context.read<EditWordProvider>().reversIsFavorite(),
            child: Row(children: [
              Icon(isFav ? Icons.favorite : Icons.favorite_outline),
              const SizedBox(width: 7),
              Text(isFav ? 'Remove' : 'Add to Favorites')
            ]),
          ),
          PopupMenuItem(
            onTap: () => Navigator.pop<Word>(ctx, widget.word),
            child: Row(
                children: const [Icon(Icons.cancel_outlined), SizedBox(width: 7), Text('Close')]),
          ),
        ];
      },
    );
  }

  Container _buildCatchwordField() {
    return Container(
        margin: const EdgeInsets.only(left: 20.0, right: 10.0),
        alignment: Alignment.topLeft,
        child: Consumer<EditWordProvider>(
          builder: (BuildContext context, EditWordProvider wep, _) {
            if (wep.editWordProviderError.isNotEmpty) {
              utils.showSnackBarInfo(context, msg: wep.editWordProviderError);
            }
            final bool isSentence = wep.edited.isSentence == 1;
            final String catchword = wep.edited.catchword;
            final String title = isSentence ? 'Sentence' : 'Word';
            return OverflowBar(
              alignment: MainAxisAlignment.spaceBetween,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$title :', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(catchword,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                TextButton(
                    onPressed: () {
                      editField(
                          context: context,
                          description: title.toLowerCase(),
                          value: catchword,
                          handle: wep.onEditCatchword);
                    },
                    child: const Text(
                      'Edit',
                      style: TextStyle(color: Color(0xff0E9447)),
                    ))
              ],
            );
          },
        ));
  }

  Container _buildUserTranslationField() {
    return Container(
        margin: const EdgeInsets.only(left: 20.0, right: 10.0),
        alignment: Alignment.topLeft,
        child: Consumer<EditWordProvider>(
          builder: (BuildContext context, EditWordProvider wep, _) {
            final String userTranslation = wep.edited.userTranslation;
            return OverflowBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Translation: ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(userTranslation,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                TextButton(
                    onPressed: () {
                      editField(
                          context: context,
                          description: 'translation',
                          value: userTranslation,
                          handle: wep.onEditUserTranslation);
                    },
                    child: const Text(
                      'Edit',
                      style: TextStyle(color: Color(0xff0E9447)),
                    ))
              ],
            );
          },
        ));
  }

  ExpansionTile _buildMoreSection() {
    final String created = widget.word.createdAt ?? '---';
    return ExpansionTile(
      title: const Text('See more', style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
      // subtitle: Text('Trailing expansion arrow icon'),
      children: <Widget>[
        _moreSectionCategory(),
        _moreSectionClue(),
        _moreSectionPoints(),
        Text(
          'Created at:  ${created.length > 10 ? created.substring(0, 10) : created}',
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }

  Container _moreSectionCategory() {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 10.0),
      alignment: Alignment.topLeft,
      child: Consumer<EditWordProvider>(
        builder: (BuildContext context, EditWordProvider wep, category) {
          const category =
              Text('Category', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
          return OverflowBar(alignment: MainAxisAlignment.spaceBetween, children: [
            category,
            Text(wep.edited.category,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false),
            _buildEditCategoryPopupList()
          ]);
        },
      ),
    );
  }

  Widget _buildEditCategoryPopupList() {
    return Consumer<CategoriesProvider>(builder: (BuildContext context, CategoriesProvider cp, _) {
      List<WordCategory> categories = cp.categories;
      return PopupMenuButton<WordCategory>(
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xff0E9447)),
        iconSize: 26.0,
        itemBuilder: (context) {
          return categories
              .map((category) => PopupMenuItem<WordCategory>(
                    onTap: () => context.read<EditWordProvider>().onEditCategory(category),
                    child: Text(category.name),
                  ))
              .toList();
        },
      );
    });
  }

  Container _moreSectionClue() {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 10.0),
      alignment: Alignment.topLeft,
      child:
          Consumer<EditWordProvider>(builder: (BuildContext context, EditWordProvider wep, text) {
        const Widget text =
            Text('Clue ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
        final String? clue = wep.edited.clue;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text,
                TextButton(
                    onPressed: () {
                      editField(
                        context: context,
                        description: 'clue',
                        value: wep.edited.clue,
                        handle: wep.onEditClue,
                      );
                    },
                    child: const Text(
                      'Edit',
                      style: TextStyle(color: Color(0xff0E9447)),
                    )),
              ],
            ),
            Text(
              clue ?? 'no clue was added',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              textAlign: TextAlign.justify,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ],
        );
      }),
    );
  }

  Container _moreSectionPoints() {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 10.0),
      alignment: Alignment.topLeft,
      child: Consumer<EditWordProvider>(
          builder: (BuildContext context, EditWordProvider wep, bthTitle) {
        const Widget bthTitle = Text('Reset', style: TextStyle(color: Color(0xff0E9447)));
        return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Points: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          Text(wep.edited.points.toString(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
          TextButton(onPressed: () => wep.onResetPoints(), child: bthTitle)
        ]);
      }),
    );
  }

  Container _buildId(String id) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      alignment: Alignment.topLeft,
      child: Text('ID: ${widget.word.id}',
          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.normal)),
    );
  }

  // EditWordDialogWidget onPressed: () { widget.handle(itemId, _ctr.value.text);}
  void editField(
      {required BuildContext context,
      String? description,
      String? value,
      required Function handle}) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          // AnimatedPadding, padding MediaQuery.of(context).viewInsets.bottom and
          // isScrollControlled: true - are important to lift up when keyboard is shown!
          return AnimatedPadding(
              duration: const Duration(milliseconds: 50),
              curve: Curves.bounceIn,
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: EditWordDialogWidget(
                itemId: widget.word.id,
                description: description,
                value: value,
                handle: handle,
              ));
        });
  }
}
