import 'package:flutter/material.dart';
import 'package:race_tracker_project/screens/manager_screen/dashboard_screen.dart';
import 'package:race_tracker_project/screens/manager_screen/race_screen.dart';
import 'package:race_tracker_project/theme/theme.dart';

class Navigation_Bar extends StatefulWidget {
  final int initialIndex;
  const Navigation_Bar({Key? key, this.initialIndex = 0}) : super(key: key);
  @override
  _Navigation_BarState createState() => _Navigation_BarState();
}

class _Navigation_BarState extends State<Navigation_Bar> {
  int _selectedIndex = 0;
 
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
    
  //  final List<Widget> _screens = [
  //   DashboardScreen(),
  //   RaceScreen(),
  //   // RankScreen(),
  //   // AccountScreen(),
  // ];
  void _onItemTapped(int index, BuildContext context) {
    if (_selectedIndex == index) return; // Already on this screen
    
    setState(() {
      _selectedIndex = index;
    });
   switch (index) {
      case 0: // Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
        break;
      case 1: // Race
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RaceScreen()),
        );
        break;
      // Add cases for other tabs as needed
    }
  }

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
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index, context),
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
