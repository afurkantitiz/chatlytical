import 'package:chatlytical/app/tab_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCustomNavigationBar extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> pageCreator;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  const MyCustomNavigationBar(
      {Key key,
      @required this.currentTab,
      @required this.onSelectedTab,
      @required this.pageCreator,
      @required this.navigatorKeys})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBuilder: (context, index) {
        final showItem = TabItem.values[index];

        return CupertinoTabView(
          builder: (context) {
            return pageCreator[showItem];
          },
          navigatorKey: navigatorKeys[showItem],
        );
      },
      tabBar: CupertinoTabBar(
        items: [
          _navItemCreate(TabItem.Users),
          _navItemCreate(TabItem.Profile),
        ],
        onTap: (index) => onSelectedTab(TabItem.values[index]),
      ),
    );
  }

  BottomNavigationBarItem _navItemCreate(TabItem tabItem) {
    final createTab = TabItemData.allTabs[tabItem];

    return BottomNavigationBarItem(
      icon: Icon(createTab.icon),
      label: createTab.label,
    );
  }
}
