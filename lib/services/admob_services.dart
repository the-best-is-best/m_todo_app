import 'dart:developer';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobServices {
  static bool adLoaded = false;
  static final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-7284367511062855/6466580005',
    size: AdSize.banner,
    request: const AdRequest(),
    listener: listenerBanner,
  );
  static final BannerAdListener listenerBanner = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => adLoaded = true,
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      adLoaded = false;
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );
  static AdWidget adWidget = AdWidget(ad: myBanner);

  //

  static InterstitialAd? _interstitialAd;
  static InterstitialAd? getInterstitialAd() => _interstitialAd;
  static Future initInterstitial() async {
    await InterstitialAd.load(
      //adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      adUnitId: 'ca-app-pub-7284367511062855/7215451246',
      request: const AdRequest(extras: {'rdp': '1'}),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          log('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  static void getAd() async {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    }
  }
}
