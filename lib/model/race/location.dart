///
/// Continent Enum for Location
///
enum Region {
  europe("Europe"),
  asia("Asia"),
  southAmerica("South America"),
  oceania("Oceania");

  final String label;

  const Region(this.label);
}

///
/// Location class on where the race is being held
/// with attributes: name and continent (To be updated)
class Location {
  final String name;
  final Region region;

  const Location({
    required this.name,
    required this.region,
  });

  @override
  String toString() {
    return "{Country: $name, Region: $region}";
  }
}
