import 'package:todo/common/data/serializable/serializable.dart';
import 'package:todo/common/utils/tree_utils.dart';
import 'package:todo/entities/todo/models/todo.dart';

abstract class ITodoSerializer implements ICollectionSerializer<ITodo, String> {}

class TodoSerializer extends BaseJsonSerializer<ITodo> implements ITodoSerializer {
  @override
  ITodo fromMap(JsonMap data) => Todo(
    id: data['id'],
    title: data['title'],
    isActive: data['isActive'],
    description: data['description'],
    childrens: (data['childrens'] as List).map((e) => fromMap(e)).toList(),
  );
  
  @override
  JsonMap toMap(ITodo value) =>  {
    'id': value.id,
    'title': value.title,
    'description': value.description,
    'isActive': value.isActive,
    'childrens': value.childrens.map(toMap).toList(),
  };

  JsonMap _signleElementToMap(ITodo element) => {
    'id': element.id,
    'title': element.title,
    'description': element.description,
    'isActive': element.isActive,
  };

  List<JsonMap> _valuesToJson(ITodo root) {
    final values = <JsonMap>[];

    dfs(root: root, getChildrens: (v) => v.childrens, delegate: (r, c) {
      final map = _signleElementToMap(c);
      final parentId = r?.id;

      map['parentId'] = parentId;
      values.add(map);
    });

    return values;
  }
}
