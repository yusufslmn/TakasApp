import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:takasapp/pages/custom_profile.dart';
import 'package:takasapp/pages/profile.dart';
import 'package:takasapp/utility/project_colors.dart';
import 'package:takasapp/utility/project_padding.dart';
import '../services/ads_services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../services/auth_services.dart';

// ignore: must_be_immutable
class AdvertiseDetail extends StatefulWidget {
  AdvertiseDetail({super.key, required this.adsID});
  String adsID;

  @override
  State<AdvertiseDetail> createState() => _AdvertiseDetailState();
}

class _AdvertiseDetailState extends State<AdvertiseDetail> {
  final userDefaultImage =
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";
  final controller = PageController();
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "İlan Detayı",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: ProjectColor.mainColor,
        ),
        body: FutureBuilder(
          future: getAdsDetails(widget.adsID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                var list = snapshot.data!.imagesUrl;
                return Container(
                  height: height,
                  child: Padding(
                    padding: ProjectPadding.allPadding,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: height * 0.4,
                            child: PageView.builder(
                              controller: controller,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.imagesUrl.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  child: Image.network(list[index]),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: ProjectPadding.allPadding,
                            child: SmoothPageIndicator(
                              controller: controller,
                              count: snapshot.data!.imagesUrl.length,
                              effect: const ScrollingDotsEffect(
                                  dotHeight: 16,
                                  dotWidth: 16,
                                  fixedCenter: true),
                            ),
                          ),
                          customListTile(
                              customTitleText(snapshot.data!.adsName),
                              customTitleText(snapshot.data!.adsPrice + "₺")),
                          ListTile(
                            shape: StadiumBorder(),
                            tileColor: const Color.fromARGB(255, 194, 194, 194),
                            title: AuthService()
                                .getUserName(snapshot.data!.userID),
                            leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(userDefaultImage)),
                            trailing: IconButton(
                                onPressed: () {
                                  final auth = FirebaseAuth.instance;
                                  auth.currentUser!.uid == snapshot.data!.userID
                                      ? Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => Profile()))
                                      : Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CustomProfile(
                                                    userID:
                                                        snapshot.data!.userID,
                                                  )));
                                },
                                icon: Icon(CupertinoIcons.right_chevron)),
                          ),
                          customListTile(
                              Text("Kategori"), Text(snapshot.data!.category)),
                          customListTile(
                              Text("Durumu"), Text(snapshot.data!.status)),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: ProjectPadding.allPadding,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Açıklama",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    snapshot.data!.adsSituation,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                return const Center(child: Text("bir şeyler yanlış gitti..."));
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

ListTile customListTile(Text title, Widget subtitle) {
  return ListTile(
    title: title,
    trailing: subtitle,
    tileColor: Color.fromARGB(255, 247, 244, 244),
  );
}

Text customTitleText(String title) {
  return Text(
    title,
    style: TextStyle(
        color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
  );
}

Text customTrailingText(String text) {
  return Text(
    text,
  );
}
