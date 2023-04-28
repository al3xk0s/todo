abstract class ITodo {
  String get id;
  String get title;

  String? get description;

  List<ITodo> get childrens;

  bool get isActive;
  bool get isClosed;
}

class Todo implements ITodo {
  @override
  final String id;

  @override
  List<ITodo> get childrens => _childrens.toList();
  final Set<ITodo> _childrens;

  @override
  final String title;

  @override
  final String? description;

  @override
  final bool isActive;

  @override
  bool get isClosed => !isActive;

  @override
  bool operator==(covariant ITodo other) => identical(this, other) || id == other.id;

  @override
  int get hashCode => id.hashCode;
  
  Todo({
    required this.id,
    required this.title,
    required this.isActive,
    List<ITodo> childrens = const [],
    this.description,
  }) : _childrens = childrens.toSet();
}
