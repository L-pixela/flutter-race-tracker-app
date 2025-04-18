///
/// Continent Enum for Location
///
enum Region { europe, asia, southAmerica, oceania }

///
/// Location class on where the race is being held
/// with attributes: name and continent (To be updated)
class Location {
  final String name;
  final Region continent;

  const Location(this.name, this.continent);

  @override
  String toString() {
    return "{Country: $name, Continent: $continent}";
  }
}
