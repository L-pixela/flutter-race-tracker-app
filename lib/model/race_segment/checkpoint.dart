import 'package:race_tracker_project/model/participant/participant.dart';
import 'package:race_tracker_project/model/race/race.dart';
import 'package:race_tracker_project/model/race_segment/race_segment.dart';

///
/// Checkpoint Class to store the participant time of finishing each segment
///
class Checkpoint {
  final Race race;
  final Participant participant;
  final DateTime timeStamp;
  final RaceSegment segment;

  const Checkpoint(this.race, this.participant, this.segment, this.timeStamp);
}
