export 'flavors.dart';

extension NonNull on List {
  List nonNulls() => this.where((element) => element != null).toList();
}