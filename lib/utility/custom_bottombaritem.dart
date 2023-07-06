import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<String> iconName = ["Ana Sayfa", "Mesajlarım", "İlan Ver", "Profil"];

BottomNavigationBarItem bottomitem(var icon, String name, var activeIcon) {
  return BottomNavigationBarItem(
    icon: icon,
    label: name,
    activeIcon: activeIcon,
  );
}
