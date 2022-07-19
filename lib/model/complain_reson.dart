class Reason{
  final int id;
  final String name;
  Reason({  this.id=1, this.name="abc",});

  @override
  String toString() {
    return name;
  }
}