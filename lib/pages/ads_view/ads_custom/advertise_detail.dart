import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:takasapp/pages/chat/chat_screen.dart';
import 'package:takasapp/pages/profile/custom_profile.dart';
import 'package:takasapp/utility/project_colors.dart';
import 'package:takasapp/utility/project_padding.dart';
import '../../../services/ads_services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore: must_be_immutable
class AdvertiseDetail extends StatefulWidget {
  AdvertiseDetail(
      {super.key,
      required this.adsID,
      required this.userID,
      required this.adsName});
  String adsID;
  String adsName;
  String? userID;

  @override
  State<AdvertiseDetail> createState() => _AdvertiseDetailState();
}

class _AdvertiseDetailState extends State<AdvertiseDetail> {
  String userImage =
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";
  final controller = PageController();
  String? userName;
  @override
  void initState() {
    super.initState();
    getUserDetails(widget.userID!);
  }

  getUserDetails(String userID) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userID)
        .get()
        .then((value) {
      setState(() {
        userName = value.data()?["name"] + " " + value.data()?["lastname"] ??
            "Bir şeyler yanlış gitti";
        if (value.data()?["profileImageUrl"] != null) {
          userImage = value.data()?["profileImageUrl"];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChatPage(
                      adsId: widget.adsID,
                      receiverUserID: widget.userID!,
                      chatName: widget.adsName,
                    )));
          },
          backgroundColor: ProjectColor.mainColor,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Mesaj Gönder",
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),
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
                return SizedBox(
                  height: height,
                  child: Padding(
                    padding: ProjectPadding.allPadding,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
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
                          const Divider(thickness: 1),
                          ListTile(
                              titleAlignment: ListTileTitleAlignment.center,
                              title: Container(
                                  padding: const EdgeInsets.only(right: 30),
                                  child:
                                      customTitleText(snapshot.data!.adsName)),
                              trailing: Container(
                                child: customTitleText(
                                    "${snapshot.data!.adsPrice}₺"),
                              )),
                          const Divider(thickness: 1),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CustomProfile(
                                            userID: snapshot.data!.userID,
                                          ))),
                              shape: const StadiumBorder(
                                  side: BorderSide(color: Colors.grey)),
                              tileColor: ProjectColor.mainColor,
                              title: Text(
                                userName!,
                                style: const TextStyle(color: Colors.black),
                              ),
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage(userImage)),
                              trailing: Icon(
                                CupertinoIcons.right_chevron,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: customListTile(
                                const Text(
                                  "Kategori",
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(snapshot.data!.category)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: customListTile(
                                const Text(
                                  "Durumu",
                                  style: TextStyle(
                                      overflow: TextOverflow.fade,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(snapshot.data!.status)),
                          ),
                          Container(
                            margin: ProjectPadding.mediumHorizontal,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: ProjectPadding.allPadding,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
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
                          ),
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
    shape: const StadiumBorder(side: BorderSide(color: Colors.grey)),
    title: title,
    trailing: subtitle,
    tileColor: const Color.fromARGB(255, 247, 244, 244),
  );
}

Text customTitleText(String title) {
  return Text(
    title,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(
        color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
  );
}

Text customTrailingText(String text) {
  return Text(
    text,
  );
}
