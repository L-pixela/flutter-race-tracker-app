import 'package:flutter/material.dart';
import 'package:race_tracker_project/theme/theme.dart';

class RaceButtomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const RaceButtomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          navItem(Icons.home_outlined, "Dashboard", 0),
          navItem(Icons.flag_outlined, "Race", 1),
          navItem(Icons.emoji_events_outlined, "Rank", 2),
          navItem(Icons.person_outline, "Account", 3),
        ],
      ),
    );
  }

  Widget navItem(IconData icon, String label, int index) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? RaceColors.primary.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                icon,
                color: isSelected ? RaceColors.primary : RaceColors.lightGrey,
                size: 20,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color:
                    isSelected ? RaceColors.textHeading : RaceColors.textSubtle,
                fontSize: 12.0,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
