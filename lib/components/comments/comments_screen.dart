import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:stream_feed/stream_feed.dart' as feed;
import 'package:stream_instagram_clone/components/app_widgets/widgets.dart';
import 'package:stream_instagram_clone/components/comments/state/comment_state.dart';

import '../../app/app.dart';
import '../home/widgets/widgets.dart';

/// {@template comments_screen}
/// Screen that shows all comments for a given post.
/// {@endtemplate}
class CommentsScreen extends StatefulWidget {
  /// {@macro comments_screen}
  const CommentsScreen({
    Key? key,
    required this.activityId,
    required this.activityOwnerData,
  }) : super(key: key);

  /// Activity id for the particular activity's comments to load.
  final String activityId;

  /// Owner / [feed.User] of the activity.
  final UserData activityOwnerData;

  /// MaterialPageRoute to this screen.
  static Route route({
    required String activityId,
    required UserData activityOwnerData,
  }) =>
      MaterialPageRoute(
        builder: (context) => CommentsScreen(
          activityId: activityId,
          activityOwnerData: activityOwnerData,
        ),
      );

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late FocusNode commentFocusNode;
  late CommentState commentState;

  @override
  void initState() {
    super.initState();
    commentFocusNode = FocusNode();
    commentState = CommentState(
      client: context.feedState.client,
      activityId: widget.activityId,
      activityOwnerData: widget.activityOwnerData,
    );
  }

  @override
  void dispose() {
    commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: commentState),
        ChangeNotifierProvider.value(value: commentFocusNode),
      ],
      child: GestureDetector(
        onTap: () {
          commentState.resetCommentFocus();
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Comments'),
            backgroundColor: AppColors.background,
            elevation: 1,
            shadowColor: Colors.white,
          ),
          body: Stack(
            children: [
              _CommentsList(
                activityId: widget.activityId,
              ),
              const _CommentBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommentBox extends StatefulWidget {
  const _CommentBox({
    Key? key,
  }) : super(key: key);

  @override
  __CommentBoxState createState() => __CommentBoxState();
}

class __CommentBoxState extends State<_CommentBox> {
  late final _commentController = TextEditingController();

  static final _border = OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(24)),
    borderSide: BorderSide(
      color: Colors.white.withOpacity(0.5),
      width: 0.5,
    ),
  );

  Future<void> handleSubmit(String? value) async {
    if (value != null && value.isNotEmpty) {
      _commentController.clear();
      await context.read<CommentState>().postComment(message: value);
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentFocus =
        context.select((CommentState state) => state.commentFocus);

    final focusNode = context.watch<FocusNode>();

    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              final tween =
                  Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                      .chain(CurveTween(curve: Curves.easeOutQuint));
              final offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
            child: (commentFocus.typeOfComment == TypeOfComment.reactionComment)
                ? _replyToBox(commentFocus, context)
                : const SizedBox.shrink(),
          ),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(top: BorderSide(color: AppColors.grey)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _emojiText('❤️'),
                  _emojiText('🙌'),
                  _emojiText('🔥'),
                  _emojiText('👏🏻'),
                  _emojiText('😢'),
                  _emojiText('😍'),
                  _emojiText('😮'),
                  _emojiText('😂'),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Avatar.small(userData: context.feedState.userData!),
              ),
              Expanded(
                child: TextField(
                  controller: _commentController,
                  focusNode: focusNode,
                  onSubmitted: handleSubmit,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    suffix: _doneButton(focusNode.hasFocus),
                    hintText: 'Add a comment...',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    focusedBorder: _border,
                    border: _border,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
    );
  }

  Widget _emojiText(String emoji) {
    return Text(
      emoji,
      style: const TextStyle(fontSize: 24),
    );
  }

  Container _replyToBox(CommentFocus commentFocus, BuildContext context) {
    return Container(
      color: AppColors.grey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(
              'Replying to ${commentFocus.user.fullName}',
              style: AppTextStyle.textStyleFaded,
            ),
            const Spacer(),
            TapFadeIcon(
              onTap: () {
                context.read<CommentState>().resetCommentFocus();
              },
              icon: Icons.close,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _doneButton(bool hasFocus) {
    return hasFocus
        ? GestureDetector(
            onTap: () {
              handleSubmit(_commentController.text);
            },
            child: const Text(
              'Done',
              style: AppTextStyle.textStyleAction,
            ),
          )
        : const SizedBox.shrink();
  }
}

class _CommentsList extends StatelessWidget {
  const _CommentsList({
    Key? key,
    required this.activityId,
  }) : super(key: key);

  final String activityId;

  @override
  Widget build(BuildContext context) {
    final comments =
        context.select((CommentState state) => state.activityComments);
    if (comments == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (comments.isEmpty) {
      return const Center(child: Text('Be the first to add a comment.'));
    } else {
      return ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          return _CommentTile(reaction: comments[index]);
        },
      );
    }
  }
}

class _CommentTile extends StatefulWidget {
  const _CommentTile({
    Key? key,
    required this.reaction,
    this.canReply = true,
  }) : super(key: key);

  final feed.Reaction reaction;
  final bool canReply;
  @override
  __CommentTileState createState() => __CommentTileState();
}

class __CommentTileState extends State<_CommentTile> {
  late final userData = UserData.fromMap(widget.reaction.user!.data!);
  late final message = extractMessage;
  late final timeSince = Jiffy(widget.reaction.createdAt).fromNow();

  late int numberOfLikes = widget.reaction.childrenCounts?['like'] ?? 0;

  late bool isLiked = _isFavorited();
  feed.Reaction? likeReaction;

  String numberOfLikesMessage(int count) {
    if (count == 0) {
      return '';
    }
    if (count == 1) {
      return '1 like';
    } else {
      return '$count likes';
    }
  }

  String get extractMessage {
    final data = widget.reaction.data;
    if (data != null && data['message'] != null) {
      return data['message'] as String;
    } else {
      return '';
    }
  }

  bool _isFavorited() {
    likeReaction = widget.reaction.latestChildren?['like']?.firstWhereOrNull(
        (element) => element.user!.id == context.feedState.user.id);
    return likeReaction != null;
  }

  Future<void> _handleFavorite(bool liked) async {
    if (isLiked && likeReaction != null) {
      await context.feedState.client.reactions.delete(likeReaction!.id!);
      numberOfLikes--;
    } else {
      likeReaction = await context.feedState.client.reactions.addChild(
        'like',
        widget.reaction.id!,
        userId: context.feedState.user.id,
      );
      numberOfLikes++;
    }
    setState(() {
      isLiked = liked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Avatar.tiny(userData: userData),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        userData.fullName,
                        style: AppTextStyle.textStyleBold,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(message),
                      const Spacer(),
                      Center(
                        child: FavoriteIconButton(
                          isLiked: isLiked,
                          size: 14,
                          onTap: _handleFavorite,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          timeSince,
                          style: AppTextStyle.textStyleFaded,
                        ),
                      ),
                      Visibility(
                        visible: numberOfLikes > 0,
                        child: SizedBox(
                          width: 60,
                          child: Text(
                            numberOfLikesMessage(numberOfLikes),
                            style: AppTextStyle.textStyleFaded,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: widget.canReply,
                        child: SizedBox(
                          width: 50,
                          child: GestureDetector(
                            onTap: () {
                              context.read<CommentState>().setCommentFocus(
                                    CommentFocus(
                                      typeOfComment:
                                          TypeOfComment.reactionComment,
                                      id: widget.reaction.id!,
                                      user: UserData.fromMap(
                                          widget.reaction.user!.data!),
                                    ),
                                  );

                              FocusScope.of(context)
                                  .requestFocus(context.read<FocusNode>());
                            },
                            child: const Text(
                              'Reply',
                              style: AppTextStyle.textStyleFaded,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: _ChildCommentList(
              comments: widget.reaction.latestChildren?['comment']),
        )
      ],
    );
  }
}

class _ChildCommentList extends StatefulWidget {
  const _ChildCommentList({Key? key, required this.comments}) : super(key: key);

  final List<feed.Reaction>? comments;

  @override
  _ChildCommentListState createState() => _ChildCommentListState();
}

class _ChildCommentListState extends State<_ChildCommentList> {
  late List<Widget> commentWidgets;

  @override
  void initState() {
    super.initState();
    commentWidgets = _createWidgetsFromComments(widget.comments);
  }

  List<Widget> _createWidgetsFromComments(List<feed.Reaction>? comments) {
    return widget.comments
            ?.map(
              (reaction) => _CommentTile(
                key: ValueKey('comment-tile-${reaction.id}'),
                reaction: reaction,
                canReply: false,
              ),
            )
            .toList() ??
        [];
  }

  @override
  void didUpdateWidget(covariant _ChildCommentList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.comments != widget.comments) {
      commentWidgets = _createWidgetsFromComments(widget.comments);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (commentWidgets.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [...commentWidgets],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
