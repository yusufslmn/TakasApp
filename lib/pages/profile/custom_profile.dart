import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:takasapp/pages/ads_view/ads_custom/advertise_detail.dart';
import 'package:takasapp/services/ads_services.dart';
import 'package:takasapp/services/model/advertise_modal.dart';
import 'package:takasapp/utility/project_padding.dart';

// ignore: must_be_immutable
class CustomProfile extends StatefulWidget {
  CustomProfile({super.key, required this.userID});
  String userID;
  @override
  State<CustomProfile> createState() => _CustomProfile();
}

class _CustomProfile extends State<CustomProfile> {
  String userImage =
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";
  String userAbout = "Hakkımda...";
  Future<List<AdsModal>>? _stream;
  String? userName;
  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getUserAds(widget.userID));
    super.initState();

    _stream = getUserAds(widget.userID);
    getUserDetails(widget.userID);
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
        if (value.data()?["about"] != null) {
          userAbout = value.data()?["about"];
        }
        if (value.data()?["profileImageUrl"] != null) {
          userImage = value.data()?["profileImageUrl"];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: width * 0.3,
          toolbarHeight: height * 0.2,
          backgroundColor: const Color.fromARGB(0, 255, 255, 255),
          elevation: 0,
          leading: Padding(
            padding: ProjectPadding.mediumHorizontal,
            child: Container(
              height: height * 0.1,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: NetworkImage(userImage))),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName!,
                style: const TextStyle(color: Colors.black),
              ),
              Padding(
                padding: ProjectPadding.mediumVertical,
                child: Text(
                  userAbout,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: ProjectPadding.allPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "İlanlar",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(child: SizedBox(child: adsUsers(width, height))),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<AdsModal>> adsUsers(double width, double height) {
    return FutureBuilder(
      future: _stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5),
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdvertiseDetail(
                            adsName: snapshot.data![index].adsName,
                            adsID: snapshot.data![index].adsID,
                            userID: snapshot.data![index].userID)));
                  },
                  child: SizedBox(
                    height: height * 0.3,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 2,
                      color: const Color.fromARGB(255, 223, 222, 222),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 8,
                            child: Padding(
                              padding: ProjectPadding.allPadding,
                              child: Image.network(
                                snapshot.data![index].imagesUrl.first,
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 15),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      textAlign: TextAlign.left,
                                      snapshot.data![index].adsName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textWidthBasis: TextWidthBasis.parent,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(
                                        right: 10, left: 6),
                                    child: Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      "${snapshot.data![index].adsPrice} ₺",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
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
    );
  }
}
