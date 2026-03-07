import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    this.name,
    this.avatar,
  });

  static const empty = User(id: '', email: '');

  final String id;
  final String email;
  final String? name;
  final String? avatar;

  bool get isEmpty => this == empty;
  bool get isNotEmpty => !isEmpty;

  @override
  List<Object?> get props => [id, email, name, avatar];
}
