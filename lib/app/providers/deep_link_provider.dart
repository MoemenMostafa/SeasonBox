import 'package:flutter/foundation.dart';

class DeepLinkProvider extends ChangeNotifier {
  String? _pendingRedirect;
  String? _lastTrackedUri;

  String? get pendingRedirect => _pendingRedirect;

  void setPendingRedirect(String? url) {
    if (_pendingRedirect != url) {
      _pendingRedirect = url;
      notifyListeners();
    }
  }

  void clearPendingRedirect() {
    if (_pendingRedirect != null) {
      _pendingRedirect = null;
      notifyListeners();
    }
  }

  /// Checks if a URI should be tracked and updates the last tracked URI if it should.
  /// Returns true only once per unique URI to avoid duplicate tracking.
  bool shouldTrack(String uri) {
    if (_lastTrackedUri == uri) return false;
    _lastTrackedUri = uri;
    return true;
  }
}
