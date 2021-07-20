import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_instagram_clone/app/app.dart';
import 'package:stream_instagram_clone/state/state.dart';

/// An avatar that display a user's profile picture.
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
        super(key: key);

  /// Indicates if the user has a new story. If yes, their avatar is surrounded
  /// with an indicator.
  final bool hasNewStory;

  /// The user data to show for the avatar.
  final UserData userData;

  /// Text size of the user's initials when there is no profile photo.
  final double fontSize;

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
  static const _mediumAvatarSize = 70.0;
  static const _mediumPaddedCircle = _mediumAvatarSize + 2;
  static const _mediumColoredCircle = _mediumPaddedCircle * 2 + 4;

  // Big avatar configuration
  static const _bigAvatarSize = 100.0;
  static const _bigPaddedCircle = _bigAvatarSize + 2;
  static const _bigColoredCircle = _bigPaddedCircle * 2 + 4;

  @override
  Widget build(BuildContext context) {
    if (!hasNewStory) {
      return _CircularProfilePicture(
        size: _avatarSize,
        userData: userData,
        fontSize: fontSize,
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
  }) : super(key: key);

  final UserData userData;

  final double size;
  final double fontSize;

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
            imageUrl: profilePhoto,
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
