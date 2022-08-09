import 'dart:developer';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobServices {
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
