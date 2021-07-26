import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:stream_feed/stream_feed.dart' as feed;

import '../../../app/app.dart';
import '../../app_widgets/widgets.dart';
import '../../comments/comments.dart';

/// {@template post_card}
/// A card that displays a user post.
/// {@endtemplate}
class PostCard extends StatelessWidget {
  /// {@macro post_card}
  const PostCard({
    Key? key,
    required this.enrichedAcitivity,
  }) : super(key: key);

  /// Enriched activity (post) to display.
  final feed.EnrichedActivity enrichedAcitivity;

  @override
  Widget build(BuildContext context) {
    final actorData =
        enrichedAcitivity.actor!.data as Map<String, dynamic>; // TODO: refine.
    final userData =
        UserData.fromMap(actorData['data'] as Map<String, dynamic>);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProfileSlab(
          userData: userData,
        ),
        _PictureCarousal(
          enrichedActivity: enrichedAcitivity,
        ),
        _CommentBlock(
          enrichedActivity: enrichedAcitivity,
        ),
      ],
    );
  }
}

class _PictureCarousal extends StatefulWidget {
  const _PictureCarousal({
    Key? key,
    required this.enrichedActivity,
  }) : super(key: key);

  final feed.EnrichedActivity enrichedActivity;

  @override
  __PictureCarousalState createState() => __PictureCarousalState();
}

class __PictureCarousalState extends State<_PictureCarousal> {
  late var likeReactions = getLikeReactions() ?? [];
  late var likeCount = getLikeCount() ?? 0;

  feed.Reaction? latestLikeReaction;

  List<feed.Reaction>? getLikeReactions() {
    return widget.enrichedActivity.latestReactions!['like'];
  }

  int? getLikeCount() {
    return widget.enrichedActivity.reactionCounts!['like'];
  }

  Future<void> _addLikeReaction() async {
    latestLikeReaction = await context.feedState.client.reactions.add(
      'like',
      widget.enrichedActivity.id!,
      userId: context.feedState.user.id,
    );

    setState(() {
      likeReactions.add(latestLikeReaction!);
      likeCount++;
    });
  }

  Future<void> _removeLikeReaction() async {
    late String? reactionId;
    // A new reaction was added to this state.
    if (latestLikeReaction != null) {
      reactionId = latestLikeReaction?.id;
    } else {
      // An old reaction has been retrieved from Stream.
      final prevReaction = widget.enrichedActivity.ownReactions?['like'];
      if (prevReaction != null && prevReaction.isNotEmpty) {
        reactionId = prevReaction[0].id;
      }
    }

    try {
      if (reactionId != null) {
        await context.feedState.client.reactions.delete(reactionId);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      likeReactions.removeWhere((element) => element.id == reactionId);
      likeCount--;
      latestLikeReaction = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._pictureCarousel(context),
        _likes() ?? const SizedBox.shrink()
      ],
    );
  }

  /// Picture carousal and interaction buttons.
  List<Widget> _pictureCarousel(BuildContext context) {
    const iconPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
    const imageSize = 500;
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: CachedNetworkImage(
          placeholder: (context, _) {
            return const SizedBox(height: 300);
          },
          imageUrl: Helpers.resizedUrl(
              url: widget.enrichedActivity.extraData!['image_url'] as String,
              resize: const feed.Resize(imageSize, imageSize)),
        ),
      ),
      Row(
        children: [
          const SizedBox(
            width: 4,
          ),
          Padding(
            padding: iconPadding,
            child: FavoriteIconButton(
              isLiked: widget.enrichedActivity.ownReactions?['like'] != null,
              onTap: (liked) {
                if (liked) {
                  _addLikeReaction();
                } else {
                  _removeLikeReaction();
                }
              },
            ),
          ),
          Padding(
            padding: iconPadding,
            child: TapFadeIcon(
                onTap: () {
                  final map = (widget.enrichedActivity.actor!.data
                      as Map<String, dynamic>)['data'] as Map<String, dynamic>;
                  Navigator.of(context).push(
                    CommentsScreen.route(
                      activityId: widget.enrichedActivity.id!,
                      activityOwnerData: UserData.fromMap(map),
                    ),
                  );
                },
                icon: Icons.chat_bubble_outline),
          ),
          Padding(
            padding: iconPadding,
            child: TapFadeIcon(
                onTap: () => context
                    .removeAndShowSnackbar('Message: Not yet implemented'),
                icon: Icons.call_made),
          ),
          const Spacer(),
          Padding(
            padding: iconPadding,
            child: TapFadeIcon(
                onTap: () => context
                    .removeAndShowSnackbar('Bookmark: Not yet implemented'),
                icon: Icons.bookmark_border),
          ),
        ],
      )
    ];
  }

  Widget? _likes() {
    if (likeReactions.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 8),
        child: RichText(
          text: TextSpan(
            text: 'Liked by ',
            style: AppTextStyle.textStyleLight,
            children: <TextSpan>[
              TextSpan(
                  text: UserData.fromMap(
                          likeReactions[0].user?.data as Map<String, dynamic>)
                      .fullName,
                  style: AppTextStyle.textStyleBold),
              if (likeCount > 1 && likeCount < 3) ...[
                const TextSpan(text: ' and '),
                TextSpan(
                    text: UserData.fromMap(
                            likeReactions[1].user?.data as Map<String, dynamic>)
                        .fullName,
                    style: AppTextStyle.textStyleBold),
              ],
              if (likeCount > 3) ...[
                const TextSpan(text: ' and '),
                const TextSpan(
                    text: 'others', style: AppTextStyle.textStyleBold),
              ],
            ],
          ),
        ),
      );
    }
  }
}

class _CommentBlock extends StatefulWidget {
  const _CommentBlock({
    Key? key,
    required this.enrichedActivity,
  }) : super(key: key);

  final feed.EnrichedActivity enrichedActivity;

  @override
  __CommentBlockState createState() => __CommentBlockState();
}

class __CommentBlockState extends State<_CommentBlock> {
  feed.EnrichedActivity get enrichedActivity => widget.enrichedActivity;

  late final String _timeSinceMessage =
      Jiffy(widget.enrichedActivity.time).fromNow();

  late List<feed.Reaction> comments = getCommentReactions() ?? [];

  late int commentsCount = getCommentCount() ?? 0;

  List<feed.Reaction>? getCommentReactions() {
    return enrichedActivity.latestReactions!['comment'];
  }

  int? getCommentCount() {
    return enrichedActivity.reactionCounts!['comment'];
  }

  Future<void> addComment(String message) async {
    final reaction = await context.feedState.client.reactions.add(
      'comment',
      enrichedActivity.id!,
      userId: context.feedState.user.id,
      data: {
        'message': message,
      },
    );

    setState(() {
      comments.add(reaction);
      commentsCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    const textPadding = EdgeInsets.all(8);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (commentsCount > 0 && comments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: UserData.fromMap(
                              comments[0].user?.data as Map<String, dynamic>)
                          .fullName,
                      style: AppTextStyle.textStyleBold),
                  const TextSpan(text: '  '),
                  TextSpan(text: comments[0].data!['message'] as String),
                ],
              ),
            ),
          ),
        if (commentsCount > 1 && comments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: UserData.fromMap(
                              comments[1].user?.data as Map<String, dynamic>)
                          .fullName,
                      style: AppTextStyle.textStyleBold),
                  const TextSpan(text: '  '),
                  TextSpan(text: comments[1].data!['message'] as String),
                ],
              ),
            ),
          ),
        if (commentsCount > 2)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8),
            child: GestureDetector(
              onTap: () {
                final map = (widget.enrichedActivity.actor!.data
                    as Map<String, dynamic>)['data'] as Map<String, dynamic>;
                Navigator.of(context).push(CommentsScreen.route(
                  activityId: widget.enrichedActivity.id!,
                  activityOwnerData: UserData.fromMap(map),
                ));
              },
              child: Text(
                'View all $commentsCount comments',
                style: AppTextStyle.textStyleFaded,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8),
          child: Text(
            _timeSinceMessage,
            style: AppTextStyle.textStyleFaded,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8, right: 8),
          child: Row(
            children: [
              Avatar.tiny(
                userData: context.watch<FeedState>().userData!,
              ),
              Expanded(
                child: Padding(
                  padding: textPadding,
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      color: AppColors.fadedText,
                      fontSize: 14,
                    ),
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {
                      if (value.isNotEmpty && value != '') {
                        addComment(value);
                      }
                    },
                  ),
                ),
              ),
              const Padding(
                padding: textPadding,
                child: Text('❤️'),
              ),
              const Padding(
                padding: textPadding,
                child: Text('🙌'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileSlab extends StatelessWidget {
  const _ProfileSlab({
    Key? key,
    required this.userData,
  }) : super(key: key);

  final UserData userData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
      child: Row(
        children: [
          Avatar.small(userData: userData),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              userData.fullName,
              style: AppTextStyle.textStyleBold,
            ),
          ),
          const Spacer(),
          TapFadeIcon(
              onTap: () =>
                  context.removeAndShowSnackbar('Not part of the demo'),
              icon: Icons.more_horiz),
        ],
      ),
    );
  }
}
