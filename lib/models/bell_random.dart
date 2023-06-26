import 'package:equatable/equatable.dart';

class BellRandom extends Equatable {
  final int index;
  final int min;
  final int max;

  const BellRandom(this.index, this.min, this.max);

  @override
  List<Object?> get props => [index];
}
