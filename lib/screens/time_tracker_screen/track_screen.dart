import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker_project/model/race/race.dart';

import 'package:race_tracker_project/model/race_segment/race_segment.dart';
import 'package:race_tracker_project/screens/provider/participant_provider.dart';
import 'package:race_tracker_project/screens/provider/race_provider.dart';
import 'package:race_tracker_project/screens/time_tracker_screen/bib_detail_screen.dart';
import 'package:race_tracker_project/services/time_tracker_services.dart';
import 'package:race_tracker_project/theme/theme.dart';

class TrackScreen extends StatefulWidget {
  final String raceId;
  final RaceSegment segment;
  const TrackScreen({super.key, required this.raceId, required this.segment});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  late TimeTrackerServices trackerServices;
  late ParticipantProvider participantProvider;

  List<int> selectedIndexes = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    trackerServices = Provider.of<TimeTrackerServices>(context, listen: false);
    trackerServices.intialize(raceId: widget.raceId, segment: widget.segment);

    participantProvider = Provider.of(context, listen: false);
    participantProvider.fetchParticipants();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantProvider>(builder: (context, provider, _) {
      final value = provider.participant;
      final race = context.watch<RaceProvider>().races.data?.first;
      if (race == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      Color getRaceStatusColor(Race race) {
        switch (race.raceStatus) {
          case RaceStatus.upcoming:
            return Colors.orange;
          case RaceStatus.ongoing:
            return Colors.green;
          case RaceStatus.completed:
            return Colors.grey;
        }
      }

      if (value.isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (value.isError) {
        return Center(child: Text('Error: ${value.error}'));
      }

      final filteredParticipants =
          value.data!.where((p) => p.raceId == widget.raceId).toList();

      // Filter and sort participants

      final filteredBib = filteredParticipants
          .where((p) => p.bibNumber.toString().contains(_searchQuery))
          .toList()
        ..sort((a, b) => a.bibNumber.compareTo(b.bibNumber));

      final displayList =
          _searchQuery.isEmpty ? filteredParticipants : filteredBib;

      return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(190),
            child: AppBar(
              backgroundColor: RaceColors.primary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              automaticallyImplyLeading: false,
              flexibleSpace: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.segment.label} Tracker',
                          style: RaceTextStyles.heading.copyWith(
                            color: RaceColors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 36,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value.trim().toLowerCase();
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Search BIB...',
                              hintStyle:
                                  const TextStyle(color: RaceColors.white),
                              prefixIcon:
                                  const Icon(Icons.search, color: Colors.white),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 10,
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text(
                                "Status: ",
                                style: RaceTextStyles.body.copyWith(
                                  color: RaceColors.white,
                                ),
                              ),
                              Chip(
                                label: Text(
                                  race.raceStatus == RaceStatus.ongoing
                                      ? 'In Progress'
                                      : race.raceStatus == RaceStatus.upcoming
                                          ? 'Upcoming'
                                          : 'Completed',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                  ),
                                ),
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                backgroundColor: getRaceStatusColor(race),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                labelPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<TimeTrackerServices>(
              builder: (context, tracker, _) {
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      final participant = displayList[index];
                      final bib = participant.bibNumber;
                      final isDone = trackerServices.isCheckpointCompleted(bib);
                      return GestureDetector(
                        onTap: isDone
                            ? null
                            : () {
                                trackerServices.onParticipantTap(bib);
                                setState(() {});
                              },
                        onLongPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => BibDetailScreen(
                                        bibNumber: participant.bibNumber,
                                      )));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDone
                                ? RaceColors.disabled
                                : RaceColors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'BIB $bib',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    });
              },
            ),
          ));
    });
  }
}
