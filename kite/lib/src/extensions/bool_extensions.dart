extension BoolExtensions on bool {
  T choose<T>(T whenTrue, T whenFalse) {
    return this ? whenTrue : whenFalse;
  }

  int get toInt => this ? 1 : 0;

  String get yesNo => this ? 'Yes' : 'No';
}

extension NullableBoolExtensions on bool? {
  bool get orFalse => this ?? false;

  bool get orTrue => this ?? true;
}
