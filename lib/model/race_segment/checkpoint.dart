import 'package:race_tracker_project/model/race_segment/race_segment.dart';

///
/// Checkpoint Class to store the participant time of finishing each segment
///
class Checkpoint {
  final int bibNumber;
  final String raceId;
  final DateTime timeStamp;
  final RaceSegment segment;

  const Checkpoint({
    required this.raceId,
    required this.bibNumber,
    required this.segment,
    required this.timeStamp,
  });
}
