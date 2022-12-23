import 'package:davar/src/authentication/authentication.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/davar_ads/davar_ads.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/theme/theme.dart' as theme;
import 'package:davar/src/ui/screens/more/add_edit_word_category/add_edit_word_category.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = orientation == Orientation.landscape;
    final String name = '${utils.capitalize(AppLocalizations.of(context)?.authName ?? 'Name')}:';
    final String learn =
        '${utils.capitalize(AppLocalizations.of(context)?.authLearn ?? 'You learn')}:';
    final String confirmLogout =
        AppLocalizations.of(context)?.authLogout ?? 'Are you sure, you want to logout?';
    return Column(children: [
      Expanded(
        child: ListView(
            primary: true,
            padding: EdgeInsets.symmetric(horizontal: isLandscape ? 80 : 10),
            key: const Key('More-ProfileScreen-primaryList'),
            children: [
              OrientationBuilder(builder: (context, orientation) {
                final bool isLandscape = orientation == Orientation.landscape;
                return ListView(shrinkWrap: true, children: [
                  _buildWordCategoriesList(context, isLandscape),
                ]);
              }),
              const Divider(thickness: 1.2),
              Consumer<AuthProvider>(builder: (BuildContext context, AuthProvider ap, _) {
                return ListTile(
                  title: Text('$name ${ap.user.name}'),
                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Email: ${ap.user.email}'),
                    Text('$learn ${ap.user.learning}'),
                  ]),
                  leading: const Icon(Icons.person_outline),
                );
              }),
              const Divider(thickness: 1.2),
              ListTile(
                title: const Text('Logout'),
                leading: const Icon(Icons.logout_outlined),
                onTap: () => _showDialog(
                    context, confirmLogout, () => context.read<AuthProvider>().signOut()),
              ),
              const Divider(thickness: 1.2),
            ]),
      ),
      const Padding(
        padding: EdgeInsets.only(bottom: 2.0),
        child: DavarAdBanner(key: Key('More-ProfileScreen-bottom-banner-320')),
      ),
    ]);
  }

  void _showDialog(BuildContext context, String title, VoidCallback onConfirmation) {
    final String cancel = utils.capitalize(AppLocalizations.of(context)?.cancel ?? 'Cancel');
    void okBtnHandle() {
      onConfirmation();
      Navigator.of(context).pop();
    }

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title, textAlign: TextAlign.center),
              content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(cancel)),
                TextButton(onPressed: okBtnHandle, child: const Text('OK'))
              ]),
            ));
  }

  Container _buildWordCategoriesList(BuildContext context, bool isLandscape) {
    final String manage =
        AppLocalizations.of(context)?.moreManageCategories ?? 'Manage your categories';
    final String addNew = AppLocalizations.of(context)?.moreAddCategory ?? 'Add new category';
    final String wait = '${utils.capitalize(AppLocalizations.of(context)?.wait ?? 'Wait')}...';
    final String add = utils.capitalize(AppLocalizations.of(context)?.add ?? 'Add');
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.DavarColors.profileCategoriesCard[0],
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(
            width: 2.0, style: BorderStyle.solid, color: const Color.fromARGB(23, 134, 55, 3)),
      ),
      child: Column(children: [
        OverflowBar(
            spacing: 4.0,
            overflowSpacing: 3.0,
            alignment: MainAxisAlignment.center,
            overflowAlignment: OverflowBarAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(manage,
                      style: TextStyle(fontSize: isLandscape ? 20 : 16),
                      textAlign: TextAlign.center)),
            ]),
        Consumer<CategoriesProvider>(
            builder: (BuildContext context, CategoriesProvider provider, _) {
          final bool isStatusSuccess = provider.status == CategoriesProviderStatus.success;
          return TextButton(
            // style: ButtonStyle(),
            onPressed: !isStatusSuccess
                ? null
                : () => _showAddEditDialog(
                    context: context, title: add, onConfirmation: () => provider.create()),
            child: Text(isStatusSuccess ? addNew : wait,
                style: TextStyle(fontSize: isLandscape ? 20 : 16)),
          );
        }),
        Consumer<CategoriesProvider>(
            builder: (BuildContext context, CategoriesProvider provider, _) {
          List<WordCategory> categories = provider.categories;
          switch (provider.status) {
            case CategoriesProviderStatus.success:
              return _categoriesList(categories);
            case CategoriesProviderStatus.loading:
              return Text(wait);
            default:
              return SmallUserDialog(provider.categoriesErrorMsg, provider.confirmReadErrorMsg);
          }
        }),
        Consumer<CategoriesProvider>(
            builder: (BuildContext context, CategoriesProvider provider, _) {
          final bool isError = provider.categoriesErrorMsg.isNotEmpty;
          final isStatusError = provider.status == CategoriesProviderStatus.error;
          if (!isError && isStatusError) return const SizedBox();
          return Text(provider.categoriesErrorMsg,
              style: const TextStyle(color: Colors.red, fontSize: 11.0),
              textAlign: TextAlign.center);
        }),
      ]),
    );
  }

  Widget _categoriesList(List<WordCategory> categories) {
    if (categories.isEmpty) return const Text('You have no categories.');
    return SizedBox(
      height: 40.0,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          key: const Key('You-CustomizeScreen-categories-list'),
          shrinkWrap: true,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            WordCategory item = categories[index];
            return _buildCategoryCard(context, item);
          }),
    );
  }

  Widget _buildCategoryCard(BuildContext context, WordCategory item) {
    final String edit = utils.capitalize(AppLocalizations.of(context)?.edit ?? 'Edit');
    final String delete = utils.capitalize(AppLocalizations.of(context)?.delete ?? 'Delete');
    // prevent edit and delete default category: 'no category' id=1
    final bool isNotDefault = item.id != 1;
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: theme.DavarColors.profileCategoriesCard[1],
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(
            width: 2.0, style: BorderStyle.solid, color: const Color.fromARGB(23, 134, 55, 3)),
      ),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isNotDefault
                ? IconButton(
                    onPressed: () => _showAddEditDialog(
                        context: context,
                        title: edit,
                        onConfirmation: () => context.read<CategoriesProvider>().update(item),
                        category: item),
                    icon: const Icon(Icons.edit, size: 16, color: Colors.blue))
                : const SizedBox(width: 6.0),
            Text(item.name),
            isNotDefault
                ? IconButton(
                    onPressed: () => _showDialog(context, '$delete: ${item.name}?',
                        () => context.read<CategoriesProvider>().delete(item.id)),
                    icon: const Icon(Icons.delete, size: 16, color: Colors.red))
                : const SizedBox(width: 6.0),
          ]),
    );
  }

  void _showAddEditDialog({
    required BuildContext context,
    required String title,
    required VoidCallback onConfirmation,
    WordCategory? category,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title, textAlign: TextAlign.center),
        content: AddEditWordCategory(
            onConfirmation: onConfirmation,
            category: category,
            onChangeHandle: (value) =>
                context.read<CategoriesProvider>().onNewCategoryNameChange(value)),
      ),
    );
  }
}
