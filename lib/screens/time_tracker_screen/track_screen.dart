import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker_project/model/race/race.dart';
import 'package:race_tracker_project/screens/time_tracker_screen/bib_detail_screen.dart';
import 'package:race_tracker_project/theme/theme.dart';
import 'package:race_tracker_project/widgets/race_button.dart';
import 'package:race_tracker_project/screens/provider/race_provider.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key, required String segment});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  List<int> selectedIndexes = [];

  @override
  Widget build(BuildContext context) {
    final race = context.watch<RaceProvider>().races.data?.first;

    if (race == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    Color _getRaceStatusColor(Race race) {
      switch (race.raceStatus) {
        case RaceStatus.upcoming:
          return Colors.orange;
        case RaceStatus.ongoing:
          return Colors.green;
        case RaceStatus.completed:
          return Colors.grey;
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(190),
        child: AppBar(
          backgroundColor: RaceColors.primary,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Swim Tracker',
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
                            // _searchQuery = value.trim().toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search BIB...',
                          hintStyle: const TextStyle(color: RaceColors.white),
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
                            backgroundColor: _getRaceStatusColor(race),
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
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: 20,
          itemBuilder: (context, index) {
            return RaceButton(
              text: 'BIB $index',
              onPressed: () {
                setState(() {
                  if (selectedIndexes.contains(index)) {
                    selectedIndexes.remove(index);
                  } else {
                    selectedIndexes.add(index);
                  }
                });
              },
              onLongPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BibDetailScreen(bibNumber: index),
                  ),
                );
              },
              isSelected: selectedIndexes.contains(index),
            );
          },
        ),
      ),
    );
  }
}
