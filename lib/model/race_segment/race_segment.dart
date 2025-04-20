///
/// Race Segment for the Triathlon
///
enum RaceSegment {
  swimming("Swimming"),
  cycling("Cycling"),
  running("Running");

  final String label;

  const RaceSegment(this.label);
}
