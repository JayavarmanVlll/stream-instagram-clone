import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart' as feed;

import 'demo_users.dart';
import 'models/models.dart';

/// {@template feed_state}
/// State related to Stream Feed. Manages the connection and stores
/// a references to the Stream Feed Client and User.
/// {@endtemplate}
class FeedState extends ChangeNotifier {
  /// {@macro feed_state}
  FeedState();

  late final feed.StreamFeedClient _client;
  late final feed.User _user;

  /// Stream Feed client.
  feed.StreamFeedClient get client => _client;

  /// Stream Feed user.
  feed.User get user => _user;

  /// Object representing the extraData from [user].
  UserData? userData;

  /// Mock authentication to connect a dummy user with predefined tokens.
  Future<void> connect(DemoAppUser user) async {
    _client = feed.StreamFeedClient.connect(
      'crjk2cdcf2tc',
      token: user.token,
    );

    final currentUser =
        await _client.currentUser?.get(); // TODO explore getOrCreate
    if (currentUser != null && currentUser.data != null) {
      _user = currentUser;
      userData = UserData.fromMap(currentUser.data!);
    } else {
      // No user data has been set on Stream. Set data.
      _user = await _client.setUser(user.data!);
      userData = UserData.fromMap(user.data!);
    }

    notifyListeners();
  }

  /// Uploads a new profile picture from the given [filePath].
  ///
  /// This will call [notifyListeners] and update the local [userData] state.
  Future<void> updateProfilePhoto(String filePath) async {
    final imageUrl =
        await client.images.upload(feed.AttachmentFile(path: filePath));
    userData = userData?.copyWith(profilePhoto: imageUrl);
    if (userData != null) {
      await client.currentUser!.update(userData!.toMap());
    }

    notifyListeners();
  }
}
