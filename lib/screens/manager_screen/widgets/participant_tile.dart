import 'package:flutter/material.dart';
import 'package:race_tracker_project/model/participant/participant.dart';
import 'package:race_tracker_project/theme/theme.dart';

class ParticipantTile extends StatelessWidget {
  final Participant participant;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const ParticipantTile(
      {super.key,
      required this.participant,
      required this.onEdit,
      required this.onDelete});

  String get title =>
      "Bib Number: ${participant.bibNumber} - Race: ${participant.raceId}";
  String get subTitle =>
      "Name: ${participant.name} \nGender:${participant.gender} ";
  String get trailing => "${participant.participantStatus!.label} ";

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6, // Controls the shadow depth
      shadowColor: RaceColors.primary.withOpacity(0.5), // Softer shadow
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(RaceSpacings.radius),
      //   side: BorderSide(color: RaceColors.primary, width: 1),
      // ),
      margin: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 6), // Optional spacing
      child: ListTile(
        tileColor: RaceColors.buttonAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RaceSpacings.radius),
        ),
        title: Text(title,
            style: RaceTextStyles.heading
                .copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: Text(
          subTitle,
          style: RaceTextStyles.label.copyWith(color: RaceColors.orange),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              trailing,
              style: RaceTextStyles.label.copyWith(color: RaceColors.orange),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.edit_square, color: RaceColors.primary),
              onPressed: onEdit,
              iconSize: 20,
            ),
            const SizedBox(width: 2),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
              iconSize: 20,
            ),
          ],
        ),
      ),
    );
  }
}
