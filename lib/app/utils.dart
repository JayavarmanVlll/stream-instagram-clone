import 'package:flutter/material.dart';

import 'package:stream_feed/stream_feed.dart' as feed;

/// Extension method on [BuildContext] to easily perform snackbar operations.
extension Snackbar on BuildContext {
  /// Removes the current active [SnackBar], and replaces it with a new snackbar
  /// with content of [message].
  void removeAndShowSnackbar(final String message) {
    ScaffoldMessenger.of(this).removeCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

/// Convenient helper methods.
abstract class Helpers {
  /// Resizes the image url to the given [resize] setting.
  ///
  /// Default:
  /// * width: 300
  /// * heigth: 300
  /// * type: ResizeType.fill
  static String resizedUrl({
    required String url,
    feed.Resize resize =
        const feed.Resize(300, 300, type: feed.ResizeType.clip),
  }) {
    final thumbnail = resize.params.entries.fold(
        url,
        (previousValue, element) =>
            '$previousValue&${element.key}=${element.value}');
    return thumbnail;
  }
}
