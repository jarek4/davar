import 'package:davar/src/authentication/authentication.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/ui/screens/more/add_edit_word_category/add_edit_word_category.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (BuildContext context, AuthProvider provider, _) {
      switch (provider.status) {
        case AuthenticationStatus.authenticated:
          return _buildScreenBody(context, provider.user.name, provider.user.email,
              provider.user.native, provider.user.learning);
        default:
          return const UnauthenticatedInfo(key: Key('You-ProfileScreen-not authenticated'));
      }
    });
  }

  Widget _buildScreenBody(
      BuildContext context, String name, String email, String native, String learning) {
    Orientation orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = orientation == Orientation.landscape;
    return ListView(
        padding: EdgeInsets.symmetric(horizontal: isLandscape ? 80 : 10),
        key: const Key('More-ProfileScreen-signed in'),
        shrinkWrap: true,
        children: [
          OrientationBuilder(builder: (context, orientation) {
            final bool isLandscape = orientation == Orientation.landscape;
            return ListView(shrinkWrap: true, children: [
              _buildWordCategoriesList(isLandscape),
            ]);
          }),
          const Divider(thickness: 1.2),
          ListTile(
            title: Text('Name: $name'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: $email'),
                Text('You learn: $learning'),
              ],
            ),
            leading: const Icon(Icons.person_outline),
          ),
          const Divider(thickness: 1.2),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout_outlined),
            onTap: () => _showDialog(context, 'Are you sure, you want to logout?',
                () => context.read<AuthProvider>().signOut()),
          ),
          const Divider(thickness: 1.2),
        ]);
  }

  void _showDialog(BuildContext context, String title, VoidCallback onConfirmation) {
    void okBtnHandle() {
      onConfirmation();
      Navigator.of(context).pop();
    }

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title, textAlign: TextAlign.center),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                  TextButton(onPressed: okBtnHandle, child: const Text('OK'))
                ],
              ),
            ));
  }

  Container _buildWordCategoriesList(bool isLandscape) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
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
              child: Text('Manage your categories. Add new one, delete or edit.',
                  style: TextStyle(fontSize: isLandscape ? 20 : 16), textAlign: TextAlign.center),
            ),
          ],
        ),
        Consumer<CategoriesProvider>(
            builder: (BuildContext context, CategoriesProvider provider, _) {
          final bool isStatusSuccess = provider.status == CategoriesProviderStatus.success;
          return TextButton(
            // style: ButtonStyle(),
            onPressed: !isStatusSuccess
                ? null
                : () => _showAddEditDialog(
                      context: context,
                      title: 'Add',
                      onConfirmation: () => provider.create(),
                    ),
            child: Text(isStatusSuccess ? 'Add new category' : 'Wait...',
                style: TextStyle(fontSize: isLandscape ? 20 : 16)),
          );
        }),
        Consumer<CategoriesProvider>(
            builder: (BuildContext context, CategoriesProvider provider, _) {
          final bool isStatusSuccess = provider.status == CategoriesProviderStatus.success;
          List<WordCategory> categories = provider.categories;
          switch (provider.status) {
            case CategoriesProviderStatus.success:
              return _buildCategoriesList(categories);
            case CategoriesProviderStatus.loading:
              return const Text('Wait...');
            default:
              return _buildErrorInformation();
          }
        }),
        Consumer<CategoriesProvider>(
            builder: (BuildContext context, CategoriesProvider provider, _) {
          final bool isError = provider.categoriesErrorMsg.isNotEmpty;
          if (!isError) return const SizedBox();
          return Text(provider.categoriesErrorMsg,
              style: const TextStyle(color: Colors.red, fontSize: 11.0),
              textAlign: TextAlign.center);
        }),
      ]),
    );
  }

  Widget _buildCategoriesList(List<WordCategory> categories) {
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
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(
            width: 2.0, style: BorderStyle.solid, color: const Color.fromARGB(23, 134, 55, 3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () => _showAddEditDialog(
                    context: context,
                    title: 'Edit',
                    onConfirmation: () => context.read<CategoriesProvider>().update(item),
                    category: item,
                  ),
              icon: const Icon(
                Icons.edit,
                size: 16,
                color: Colors.blue,
              )),
          Text('${item.name}. id=${item.id}; userId=${item.userId}'),
          IconButton(
              onPressed: () => _showDialog(context, 'Delete ${item.name}?',
                  () => context.read<CategoriesProvider>().delete(item.id)),
              icon: const Icon(
                Icons.delete,
                size: 16,
                color: Colors.red,
              )),
        ],
      ),
    );
  }

/*  void _showDialog(BuildContext context, String title, VoidCallback onConfirmation) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title, textAlign: TextAlign.center),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
              TextButton(onPressed: onConfirmation, child: const Text('OK'))
            ],
          ),
        ));
  }*/

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
          title: title,
          onConfirmation: onConfirmation,
          category: category,
          onChangeHandle: (value) =>
              context.read<CategoriesProvider>().onNewCategoryNameChange(value),
        ),
      ),
    );
  }

  Widget _buildErrorInformation() {
    return Consumer<CategoriesProvider>(
        builder: (BuildContext context, CategoriesProvider provider, _) {
      final String error = provider.categoriesErrorMsg;
      final bool isErrorMessage = error.isNotEmpty;
      switch (isErrorMessage) {
        case true:
          _showErrorSnackBar(context, error);
          return Text(error,
              style: const TextStyle(color: Colors.red), textAlign: TextAlign.center);
        default:
          return const SizedBox();
      }
    });
  }

  void _showErrorSnackBar(BuildContext context, String authenticationError) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.grey,
        content: Text(authenticationError, textAlign: TextAlign.center),
      ));
    });
  }
}
