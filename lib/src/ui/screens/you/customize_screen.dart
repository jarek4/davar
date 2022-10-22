import 'package:davar/src/authentication/authentication.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomizeScreen extends StatelessWidget {
  const CustomizeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CategoriesProvider>(
      create: (_) => CategoriesProvider(context.read<AuthProvider>().user),
      child: OrientationBuilder(builder: (context, orientation) {
        final bool isLandscape = orientation == Orientation.landscape;
        return ListView(shrinkWrap: true, children: [
          _buildWordCategoriesList(isLandscape),
        ]);
      }),
    );
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
            onPressed: isStatusSuccess ? () => provider.create() : null,
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
              return const Text('ERROR');
          }
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
              onPressed: () {},
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

  void _showDialog(BuildContext context, String title, VoidCallback onConfirmation) {
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
  }
}
