import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:takasapp/pages/advertise_detail.dart';
import 'package:takasapp/pages/login_screen.dart';
import 'package:takasapp/services/ads_services.dart';
import 'package:takasapp/services/auth_services.dart';
import 'package:takasapp/services/model/advertise_modal.dart';
import 'package:takasapp/utility/project_padding.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final userDefaultImage =
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";
  final userDefaultAbout = "Hakkımda...";
  final currentUser = FirebaseAuth.instance.currentUser;
  Future<List<AdsModal>>? _stream;
  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getUserAds(currentUser!.uid));
    super.initState();
    _stream = getUserAds(currentUser!.uid);
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
                  image:
                      DecorationImage(image: NetworkImage(userDefaultImage))),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthService().getUserName(currentUser!.uid),
              Padding(
                padding: ProjectPadding.mediumVertical,
                child: Text(
                  userDefaultAbout,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.settings,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
                  final auth = FirebaseAuth.instance;
                  auth.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (Route<dynamic> route) => true);
                },
                icon: const Icon(
                  CupertinoIcons.square_arrow_right,
                  color: Colors.black,
                )),
          ],
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
                              adsID: snapshot.data![index].adsID,
                            )));
                  },
                  child: SizedBox(
                    height: height * 0.3,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 2,
                      color: const Color.fromARGB(255, 243, 242, 242),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  textAlign: TextAlign.left,
                                  snapshot.data![index].adsName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  textAlign: TextAlign.left,
                                  "${snapshot.data![index].adsPrice} ₺",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
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