import 'dart:convert';

import 'package:flutter/services.dart';

/// Consumer-owned demonstration asset, not a provider or package logo.
const demoLogoAsset = 'assets/demo/neutral_placeholder.png';

/// Supplies a neutral 16x16 square with a transparent margin.
///
/// The PNG uses GalleryColors.inkFaint and GalleryColors.onDark. Keeping its
/// bytes here makes the example runnable without shipping brand image files.
/// Real applications should declare their own images in flutter/assets.
class DemoLogoAssetBundle extends CachingAssetBundle {
  static final _png = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAJElEQVR4nGNgGDSgrnPqf1Iw'
    '7Qz4/usPXjxqwMgwYOBS4oABADSjy4BlZDaWAAAAAElFTkSuQmCC',
  );

  @override
  Future<ByteData> load(String key) async {
    if (key == demoLogoAsset) {
      return ByteData.sublistView(_png);
    }
    return rootBundle.load(key);
  }
}
