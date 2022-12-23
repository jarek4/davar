import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/davar_ads/davar_ads.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_search/custom_search.dart';

class WordsListScreen extends StatelessWidget {
  const WordsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(padding: const EdgeInsets.only(top: 8.0), child: _buildFilters(context)),
      const Divider(color: Colors.black),
      _handleSearchWordsProviderErrors(),
      _handleCategoriesProviderErrors(),
      Expanded(child: _buildList()),
      const Padding(
        padding: EdgeInsets.only(bottom: 2.0, top: 2.0),
        child: DavarAdBanner(key: Key('School-AllWordsScreen-bottom-banner-320')),
      ),
    ]);
  }

  LayoutBuilder _buildList() {
    return LayoutBuilder(builder: (context, constraint) {
      final bool isOrientationPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
      final double maxWidth = constraint.maxWidth;
      final bool isWidth = maxWidth > 500.0;
      final double landscapeMaxW = (maxWidth * 3) / 4;
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Flexible(child: SizedBox()),
        SizedBox(
            width: (isOrientationPortrait && !isWidth) ? maxWidth - 30 : landscapeMaxW,
            child: const PaginatedStreamList()),
        const Flexible(child: SizedBox()),
      ]);
    });
  }

  Row _buildFilters(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Expanded(child: SizedBox()),
      Consumer2<CategoriesProvider, SearchWordsProvider>(
          builder: (BuildContext context, CategoriesProvider cp, SearchWordsProvider search, _) {
        final bool isCpLoading = cp.status == CategoriesProviderStatus.loading;
        final bool isCpError = cp.status == CategoriesProviderStatus.error;
        if (isCpLoading || isCpError) {
          return const SizedBox();
        }
        return CategoriesFilter(
          cp.filterCategories,
          search.selectedCategory,
          (WordCategory? c) => context.read<SearchWordsProvider>().onCategoryChange(c),
        );
      }),
      const SizedBox(width: 6.0),
      Consumer<SearchWordsProvider>(builder: (BuildContext context, SearchWordsProvider search, _) {
        return FavoriteFilter(
          isChecked: search.selectedOnlyFavorite,
          onChangeHandle: () => search.onOnlyFavoriteChange(),
        );
      }),
      const SizedBox(width: 6.0),
      SearchFilter(() => _showSearch(context, context.read<SearchWordsProvider>())),
      const Expanded(child: SizedBox()),
    ]);
  }

  Future<void> _showSearch(BuildContext context, SearchWordsProvider search) async {
    Word? result = await showSearch<Word?>(context: context, delegate: WordSearchDelegate(search));
    if (result == null) return;
    search.insertItemAtTheTop(result);
  }

  Widget _handleSearchWordsProviderErrors() {
    return Selector<SearchWordsProvider, String>(
        selector: (_, state) => state.errorMsg,
        shouldRebuild: (String pre, String next) {
          return pre != next;
        },
        builder: (BuildContext context, err, __) {
          if (err.isNotEmpty) {
            return SmallUserDialog(err, context.read<SearchWordsProvider>().confirmReadErrorMsg);
          }
          return const SizedBox.shrink();
        });
  }

  Widget _handleCategoriesProviderErrors() {
    return Selector<CategoriesProvider, String>(
        selector: (_, state) => state.categoriesErrorMsg,
        shouldRebuild: (String pre, String next) {
          return pre != next;
        },
        builder: (BuildContext context, err, __) {
          if (err.isNotEmpty) {
            return SmallUserDialog(err, context.read<CategoriesProvider>().confirmReadErrorMsg);
          }
          return const SizedBox.shrink();
        });
  }
}
