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

  UserData? _userData;

  /// The extraData from [user], mapped to an [UserData] object.
  UserData? get userData => _userData;

  /// Current user's [feed.FlatFeed] with name 'user'.
  ///
  /// This feed contains all of a user's personal posts.
  feed.FlatFeed get currentUserFeed => _client.flatFeed('user', _user.id);

  /// Current user's [feed.FlatFeed] with name 'timeline'.
  ///
  /// This contains all posts that a user has subscribed (followed) to.
  feed.FlatFeed get currentTimelineFeed => _client.flatFeed('user', _user.id);

  /// Target user's [feed.FlatFeed] with name 'user'.
  feed.FlatFeed targetUserFeed(String targetUserId) =>
      _client.flatFeed('user', targetUserId);

  /// `Timeline`FlatFeed.
  feed.FlatFeed get timelineUserFeed => _client.flatFeed('timeline');

  /// Connect to Stream Feed with one of the demo users, using a predefined,
  /// hardcoded token.
  ///
  /// THIS IS ONLY FOR DEMONSTRATIONS PURPOSES. TOKENS SHOULD NOT BE
  /// HARDCODED LIKE THIS.
  Future<bool> connect(DemoAppUser user) async {
    _client = feed.StreamFeedClient.connect(
      'crjk2cdcf2tc',
      token: user.token,
    );

    final currentUser = await _client.currentUser?.getOrCreate(user.data!);
    if (currentUser != null && currentUser.data != null) {
      _user = currentUser;
      _userData = UserData.fromMap(_user.data!);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  /// Uploads a new profile picture from the given [filePath].
  ///
  /// This will call [notifyListeners] and update the local [_userData] state.
  Future<void> updateProfilePhoto(String filePath) async {
    final imageUrl =
        await client.images.upload(feed.AttachmentFile(path: filePath));
    _userData = _userData?.copyWith(profilePhoto: imageUrl);
    if (_userData != null) {
      await client.currentUser!.update(_userData!.toMap());
    }

    notifyListeners();
  }
}
