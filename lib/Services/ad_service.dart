import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService extends GetxService {
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;

  Future<AdService> init() async {
    await MobileAds.instance.initialize();
    loadInterstitialAd();
    return this;
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _getAdUnitId(),
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

  // Function to get the appropriate ad unit ID depending on the platform
  String _getAdUnitId() {
    if (GetPlatform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // Replace with your actual iOS ad unit ID
    } else if (GetPlatform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Replace with your actual Android ad unit ID
    }
    return '';
  }
}
