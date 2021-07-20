import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart' as feed;
import 'package:stream_instagram_clone/app/app.dart';
import 'package:stream_instagram_clone/components/home/widgets/widgets.dart';
import 'package:provider/provider.dart';

/// {@template timeline_page}
/// Page to display a timeline of user created posts. Global 'timeline' feed.
/// {@endtemplate}
class TimelinePage extends StatefulWidget {
  /// {@macro timeline_page}
  const TimelinePage({Key? key}) : super(key: key);

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  late final _activitiesFuture = _loadActivities();

  Future<List<feed.EnrichedActivity>> _loadActivities() async {
    return context.feedState.currentTimelineFeed.getEnrichedActivities(
      flags: feed.EnrichmentFlags()
          .withOwnReactions()
          .withRecentReactions()
          .withReactionCounts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<feed.EnrichedActivity>>(
      future: _activitiesFuture,
      builder: (context, snapshot) {
        final activities = snapshot.data;
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return const Text('Could not load profile');
            } else {
              if (activities == null || activities.isEmpty) {
                return const Center(
                  child: Text('Timeline is empty. Follow someone'),
                );
              }
              return ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  // return Text('${activities[index].id}');
                  return PostCard(
                    enrichedAcitivity: activities[index],
                  ); // TODO: add back
                },
              );
            }
        }
      },
    );
  }
}
