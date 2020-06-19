import 'package:area_picker/src/data.v4.dart';
import 'package:area_picker/src/model/area_model.dart';

List<AreaModel> loadData() {
  final _data = areaData;
  List<Map<String, dynamic>> getNodes(String key, {Map data}) {
    data ??= _data;
    final node = data[key];
    if (node != null && node is Map) {
      return node
          .map<String, Map<String, dynamic>>((key, value) {
            final child = getNodes(key);
            return MapEntry<String, Map<String, dynamic>>(key, {
              'id': int.parse(key),
              'name': value,
              'childs': child,
            });
          })
          .values
          .toList();
    } else {
      return null;
    }
  }

  List<AreaModel> getProvice(String key, {Map data}) {
    data ??= _data;
    final node = data[key];
    if (node != null && node is Map) {
      return node
          .map<String, AreaModel>((key, value) {
            final child = getNodes(key);
            return MapEntry(
                key,
                AreaModel.fromMap({
                  'id': int.parse(key),
                  'name': value,
                  'childs': child,
                }));
          })
          .values
          .toList();
    } else {
      return null;
    }
  }

  return getProvice('86');
}