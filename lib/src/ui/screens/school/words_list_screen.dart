import 'package:davar/src/davar_ads/davar_ads.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'custom_search/custom_search.dart';

class WordsListScreen extends StatefulWidget {
  const WordsListScreen({Key? key}) : super(key: key);

  @override
  State<WordsListScreen> createState() => _WordsListScreenState();
}

class _WordsListScreenState extends State<WordsListScreen> {
  BannerAd? _bottomBannerAd;
  bool _isBottomAdLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        _bottomBannerAd = BannerAd(
          adUnitId: adState.bannerAdUnitId,
          size: AdSize.banner,
          request: const AdRequest(),
          listener: BannerAdListener(onAdLoaded: (_) {
            setState(() {
              _isBottomAdLoaded = true;
            });
            if (kDebugMode) print('BannerAdListener Ad loaded.');
          }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
            if (kDebugMode) print('BannerAdListener Ad failed to load: $error');
          }),
        )..load();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _isBottomAdLoaded = false;
  }

  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        // mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.only(top: 8.0), child: _buildFilters(context)),
          const Divider(),
          Expanded(child: _buildList()),
          if (_bottomBannerAd == null && !_isBottomAdLoaded)
            const SizedBox.shrink()
          else
            SizedBox(height: 50, child: AdWidget(ad: _bottomBannerAd!)),
        ]);
  }

  LayoutBuilder _buildList() {
    return LayoutBuilder(builder: (context, constraint) {
      final bool isOrientationPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
      final double maxWidth = constraint.maxWidth;
      final double landscapeMaxW = (maxWidth * 3) / 4;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Flexible(child: SizedBox()),
          SizedBox(
            width: isOrientationPortrait ? maxWidth - 30 : landscapeMaxW,
            child: const PaginatedStreamList(),
          ),
          const Flexible(child: SizedBox()),
        ],
      );
    });
  }

  Row _buildFilters(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Expanded(child: SizedBox()),
      Consumer2<CategoriesProvider, SearchWordsProvider>(
          builder: (BuildContext context, CategoriesProvider cp, SearchWordsProvider search, _) {
        _handleErrors(context, cp, search);
        final CategoriesProviderStatus cpStatus = cp.status;
        if (cpStatus == CategoriesProviderStatus.loading) {
          return const SizedBox();
        }
        return CategoriesFilter(
          cp.filterCategories,
          search.selectedCategory,
          (WordCategory? c) => context.read<SearchWordsProvider>().onCategoryChange(c),
        );
      }),
      const SizedBox(width: 4.0),
      Consumer<SearchWordsProvider>(builder: (BuildContext context, SearchWordsProvider search, _) {
        return FavoriteFilter(
          isChecked: search.selectedOnlyFavorite,
          onChangeHandle: () => search.onOnlyFavoriteChange(),
        );
      }),
      const SizedBox(width: 4.0),
      Consumer<SearchWordsProvider>(builder: (BuildContext context, SearchWordsProvider search, _) {
        final bool hasErrorMsg = search.errorMsg.isNotEmpty;
        if (hasErrorMsg) utils.showSnackBarInfo(context, msg: search.errorMsg);
        return SearchFilter(() => _showSearch(context, search));
      }),
      Consumer<WordsProvider>(builder: (BuildContext context, WordsProvider wp, _) {
        final bool hasErrorMsg = wp.wordsErrorMsg.isNotEmpty;
        if (hasErrorMsg) utils.showSnackBarInfo(context, msg: wp.wordsErrorMsg);
        return const Expanded(child: SizedBox());
      }),
      // const Expanded(child: SizedBox()),
    ]);
  }

  Future<void> _showSearch(BuildContext context, SearchWordsProvider search) async {
    Word? result = await showSearch<Word?>(context: context, delegate: WordSearchDelegate(search));
    if (result == null) return;
    search.insertItemAtTheTop(result);
  }

  void _handleErrors(BuildContext context, CategoriesProvider cp, SearchWordsProvider search) {
    final bool isCategoriesProviderErrorMsg = cp.categoriesErrorMsg.isNotEmpty;
    if (isCategoriesProviderErrorMsg) utils.showSnackBarInfo(context, msg: cp.categoriesErrorMsg);
    final bool isFilteredWordsProviderErrorMsg = search.errorMsg.isNotEmpty;
    if (isFilteredWordsProviderErrorMsg) utils.showSnackBarInfo(context, msg: search.errorMsg);
  }
}
