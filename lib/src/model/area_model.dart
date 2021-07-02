class AreaModel {
  int id;
  String name;
  List<AreaModel> childs;

  static AreaModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    AreaModel invoiceAreaBean = AreaModel();
    invoiceAreaBean.id = map['id'];
    invoiceAreaBean.name = map['name'];
    invoiceAreaBean.childs = List()
      ..addAll((map['childs'] as List ?? []).map((o) => AreaModel.fromMap(o)));
    return invoiceAreaBean;
  }

  Map toJson() => {
        "id": id,
        "name": name,
        "childs": childs.map((e) => e.toJson()).toList(),
      };
}
