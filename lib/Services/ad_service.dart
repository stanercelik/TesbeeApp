import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService extends GetxService {
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  Future<AdService> init() async {
    await MobileAds.instance.initialize();
    loadInterstitialAd();
    loadBannerAd();
    return this;
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _getInterstitialAdUnitId(),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
          _isInterstitialAdLoaded = false;
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_isInterstitialAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          loadInterstitialAd(); // Reload a new ad after the previous one is closed
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          loadInterstitialAd();
        },
      );

      _interstitialAd!.show();
      _isInterstitialAdLoaded = false; // Reset the flag
    } else {
      print('Interstitial ad is not loaded yet.');
    }
  }

  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: _getBannerAdUnitId(),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('BannerAd loaded.');
          _isBannerAdLoaded = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('BannerAd failed to load: $error');
          ad.dispose();
          _isBannerAdLoaded = false;
        },
        onAdOpened: (Ad ad) => print('BannerAd opened.'),
        onAdClosed: (Ad ad) => print('BannerAd closed.'),
      ),
    );

    _bannerAd!.load();
  }

  Widget getBannerAdWidget() {
    if (_isBannerAdLoaded && _bannerAd != null) {
      return Container(
        alignment: Alignment.center,
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    } else {
      return const SizedBox
          .shrink(); // Return an empty widget if the ad isn't loaded
    }
  }

  // Function to get the appropriate ad unit ID for interstitial ads depending on the platform
  String _getInterstitialAdUnitId() {
    if (GetPlatform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // Replace with your actual iOS ad unit ID for interstitials
    } else if (GetPlatform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Replace with your actual Android ad unit ID for interstitials
    }
    return '';
  }

  // Function to get the appropriate ad unit ID for banner ads depending on the platform
  String _getBannerAdUnitId() {
    if (GetPlatform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // Replace with your actual iOS ad unit ID for banners
    } else if (GetPlatform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Replace with your actual Android ad unit ID for banners
    }
    return '';
  }

  @override
  void onClose() {
    super.onClose();
    _interstitialAd?.dispose();
    _bannerAd?.dispose();
  }
}
