class AreaModel {
  int id;
  String name;
  List<AreaModel> children;

  static AreaModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    AreaModel invoiceAreaBean = AreaModel();
    invoiceAreaBean.id = map['id'];
    invoiceAreaBean.name = map['name'];
    invoiceAreaBean.children = []..addAll(
        (map['children'] as List ?? []).map((o) => AreaModel.fromMap(o)));
    return invoiceAreaBean;
  }

  Map toJson() => {
        "id": id,
        "name": name,
        "children": children.map((e) => e.toJson()).toList(),
      };
}
