import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:davar/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  String _edit = 'edit';
  String _category = 'Category';
  String _clue = 'clue';
  String _noClue = 'clue not added';
  String _created = 'Created at';
  String _points = 'points';
  String _reset = 'reset';
  String _w = 'word';
  String _s = 'sentence';
  String _trans = 'translation';
  String _more = 'See more';

  @override
  void initState() {
    super.initState();
    ctr = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _edit = AppLocalizations.of(context)?.edit ?? 'EDIT';
    _category = utils.capitalize(AppLocalizations.of(context)?.edit ?? 'Category');
    _created = utils.capitalize(AppLocalizations.of(context)?.edit ?? 'Created at');
    _clue = AppLocalizations.of(context)?.clue ?? 'clue';
    _noClue = AppLocalizations.of(context)?.clueNotAdded ?? 'clue not added';
    _points = AppLocalizations.of(context)?.points ?? 'points';
    _reset = utils.capitalize(AppLocalizations.of(context)?.reset ?? 'reset');
    _w = utils.capitalize(AppLocalizations.of(context)?.word ?? 'Word');
    _s = utils.capitalize(AppLocalizations.of(context)?.sentence ?? 'Sentence');
    _trans = AppLocalizations.of(context)?.addTranslation ?? 'translation';
    _more = utils.capitalize(AppLocalizations.of(context)?.seeMore ?? 'See more');
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
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                      child: SizedBox(height: 40.0, child: Image.asset(AssetsPath.davarLogo))),
                  buildHead(context),
                  const SizedBox(height: 10),
                  _buildCatchwordField(),
                  _buildUserTranslationField(),
                  const SizedBox(height: 10),
                  _buildMoreSection(),
                  const SizedBox(height: 4),
                  _buildId(widget.word.id.toString()),
                  const SizedBox(height: 6)
                ]),
              ),
            ),
          );
        });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        leading: BackButton(
            // go back without saving
            onPressed: () => Navigator.pop(context, null)),
        actions: [
          // save changes
          Consumer<EditWordProvider>(builder: (BuildContext context, EditWordProvider wep, _) {
            final bool isLoading = wep.status == EditWordProviderStatus.loading;
            final bool isError = wep.status == EditWordProviderStatus.loading;
            if (isError) {
              final String er = '${AppLocalizations.of(context)?.error.toUpperCase() ?? 'ERROR'}!';
              return Text(er);
            }
            return TextButton(
                onPressed: isLoading ? null : () => _onSave(wep),
                child: _buildSaveBtnChild(isLoading));
          }),
        ]);
  }

  Widget _buildSaveBtnChild(bool isWaiting) {
    final String save = '${utils.capitalize(AppLocalizations.of(context)?.save ?? 'Save')}!';
    final String wait = '${AppLocalizations.of(context)?.wait ?? 'Waiting'}...';
    if (!isWaiting) return Text(save, style: const TextStyle(color: Colors.white));
    return Column(children: [
      Text(wait, style: const TextStyle(color: Colors.grey)),
      const SizedBox(height: 3, width: 20, child: LinearProgressIndicator(color: Colors.white))
    ]);
  }

  Future<void> _onSave(EditWordProvider wep) async {
    await wep.onSave().then((Word res) => Navigator.pop(context, res),
        onError: (e) => Navigator.pop(context, null));
  }

  Stack buildHead(BuildContext context) {
    final String save = AppLocalizations.of(context)?.saveChanges ?? 'Save your changes';
    return Stack(alignment: AlignmentDirectional.topCenter, children: [
      _buildTitle(),
      Positioned(
        bottom: 2,
        child: Consumer<EditWordProvider>(builder: (BuildContext context, EditWordProvider wep, _) {
          final bool isChanged = wep.wasItemChanged;
          return isChanged
              ? Text(
                  save,
                  style: const TextStyle(color: Colors.red),
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
        child: Text(
          _edit.toUpperCase(),
          style: const TextStyle(
              color: Color(0xff0E9447),
              letterSpacing: 1.4,
              fontWeight: FontWeight.w800,
              fontSize: 22),
        ),
      ),
    );
  }

  Widget _buildMenuBtn(BuildContext ctx) {
    final String remove = AppLocalizations.of(context)?.remove ?? 'Remove';
    final String favAdd = AppLocalizations.of(context)?.favorite ?? 'Add to Favorites'; // favorite!
    final String close = utils.capitalize(AppLocalizations.of(context)?.saveChanges ?? 'Close');
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
                Text(isFav ? remove : favAdd)
              ])),
          PopupMenuItem(
              onTap: () => Navigator.pop<Word>(ctx, widget.word),
              child: Row(children: [
                const Icon(Icons.cancel_outlined),
                const SizedBox(width: 7),
                Text(close)
              ])),
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
            final String itemType = isSentence ? _s : _w;
            return OverflowBar(alignment: MainAxisAlignment.spaceBetween, children: [
              Text('$itemType:', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text(catchword, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
              TextButton(
                  onPressed: () {
                    editField(
                        context: context,
                        description: itemType.toLowerCase(),
                        value: catchword,
                        handle: wep.onEditCatchword);
                  },
                  child: Text(
                    utils.capitalize(_edit),
                    style: const TextStyle(color: Color(0xff0E9447)),
                  ))
            ]);
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
            return OverflowBar(alignment: MainAxisAlignment.spaceBetween, children: [
              Text('${utils.capitalize(_trans)}: ',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text(userTranslation,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
              TextButton(
                  onPressed: () {
                    editField(
                        context: context,
                        description: _trans,
                        value: userTranslation,
                        handle: wep.onEditUserTranslation);
                  },
                  child: Text(
                    utils.capitalize(_edit),
                    style: const TextStyle(color: Color(0xff0E9447)),
                  ))
            ]);
          },
        ));
  }

  ExpansionTile _buildMoreSection() {
    final String created = widget.word.createdAt ?? '---';
    return ExpansionTile(
        title: Text(_more, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
        children: <Widget>[
          _moreSectionCategory(),
          _moreSectionClue(),
          _moreSectionPoints(),
          Text('$_created:  ${created.length > 10 ? created.substring(0, 10) : created}',
              textAlign: TextAlign.left, overflow: TextOverflow.ellipsis)
        ]);
  }

  Container _moreSectionCategory() {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 10.0),
      alignment: Alignment.topLeft,
      child: Consumer<EditWordProvider>(
        builder: (BuildContext context, EditWordProvider wep, category) {
          category =
              Text(_category, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
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
        Widget text = Text(utils.capitalize(_clue),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
        final String? clue = wep.edited.clue;
        final bool isClueEmpty = clue == null || clue.isEmpty;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            text,
            TextButton(
                onPressed: () {
                  editField(
                    context: context,
                    description: _clue,
                    value: wep.edited.clue,
                    handle: wep.onEditClue,
                  );
                },
                child: Text(
                  utils.capitalize(_edit),
                  style: const TextStyle(color: Color(0xff0E9447)),
                )),
          ]),
          Text(
            isClueEmpty ? _noClue : clue,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            textAlign: TextAlign.justify,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          )
        ]);
      }),
    );
  }

  Container _moreSectionPoints() {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 10.0),
      alignment: Alignment.topLeft,
      child: Consumer<EditWordProvider>(
          builder: (BuildContext context, EditWordProvider wep, bthTitle) {
        Widget bthTitle = Text(_reset, style: const TextStyle(color: Color(0xff0E9447)));
        return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${utils.capitalize(_points)}: ',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
