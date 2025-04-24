import 'package:flutter/material.dart';
import 'package:race_tracker_project/model/participant/participant.dart';
import 'package:race_tracker_project/theme/theme.dart';

class ParticipantTile extends StatelessWidget {
  final Participant participant;
  final VoidCallback onTap;
  const ParticipantTile(
      {super.key, required this.onTap, required this.participant});

  String get title =>
      "Bib Number: ${participant.bibNumber} - ${participant.name}";
  String get subTitle => "${participant.gender} ";
  String get trailing => "${participant.participantStatus!.label} ";

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RaceSpacings.radius),
          side: BorderSide(color: RaceColors.primary, width: 1)),
      child: ListTile(
        onTap: onTap,
        title: Text(title, style: RaceTextStyles.body),
        subtitle: Text(
          subTitle,
          style: RaceTextStyles.label.copyWith(color: RaceColors.orange),
        ),
        trailing: Text(
          trailing,
          style: RaceTextStyles.label.copyWith(color: RaceColors.orange),
        ),
      ),
    );
  }
}
