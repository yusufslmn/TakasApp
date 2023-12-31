import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:takasapp/pages/ads_view/ads_publish/advertise_publish.dart';
import 'package:takasapp/pages/chat/messages.dart';
import 'package:takasapp/pages/profile/profile.dart';
import 'package:takasapp/services/firebase_notification.dart';
import 'package:takasapp/utility/custom_bottombaritem.dart';
import 'package:takasapp/utility/project_colors.dart';
import 'home_page.dart';

// ignore: must_be_immutable
class Referance extends StatefulWidget {
  const Referance({
    super.key,
  });
  @override
  State<Referance> createState() => _ReferanceState();
}

class _ReferanceState extends State<Referance> {
  final FirebaseNotifications notifications = FirebaseNotifications();
  int currentindex = 0;
  final currentPage = <Widget>[
    const HomePage(),
    const Messages(),
    const Advertise(),
    const Profile()
  ];
  @override
  void initState() {
    notifications.connectNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
            selectedItemColor: ProjectColor.mainColor,
            showUnselectedLabels: true,
            currentIndex: currentindex,
            onTap: (index) {
              setState(() {
                currentindex = index;
              });
            },
            items: [
              bottomitem(
                  const Icon(CupertinoIcons.home, color: Colors.black),
                  iconName[0],
                  Icon(
                    CupertinoIcons.house_fill,
                    color: ProjectColor.mainColor,
                  )),
              bottomitem(
                  const Icon(CupertinoIcons.chat_bubble_2, color: Colors.black),
                  iconName[1],
                  Icon(CupertinoIcons.chat_bubble_2_fill,
                      color: ProjectColor.mainColor)),
              bottomitem(
                  const Icon(CupertinoIcons.rectangle_on_rectangle_angled,
                      color: Colors.black),
                  iconName[2],
                  Icon(CupertinoIcons.rectangle_fill_on_rectangle_angled_fill,
                      color: ProjectColor.mainColor)),
              bottomitem(
                  const Icon(CupertinoIcons.profile_circled,
                      color: Colors.black),
                  iconName[3],
                  Icon(CupertinoIcons.person_crop_circle_fill,
                      color: ProjectColor.mainColor)),
            ]),
        body: IndexedStack(
          index: currentindex,
          children: currentPage,
        ));
  }
}
