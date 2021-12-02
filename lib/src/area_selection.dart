import 'package:area_picker/src/model/area_model.dart';
import 'package:area_picker/src/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _provinces = loadData();

class AreaInfo {
  final AreaModel? province;
  final AreaModel? city;
  final AreaModel? county;

  int? get provinceId => province?.id;
  int? get cityId => city?.id;
  int? get countyId => county?.id;

  final int provinceIndex;
  final int cityIndex;
  final int countyIndex;

  String get address =>
      '${province?.name ?? ''}${city?.name ?? ''}${county?.name ?? ''}';

  AreaInfo(
    this.province,
    this.city,
    this.county,
    this.provinceIndex,
    this.cityIndex,
    this.countyIndex,
  );

  @override
  String toString() {
    return address;
  }
}

typedef AreaSelectedCallback = void Function(AreaInfo? areaInfo);

class AreaSelection extends StatefulWidget {
  final AreaSelectedCallback onSelect;
  final int initProvinceIndex;
  final int initCityIndex;
  final int initCountyIndex;
  final bool showCounty;

  AreaSelection({
    Key? key,
    /*required*/ required this.onSelect,
    this.initProvinceIndex = 0,
    this.initCityIndex = 0,
    this.initCountyIndex = 0,
    this.showCounty = true,
  }) : super(key: key);

  @override
  _AreaSelectionState createState() => _AreaSelectionState();
}

class _AreaSelectionState extends State<AreaSelection> {
  List<AreaModel> provinces = _provinces;
  List<AreaModel> cities = [];
  List<AreaModel> counties = [];

  ///选中的省份的index
  late int selectedProvinceIndex;

  ///选中的市的index
  late int selectedCityIndex;

  ///选中的区的index
  late int selectedCountyIndex;

  ///定义省份控制器
  late final FixedExtentScrollController provinceController;

  ///定义市控制器
  late final FixedExtentScrollController cityController;

  ///定义区控制器
  late final FixedExtentScrollController countyController;

  /// 选择变化时候的值
  AreaInfo? tempAreaInfo;

  late bool showCounty;

  @override
  void initState() {
    super.initState();
    selectedProvinceIndex = widget.initProvinceIndex;
    selectedCityIndex = widget.initCityIndex;
    selectedCountyIndex = widget.initCountyIndex;
    showCounty = widget.showCounty;

    cities = provinces[selectedProvinceIndex].children ?? [];
    counties = cities.length > selectedCityIndex
        ? (cities[selectedCityIndex].children ?? [])
        : [];

    provinceController =
        FixedExtentScrollController(initialItem: selectedProvinceIndex);
    cityController =
        FixedExtentScrollController(initialItem: selectedCityIndex);
    countyController =
        FixedExtentScrollController(initialItem: selectedCountyIndex);

    tempAreaInfo = AreaInfo(
      provinces.length > selectedProvinceIndex
          ? provinces[selectedProvinceIndex]
          : null,
      cities.length > selectedCityIndex ? cities[selectedCityIndex] : null,
      counties.length > selectedCountyIndex
          ? counties[selectedCountyIndex]
          : null,
      selectedProvinceIndex,
      selectedCityIndex,
      selectedCountyIndex,
    );
  }

  ///给父组件传递结果
  void _passParams() {
    setState(() {
      tempAreaInfo = AreaInfo(
        provinces.length > selectedProvinceIndex
            ? provinces[selectedProvinceIndex]
            : null,
        cities.length > selectedCityIndex ? cities[selectedCityIndex] : null,
        counties.length > selectedCountyIndex
            ? counties[selectedCountyIndex]
            : null,
        selectedProvinceIndex,
        selectedCityIndex,
        selectedCountyIndex,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = <Widget>[
      Expanded(
        flex: 1,
        child: CupertinoPicker(
          backgroundColor: Colors.white,
          diameterRatio: 1.1,
          scrollController: provinceController,
          itemExtent: 48.0,
          onSelectedItemChanged: (position) {
            setState(() {
              selectedProvinceIndex = position;
              cities = provinces[selectedProvinceIndex].children ?? [];
              selectedCityIndex = 0;

              counties = cities.length > selectedCityIndex
                  ? cities[selectedCityIndex].children ?? []
                  : [];
              selectedProvinceIndex = 0;
            });
            cityController.jumpToItem(0);
            countyController.jumpToItem(0);
            _passParams();
          },
          children: _createEachItem(provinces),
        ),
      ),
      Expanded(
        flex: 1,
        child: CupertinoPicker(
          backgroundColor: Colors.white,
          scrollController: cityController,
          itemExtent: 48.0,
          onSelectedItemChanged: (position) {
            setState(() {
              selectedCityIndex = position;
              selectedCountyIndex = 0;
              counties = cities[selectedCityIndex].children ?? [];
            });
            countyController.jumpToItem(0);
            _passParams();
          },
          children: _createEachItem(cities),
        ),
      ),
    ];
    if (showCounty) {
      list.add(Expanded(
        flex: 1,
        child: CupertinoPicker(
          backgroundColor: Colors.white,
          scrollController: countyController,
          itemExtent: 48.0,
          onSelectedItemChanged: (position) {
            selectedCountyIndex = position;
            _passParams();
          },
          children: _createEachItem(counties),
        ),
      ));
    }
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
//                GestureDetector(
//                  onTap: () {
//                    Navigator.of(context).pop();
//                  },
//                  child: Text('取消'),
//                ),
                SizedBox(
                  width: 50.0,
                ),
                Flexible(
                  child: Text('请选择区域'),
                ),
                GestureDetector(
                  onTap: () {
                    widget.onSelect(tempAreaInfo);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 50.0,
                    height: 25.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    ),
                    child: Text(
                      '确定',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: list,
            ),
          )
        ],
      ),
    );
  }
}

List<Widget> _createEachItem(List<AreaModel> data) {
  List<Widget> target = [];

  for (AreaModel item in data) {
    target.add(Center(
      child: Text(
        item.name ?? '',
        style: TextStyle(fontSize: 14.0),
      ),
    ));
  }

  if (target.length == 0) {
    target.add(Center());
  }

  return target;
}
