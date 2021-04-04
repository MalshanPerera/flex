class LoadEvent {
  final bool isLoading;
  LoadEvent._(this.isLoading);

  factory LoadEvent.show() => LoadEvent._(true);
  factory LoadEvent.hide() => LoadEvent._(false);
}