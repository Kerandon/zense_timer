import 'package:equatable/equatable.dart';

class QuoteModel extends Equatable {
  final int id;
  final String quote;
  final bool shown;

  const QuoteModel(this.id, this.quote, this.shown);

  factory QuoteModel.fromMap({required Map<String, dynamic> map}) {
    return QuoteModel(map['id'], map['quote'], map['shown'] == 1);
  }

  @override
  List<Object?> get props => [quote];
}
