import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_feed/stream_feed.dart' as feed;

import '../../app/app.dart';
import '../home/widgets/widgets.dart';
import '../new_post/new_post.dart';
import 'edit_profile_screen.dart';

/// {@template profile_page}
/// User profile page. List of user created posts.
/// {@endtemplate}
class ProfilePage extends StatefulWidget {
  /// {@macro profile_page}
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<feed.Activity>> activitiesFuture = _fetchActivities();

  late feed.User user;

  Future<List<feed.Activity>> _fetchActivities() async {
    return context.feedState.currentUserFeed.getActivities();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: activitiesFuture,
      builder: (context, AsyncSnapshot<List<feed.Activity>> snapshot) {
        switch (snapshot.connectionState) {
          case (ConnectionState.waiting):
            return const CircularProgressIndicator();
          default:
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              final activities = snapshot.data;
              if (activities == null || activities.isEmpty) {
                return const _NoPostsMessage();
              }

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _ProfileHeader(
                      numberOfPosts: activities.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        primary: AppColors.primaryText,
                      ),
                      autofocus: false,
                      clipBehavior: Clip.none,
                      onPressed: () {
                        Navigator.of(context).push(EditProfileScreen.route);
                      },
                      child: const Text('Edit Profile'),
                    ),
                  ),
                  const SliverToBoxAdapter(
                      child: SizedBox(
                    height: 24,
                  )),
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final activity = snapshot.data![index];
                        final url = activity.extraData!['image_url'] as String;
                        return SizedBox(
                          width: 200,
                          height: 200,
                          child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              Helpers.resizedUrl(
                                url: url,
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: activities.length,
                    ),
                  )
                ],
              );
            }
        }
      },
    );
  }
}

class _ProfileHeader extends StatefulWidget {
  const _ProfileHeader({
    Key? key,
    required this.numberOfPosts,
  }) : super(key: key);

  final int numberOfPosts;

  @override
  __ProfileHeaderState createState() => __ProfileHeaderState();
}

class __ProfileHeaderState extends State<_ProfileHeader> {
  late final Future<feed.User>? userFuture =
      context.feedState.client.currentUser?.profile();

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<FeedState>().userData;
    if (userData == null) return const SizedBox.shrink();
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Avatar.medium(
            userData: userData,
          ),
        ),
        Expanded(
          child: FutureBuilder<feed.User>(
            future: userFuture,
            builder: (context, user) {
              if (user.data?.data == null) return const SizedBox.shrink();
              return Row(
                children: [
                  const Spacer(flex: 2),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          '${widget.numberOfPosts}',
                          style: AppTextStyle.textStyleBold,
                        ),
                        const Text(
                          'Posts',
                          style: AppTextStyle.textStyleLight,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          '${user.data?.followersCount}',
                          style: AppTextStyle.textStyleBold,
                        ),
                        const Text(
                          'Followers',
                          style: AppTextStyle.textStyleLight,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          '${user.data?.followingCount}',
                          style: AppTextStyle.textStyleBold,
                        ),
                        const Text(
                          'Following',
                          style: AppTextStyle.textStyleLight,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 3),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NoPostsMessage extends StatelessWidget {
  const _NoPostsMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('This is too empty.'),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(NewPostScreen.route);
          },
          child: const Text('Lets add a post'),
        )
      ],
    );
  }
}
