import 'package:race_tracker_project/model/race_segment/race_segment.dart';

///
/// Checkpoint Class to store the participant time of finishing each segment
///
class Checkpoint {
  final String id;
  final int bibNumber;
  final String raceId;
  final DateTime? startTime;
  final DateTime? endTime;
  final RaceSegment segment;

  const Checkpoint({
    required this.id,
    required this.raceId,
    required this.bibNumber,
    required this.segment,
    this.startTime,
    this.endTime,
  });

  @override
  String toString() {
    return "Bib Number: $bibNumber,Race ID: $raceId,Segment: ${segment.label},Time: $startTime - $endTime";
  }
}
