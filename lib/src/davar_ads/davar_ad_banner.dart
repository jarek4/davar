import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  bool _isTextVisible = false;

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
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Future.delayed(const Duration(milliseconds: 800)).then((_) {
                setState(() {
                  _isTextVisible = true;
                });
              });
            });
            if (kDebugMode) print('BannerAdListener Ad loaded.');
          }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
            setState(() {
              _isBottomAdLoaded = false;
            });
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
    _isTextVisible = false;
  }

  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String support = AppLocalizations.of(context)?.clickAdToSupport ?? 'Support me!';
    if (_bottomBannerAd == null && !_isBottomAdLoaded) {
      return const SizedBox(height: 50);
    } else {
      return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.blue, width: 1.1)),
        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
        child: Column(
          children: [
            SizedBox(height: 50, child: AdWidget(ad: _bottomBannerAd!)),
            _isTextVisible
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 2.6, top: 2.0),
                    child: Text(
                      '$support!',
                      textAlign: TextAlign.center,
                    ),
                  )
                : const SizedBox(height: 20.0)
          ],
        ),
      );
    }
  }
}
