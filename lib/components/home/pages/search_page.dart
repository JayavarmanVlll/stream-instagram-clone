import 'package:stream_instagram_clone/components/home/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart' as feed;
import 'package:provider/provider.dart';
import 'package:stream_instagram_clone/app/app.dart';
import 'package:stream_instagram_clone/state/state.dart';

/// {@template search_page}
/// Page to search for content and other users.
/// {@endtemplate}
class SearchPage extends StatelessWidget {
  /// {@macro search_page}
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final users = List<DummyAppUser>.from(DummyAppUser.values)
      ..removeWhere((it) => it.id == context.read<FeedState>().user.id);
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
  late Future<UserData> userDataFuture = getUser();

  Future<UserData> getUser() async {
    final userClient = context.read<FeedState>().client.user(widget.userId);

    user = await userClient.profile();
    return UserData.fromMap(user.data!);
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
  }) : super(key: key);

  final feed.User user;
  final UserData userData;

  @override
  __ProfileTileState createState() => __ProfileTileState();
}

class __ProfileTileState extends State<_ProfileTile> {
  bool _isLoading = false;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _determineIsFollowing();
  }

  Future<void> _determineIsFollowing() async {
    setState(() {
      _isLoading = true;
    });
    final client = context.read<FeedState>().client;
    final currentUserFeed = client.flatFeed(
      'timeline',
      client.currentUser!.userId,
    );

    final following =
        await currentUserFeed.following(limit: 1, offset: 0, filter: [
      feed.FeedId.id('user:${widget.user.id}'),
    ]);

    if (following.isNotEmpty) {
      setState(() {
        _isFollowing = true;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isFollowing = false;
        _isLoading = false;
      });
    }
  }

  Future<void> followOrUnfollowUser(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    final client = context.read<FeedState>().client;
    final currentUserFeed = client.flatFeed(
      'timeline',
      client.currentUser!.userId,
    );
    final selectedUserFeed = client.flatFeed('user', widget.user.id!);
    if (_isFollowing) {
      await currentUserFeed.unfollow(selectedUserFeed);
      _isFollowing = false;
    } else {
      await currentUserFeed.follow(selectedUserFeed);
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
