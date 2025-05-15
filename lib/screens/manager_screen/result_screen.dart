import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker_project/screens/provider/participant_provider.dart';
import 'package:race_tracker_project/screens/provider/race_provider.dart';
import 'package:race_tracker_project/services/race_services.dart';
import 'package:race_tracker_project/theme/theme.dart';
import 'package:race_tracker_project/utils/date_time_util.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ParticipantProvider>(context);
    final finishedParticipants = provider.getSortedFinishedParticipant();
    final raceProvider = context.watch<RaceProvider>();
    final raceData = raceProvider.races.data!.first;
    final screenWidth = MediaQuery.of(context).size.width;
    final dateTimeFormatted = DateTimeUtil.formatDateTime(raceData.startDate!);

    return Scaffold(
      appBar: AppBar(
        title: Text("Race Results", style: RaceTextStyles.darkHeading),
        backgroundColor: RaceColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(RaceSpacings.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Info Header
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  raceData.raceEvent,
                  style: RaceTextStyles.heading.copyWith(fontSize: 22),
                ),
                const SizedBox(height: RaceSpacings.s / 2),
                Text(
                  dateTimeFormatted ,
                  style: RaceTextStyles.body.copyWith(
                    color: RaceColors.textSubtle,
                  ),
                ),
                const SizedBox(height: RaceSpacings.m),
                const Divider(color: RaceColors.lightGrey),
              ],
            ),

            // Responsive Table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: screenWidth),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.resolveWith<Color>(
                        (states) => RaceColors.primary,
                      ),
                      dataRowColor: MaterialStateProperty.resolveWith<Color>(
                        (states) => RaceColors.white,
                      ),
                      columnSpacing: RaceSpacings.m,
                      columns: const [
                        DataColumn(label: ResponsiveHeader(text: 'Rank')),
                        DataColumn(label: ResponsiveHeader(text: 'Name')),
                        DataColumn(label: ResponsiveHeader(text: 'BIB')),
                        DataColumn(label: ResponsiveHeader(text: 'Time')),
                      ],
                      rows: finishedParticipants.asMap().entries.map((entry) {
                        final index = entry.key;
                        final p = entry.value;
                        final totalTime = p.finishDate!.difference(p.startDate!);
                        final totalTimeFormatted = DateTimeUtil.formatDuration(totalTime);

                        return DataRow(cells: [
                          DataCell(Text('${index + 1}', style: RaceTextStyles.body.copyWith(fontWeight: FontWeight.bold))),
                          DataCell(Text(p.name, style: RaceTextStyles.body)),
                          DataCell(Text(p.bibNumber.toString(), style: RaceTextStyles.body)),
                          DataCell(Text(totalTimeFormatted, style: RaceTextStyles.body.copyWith(color: RaceColors.primary, fontWeight: FontWeight.bold))),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}

class ResponsiveHeader extends StatelessWidget {
  final String text;

  const ResponsiveHeader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: RaceTextStyles.button.copyWith(
        color: RaceColors.white,
        fontSize: 20,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
