import 'package:area_picker/src/model/area_model.dart';
import 'package:area_picker/src/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _provices = loadData();

class AreaInfo {
  final AreaModel provice;
  final AreaModel city;
  final AreaModel county;

  int get proviceId => provice.id;
  int get cityId => city.id;
  int get countyId => county.id;

  final int proviceIndex;
  final int cityIndex;
  final int countyIndex;

  String get address =>
      '${provice.name ?? ''}${city.name ?? ''}${county.name ?? ''}';

  AreaInfo(
    this.provice,
    this.city,
    this.county,
    this.proviceIndex,
    this.cityIndex,
    this.countyIndex,
  );
}

typedef AreaSelectedCallback = void Function(AreaInfo areaInfo);

class AreaSelection extends StatefulWidget {
  final AreaSelectedCallback onSelect;
  final int initProviceIndex;
  final int initCityIndex;
  final int initCountyIndex;
  final bool showConty;

  AreaSelection({
    Key key,
    @required this.onSelect,
    this.initProviceIndex,
    this.initCityIndex,
    this.initCountyIndex,
    this.showConty = true,
  }) : super(key: key);

  @override
  _AreaSelectionState createState() => _AreaSelectionState();
}

class _AreaSelectionState extends State<AreaSelection> {
  List<AreaModel> provices = _provices;
  List<AreaModel> citys = [];
  List<AreaModel> county = [];

  ///选中的省份的index
  int selectedProvice = 0;

  ///选中的市的index
  int selectedCity = 0;

  ///选中的区的index
  int selectedCounty = 0;

  ///定义省份控制器
  FixedExtentScrollController proviceCotroller;

  ///定义市控制器
  FixedExtentScrollController cityController;

  ///定义区控制器
  FixedExtentScrollController countyController;

  /// 选择变化时候的值
//  Map tempAreaInfo;
  AreaInfo tempAreaInfo;

  bool showConty;

  @override
  void initState() {
    super.initState();
    selectedProvice = widget.initProviceIndex ?? 0;
    selectedCity = widget.initCityIndex ?? 0;
    selectedCounty = widget.initCountyIndex ?? 0;
    showConty = widget.showConty ?? true;

    citys = provices[selectedProvice].childs;
    county = citys[selectedCity].childs;
    proviceCotroller = new FixedExtentScrollController(
        initialItem: widget.initProviceIndex ?? 0);
    cityController =
        new FixedExtentScrollController(initialItem: widget.initCityIndex ?? 0);
    countyController = new FixedExtentScrollController(
        initialItem: widget.initCountyIndex ?? 0);
    tempAreaInfo = AreaInfo(
      provices[selectedProvice],
      citys[selectedCity],
      county[selectedCounty],
      selectedProvice,
      selectedCity,
      selectedCounty,
    );
  }

  ///给父组件传递结果
  void passParams() {
    setState(() {
      tempAreaInfo = AreaInfo(
        provices[selectedProvice],
        citys[selectedCity],
        county[selectedCounty],
        selectedProvice,
        selectedCity,
        selectedCounty,
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
          scrollController: proviceCotroller,
          itemExtent: 48.0,
          onSelectedItemChanged: (position) {
            setState(() {
              selectedProvice = position;
              citys = provices[selectedProvice].childs;
              selectedCity = 0;
              county = citys[selectedCity].childs;
            });
            cityController.jumpToItem(0);
            countyController.jumpToItem(0);
            passParams();
          },
          children: createEachItem(provices),
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
              selectedCity = position;
              selectedCounty = 0;
              county = citys[selectedCity].childs;
            });
            countyController.jumpToItem(0);
            passParams();
          },
          children: createEachItem(citys),
        ),
      ),
    ];
    if (showConty) {
      list.add(Expanded(
        flex: 1,
        child: CupertinoPicker(
          backgroundColor: Colors.white,
          scrollController: countyController,
          itemExtent: 48.0,
          onSelectedItemChanged: (position) {
            selectedCounty = position;
            passParams();
          },
          children: createEachItem(county),
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

List<Widget> createEachItem(List<AreaModel> data) {
  List<Widget> target = [];

  for (AreaModel item in data) {
    target.add(Container(
      padding: EdgeInsets.only(top: 14.0, bottom: 10.0),
      child: Text(
        item.name ?? '',
        style: TextStyle(fontSize: 14.0),
      ),
    ));
  }

  return target;
}
