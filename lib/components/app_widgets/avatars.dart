import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart' as feed;

import '../../app/app.dart';

/// An avatar that display a user's profile picture.
///
/// Supports different sizes:
/// - `Avatar.tiny`
/// - `Avatar.small`
/// - `Avatar.medium`
/// - `Avatar.big`
class Avatar extends StatelessWidget {
  /// Creates a tiny avatar.
  const Avatar.tiny({
    Key? key,
    required this.userData,
  })  : _avatarSize = _tinyAvatarSize,
        _paddedCircle = _tinyPaddedCircle,
        _coloredCircle = _tinyColoredCircle,
        hasNewStory = false,
        fontSize = 14,
        resize = const feed.Resize(80, 80),
        super(key: key);

  /// Creates a small avatar.
  const Avatar.small({
    Key? key,
    this.hasNewStory = false,
    required this.userData,
  })  : _avatarSize = _smallAvatarSize,
        _paddedCircle = _smallPaddedCircle,
        _coloredCircle = _smallColoredCircle,
        fontSize = 20,
        resize = const feed.Resize(80, 80),
        super(key: key);

  /// Creates a medium avatar.
  const Avatar.medium({
    Key? key,
    this.hasNewStory = false,
    required this.userData,
  })  : _avatarSize = _mediumAvatarSize,
        _paddedCircle = _mediumPaddedCircle,
        _coloredCircle = _mediumColoredCircle,
        fontSize = 26,
        resize = const feed.Resize(300, 300),
        super(key: key);

  /// Creates a big avatar.
  const Avatar.big({
    Key? key,
    this.hasNewStory = false,
    required this.userData,
  })  : _avatarSize = _bigAvatarSize,
        _paddedCircle = _bigPaddedCircle,
        _coloredCircle = _bigColoredCircle,
        fontSize = 30,
        resize = const feed.Resize(300, 300),
        super(key: key);

  /// Indicates if the user has a new story. If yes, their avatar is surrounded
  /// with an indicator.
  final bool hasNewStory;

  /// The user data to show for the avatar.
  final UserData userData;

  /// Text size of the user's initials when there is no profile photo.
  final double fontSize;

  /// Profile picture Size,
  final feed.Resize resize;

  final double _avatarSize;
  final double _paddedCircle;
  final double _coloredCircle;

  // Tiny avatar configuration
  static const _tinyAvatarSize = 30.0;
  static const _tinyPaddedCircle = _tinyAvatarSize + 2;
  static const _tinyColoredCircle = _tinyPaddedCircle * 2 + 4;

  // Small avatar configuration
  static const _smallAvatarSize = 50.0;
  static const _smallPaddedCircle = _smallAvatarSize + 2;
  static const _smallColoredCircle = _smallPaddedCircle * 2 + 4;

  // Medium avatar configuration
  static const _mediumAvatarSize = 90.0;
  static const _mediumPaddedCircle = _mediumAvatarSize + 2;
  static const _mediumColoredCircle = _mediumPaddedCircle * 2 + 4;

  // Big avatar configuration
  static const _bigAvatarSize = 150.0;
  static const _bigPaddedCircle = _bigAvatarSize + 2;
  static const _bigColoredCircle = _bigPaddedCircle * 2 + 4;

  @override
  Widget build(BuildContext context) {
    if (!hasNewStory) {
      return _CircularProfilePicture(
        size: _avatarSize,
        userData: userData,
        fontSize: fontSize,
        resize: resize,
      );
    }
    return Container(
      width: _coloredCircle,
      height: _coloredCircle,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: _CircularProfilePicture(
          size: _avatarSize,
          userData: userData,
          fontSize: fontSize,
          resize: resize,
        ),
      ),
    );
  }
}

class _CircularProfilePicture extends StatelessWidget {
  const _CircularProfilePicture({
    Key? key,
    required this.size,
    required this.userData,
    required this.fontSize,
    required this.resize,
  }) : super(key: key);

  final UserData userData;

  final double size;
  final double fontSize;

  final feed.Resize resize;

  @override
  Widget build(BuildContext context) {
    final profilePhoto = userData.profilePhoto;
    return (profilePhoto == null)
        ? Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              color: AppColors.accentColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${userData.firstName[0]}${userData.lastName[0]}',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          )
        : CachedNetworkImage(
            imageUrl: Helpers.resizedUrl(url: profilePhoto, resize: resize),
            fit: BoxFit.contain,
            imageBuilder: (context, imageProvider) => Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
          );
  }
}
