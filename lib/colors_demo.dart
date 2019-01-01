// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

//item的高度
const double _itemHeight = 48.0;

class ColorsHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _allPalettes.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: const Text('调色板'),
          //顶部导航栏
          bottom: TabBar(
            isScrollable: true,
            //生成导航栏的每一个tab
            tabs: _allPalettes.map<Widget>((_Palette palette) => Tab(text: palette.name)
            ).toList(),
          ),
        ),
        //导航栏对应的页面
        body: TabBarView(
          children: _allPalettes.map<Widget>((_Palette palette) {
            return _PaletteTabView(colors: palette);
          }).toList(),
        ),
      ),
    );
  }
}
//Palette：调色板
class _Palette {
  _Palette({ this.name, this.primary, this.accent});

  final String name;
  final MaterialColor primary;
  //accent color
  //重点色;强调色;重点色彩
  final MaterialAccentColor accent;

}

//数据源
final List<_Palette> _allPalettes = <_Palette>[
  _Palette(name: 'RED', primary: Colors.red, accent: Colors.redAccent),
  _Palette(name: 'PINK', primary: Colors.pink, accent: Colors.pinkAccent),
  _Palette(name: 'PURPLE', primary: Colors.purple, accent: Colors.purpleAccent),
  _Palette(name: 'DEEP PURPLE', primary: Colors.deepPurple, accent: Colors.deepPurpleAccent),
  _Palette(name: 'INDIGO', primary: Colors.indigo, accent: Colors.indigoAccent),
  _Palette(name: 'BLUE', primary: Colors.blue, accent: Colors.blueAccent),
  _Palette(name: 'LIGHT BLUE', primary: Colors.lightBlue, accent: Colors.lightBlueAccent),
  _Palette(name: 'CYAN', primary: Colors.cyan, accent: Colors.cyanAccent),
  _Palette(name: 'TEAL', primary: Colors.teal, accent: Colors.tealAccent),
  _Palette(name: 'GREEN', primary: Colors.green, accent: Colors.greenAccent),
  _Palette(name: 'LIGHT GREEN', primary: Colors.lightGreen, accent: Colors.lightGreenAccent),
  _Palette(name: 'LIME', primary: Colors.lime, accent: Colors.limeAccent),
  _Palette(name: 'YELLOW', primary: Colors.yellow, accent: Colors.yellowAccent),
  _Palette(name: 'AMBER', primary: Colors.amber, accent: Colors.amberAccent),
  _Palette(name: 'ORANGE', primary: Colors.orange, accent: Colors.orangeAccent),
  _Palette(name: 'DEEP ORANGE', primary: Colors.deepOrange, accent: Colors.deepOrangeAccent),
  _Palette(name: 'BROWN', primary: Colors.brown),
  _Palette(name: 'GREY', primary: Colors.grey),
  _Palette(name: 'BLUE GREY', primary: Colors.blueGrey),
];


class _ColorItem extends StatelessWidget {
  const _ColorItem({
    Key key,
    @required this.index,
    @required this.color,
    this.prefix = '',
  }) : assert(index != null),
       assert(color != null),
       assert(prefix != null),
       super(key: key);

  final int index;
  final Color color;
  final String prefix;

  String colorString() => "#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}";

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Container(
        //因为在listView中已经设置了高度，所以这个高度相当于match_parent
        height: _itemHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //背景色
        color: color,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('$prefix $index'),
              Text(colorString()),
            ],
          ),
        ),
      ),
    );
  }
}

//每个tab对应的页面
class _PaletteTabView extends StatelessWidget {
  _PaletteTabView({
    Key key,
    @required this.colors,
  }) : assert(colors != null && colors.isValid),
       super(key: key);

  final _Palette colors;

  static const List<int> primaryKeys = <int>[50, 100, 200, 300, 400, 500, 600, 700, 800, 900];

  static const List<int> accentKeys = <int>[100, 200, 400, 700];

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle whiteTextStyle = textTheme.body1.copyWith(color: Colors.white);
    final TextStyle blackTextStyle = textTheme.body1.copyWith(color: Colors.black);
    final List<Widget> colorItems = primaryKeys.map<Widget>((int value) {
      return DefaultTextStyle(
        style: value > colors.threshold ? whiteTextStyle : blackTextStyle,
        child: _ColorItem(index: value, color: colors.primary[value],prefix: 'Primary Color'),
      );
    }).toList();

    if (colors.accent != null) {
      colorItems.addAll(accentKeys.map<Widget>((int index) {
        return DefaultTextStyle(
          style: index > colors.threshold ? whiteTextStyle : blackTextStyle,
          child: _ColorItem(index: index, color: colors.accent[index], prefix: 'AccentColor'),
        );
      }).toList());
    }

    return ListView(
      //设置item的高度
      itemExtent: _itemHeight,
      //<Widget>[]数组
      children: colorItems,
    );
  }
}

