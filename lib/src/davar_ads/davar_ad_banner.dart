import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'davar_ads.dart';

class DavarAdBanner extends StatefulWidget {
  const DavarAdBanner({Key? key}) : super(key: key);



  @override
  State<DavarAdBanner> createState() => _DavarAdBannerState();
}

class _DavarAdBannerState extends State<DavarAdBanner> {
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
    if (_bottomBannerAd == null && !_isBottomAdLoaded) {
      return const SizedBox.shrink();
    } else {
      return Column(
        children: [
          SizedBox(height: 50, child: AdWidget(ad: _bottomBannerAd!)),
          const Padding(
            padding: EdgeInsets.only(bottom: 4.0, top: 2.0),
            child: Text('Support my app by clicking this ad!', textAlign: TextAlign.center,),
          )
        ],
      );
    }

  }

}
