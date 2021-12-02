class AreaModel {
  int? id;
  String? name;
  List<AreaModel>? children;

  static AreaModel fromMap(Map map) {
    AreaModel invoiceAreaBean = AreaModel();
    invoiceAreaBean.id = map['id'];
    invoiceAreaBean.name = map['name'];
    invoiceAreaBean.children =
        (map['children'] as List?)?.map((o) => AreaModel.fromMap(o))?.toList();
    return invoiceAreaBean;
  }

  Map toJson() => {
        "id": id,
        "name": name,
        "children": children?.map((e) => e.toJson())?.toList(),
      };
}
