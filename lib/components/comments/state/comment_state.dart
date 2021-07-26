import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart' as feed;
import 'package:stream_instagram_clone/app/app.dart';

/// Indicates the type of comment that was made.
/// Can be:
/// - Activity comment
/// - Reaction comment
enum TypeOfComment {
  /// Comment on an activity
  activityComment,

  /// Comment on a reaction
  reactionComment,
}

/// {@template comment_focus}
/// Information on the type of comment to make. This can be a comment on an
/// activity, or a comment on a reaction.
///
/// It also indicates the parent user on whom the comment is made.
/// {@endtemplate}
class CommentFocus {
  /// {@macro comment_focus}
  const CommentFocus({
    required this.typeOfComment,
    required this.id,
    required this.user,
  });

  /// Indicates the type of comment. See [TypeOfComment].
  final TypeOfComment typeOfComment;

  /// Activity or reaction id on which the comment is made.
  final String id;

  /// The user data of the parent activity or reaction.
  final UserData user;
}

/// {@template comment_state}
/// ChangeNotifier to facilitate posting comments to activities and reactions.
/// {@endtemplate}
class CommentState extends ChangeNotifier {
  /// {@macro comment_state}
  CommentState({
    required this.client,
    required this.activityId,
    required this.activityOwnerData,
  }) {
    _loadAllComments();
  }

  /// The [feed.StreamFeedClient] used to post comments.
  final feed.StreamFeedClient client;

  /// The id for this activity.
  final String activityId;

  /// UserData of whoever owns the activity.
  final UserData activityOwnerData;

  /// The type of commentFocus that is currently selected.

  late CommentFocus commentFocus = CommentFocus(
    typeOfComment: TypeOfComment.activityComment,
    id: activityId,
    user: activityOwnerData,
  );

  /// All comments for this activity.
  List<feed.Reaction>? activityComments;

  Future<void> _loadAllComments() async {
    activityComments = await client.reactions.filter(
      feed.LookupAttribute.activityId,
      activityId,
      kind: 'comment',
    );
    notifyListeners();
  }

  /// Sets the focus to which a comment will be posted to.
  ///
  /// See [postComment].
  void setCommentFocus(CommentFocus focus) {
    commentFocus = focus;
    notifyListeners();
  }

  /// Resets the comment focus to the parent activity.
  void resetCommentFocus() {
    commentFocus = CommentFocus(
      typeOfComment: TypeOfComment.activityComment,
      id: activityId,
      user: activityOwnerData,
    );
    notifyListeners();
  }

  /// Posts a `comment` reaction.
  ///
  /// The parent activity/reaction to which a comment will be posted.
  ///
  /// Dependent on the [commentFocus].
  Future<void> postComment({
    required String message,
  }) async {
    if (commentFocus.typeOfComment == TypeOfComment.activityComment) {
      final reaction = await client.reactions.add(
        'comment',
        commentFocus.id,
        userId: client.currentUser!.userId,
        data: {'message': message},
      );

      activityComments = List.from(activityComments!)..add(reaction);
      notifyListeners();
    } else if (commentFocus.typeOfComment == TypeOfComment.reactionComment) {
      await client.reactions.addChild(
        'comment',
        commentFocus.id,
        userId: client.currentUser!.userId,
        data: {'message': message},
      );

      final updatedComment = await client.reactions.get(commentFocus.id);

      activityComments = [
        for (var comment in activityComments!)
          if (comment.id == commentFocus.id) updatedComment else comment
      ];
      notifyListeners();
    }
  }
}
