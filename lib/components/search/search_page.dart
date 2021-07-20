import 'package:stream_instagram_clone/components/home/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart' as feed;
import 'package:provider/provider.dart';
import 'package:stream_instagram_clone/app/app.dart';

/// {@template search_page}
/// Page to search for content and other users.
/// {@endtemplate}
class SearchPage extends StatelessWidget {
  /// {@macro search_page}
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final users = List<DemoAppUser>.from(DemoAppUser.values)
      ..removeWhere((it) => it.id == context.feedState.user.id);
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return _UserProfile(userId: users[index].id!);
      },
    );
  }
}

class _UserProfile extends StatefulWidget {
  const _UserProfile({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String userId;

  @override
  __UserProfileState createState() => __UserProfileState();
}

class __UserProfileState extends State<_UserProfile> {
  late feed.User user;
  late bool isFollowing;
  late Future<UserData> userDataFuture = getUser();

  Future<UserData> getUser() async {
    final userClient = context.feedState.client.user(widget.userId);

    user = await userClient.profile();
    isFollowing = await _isFollowingUser(user);
    return UserData.fromMap(user.data!);
  }

  /// Determine if the current authenticated user is following [user].
  Future<bool> _isFollowingUser(feed.User user) async {
    final following = await context.feedState.currentUserFeed.following(
      limit: 1,
      offset: 0,
      filter: [
        feed.FeedId.id('user:${user.id}'),
      ],
    );

    return following.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData>(
      future: userDataFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const SizedBox.shrink();
          default:
            if (snapshot.hasError) {
              return const Text('Could not load profile');
            } else {
              final userData = snapshot.data;
              if (userData != null) {
                return _ProfileTile(
                  user: user,
                  userData: userData,
                  isFollowing: isFollowing,
                );
              }
              return const SizedBox.shrink();
            }
        }
      },
    );
  }
}

class _ProfileTile extends StatefulWidget {
  const _ProfileTile({
    Key? key,
    required this.user,
    required this.userData,
    required this.isFollowing,
  }) : super(key: key);

  final feed.User user;
  final UserData userData;
  final bool isFollowing;

  @override
  __ProfileTileState createState() => __ProfileTileState();
}

class __ProfileTileState extends State<_ProfileTile> {
  bool _isLoading = false;
  late bool _isFollowing = widget.isFollowing;

  Future<void> followOrUnfollowUser(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    final currentUserTimelineFeed = context.feedState.currentTimelineFeed;
    final selectedUserFeed = context.feedState.targetUserFeed(widget.user.id!);

    if (_isFollowing) {
      await currentUserTimelineFeed.unfollow(selectedUserFeed);
      _isFollowing = false;
    } else {
      await currentUserTimelineFeed.follow(selectedUserFeed);
      _isFollowing = true;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Avatar.small(userData: widget.userData),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('username', style: AppTextStyle.textStyleBold),
              Text(widget.userData.fullName),
            ],
          ),
        ),
        const Spacer(),
        (_isLoading)
            ? const SizedBox(
                height: 25,
                width: 25,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              )
            : TextButton(
                onPressed: () {
                  followOrUnfollowUser(context);
                },
                child: _isFollowing
                    ? const Text('Unfollow')
                    : const Text('Follow'),
              )
      ],
    );
  }
}
