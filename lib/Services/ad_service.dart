import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService extends GetxService {
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;
  bool _isInterstitialTesbihatDoneAdLoaded = false;

  Future<AdService> init() async {
    await MobileAds.instance.initialize();
    loadInterstitialAd();
    loadBannerAd();
    loadInterstitialTesbihatDoneAd();
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
          debugPrint('InterstitialAd failed to load: $error');
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
      debugPrint('Interstitial ad is not loaded yet.');
    }
  }

  void loadInterstitialTesbihatDoneAd() {
    InterstitialAd.load(
      adUnitId: _getTesbihatDoneAdUnitId(),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialTesbihatDoneAdLoaded = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
          _isInterstitialTesbihatDoneAdLoaded = false;
        },
      ),
    );
  }

  void showInterstitialTesbihatDoneAd() {
    if (_isInterstitialTesbihatDoneAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          loadInterstitialTesbihatDoneAd(); // Reload a new ad after the previous one is closed
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          loadInterstitialTesbihatDoneAd();
        },
      );

      _interstitialAd!.show();
      _isInterstitialTesbihatDoneAdLoaded = false; // Reset the flag
    } else {
      debugPrint('Interstitial ad is not loaded yet.');
    }
  }

  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: _getBannerAdUnitId(),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('BannerAd loaded.');
          _isBannerAdLoaded = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
          _isBannerAdLoaded = false;
        },
        onAdOpened: (Ad ad) => debugPrint('BannerAd opened.'),
        onAdClosed: (Ad ad) => debugPrint('BannerAd closed.'),
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
      return 'ca-app-pub-2958213735333735/9022040201'; // Replace with your actual iOS ad unit ID for interstitials
    } else if (GetPlatform.isAndroid) {
      return 'ca-app-pub-2958213735333735/6488360682'; // Replace with your actual Android ad unit ID for interstitials
    }
    return '';
  }

  String _getTesbihatDoneAdUnitId() {
    if (GetPlatform.isIOS) {
      return 'ca-app-pub-2958213735333735/9022040201'; // Replace with your actual iOS ad unit ID for interstitials
    } else if (GetPlatform.isAndroid) {
      return 'ca-app-pub-2958213735333735/8869874225'; // Replace with your actual Android ad unit ID for interstitials
    }
    return '';
  }

  // Function to get the appropriate ad unit ID for banner ads depending on the platform
  String _getBannerAdUnitId() {
    if (GetPlatform.isIOS) {
      return 'ca-app-pub-2958213735333735/3331031148'; // Replace with your actual iOS ad unit ID for banners
    } else if (GetPlatform.isAndroid) {
      return 'ca-app-pub-2958213735333735/9909393654'; // Replace with your actual Android ad unit ID for banners
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
