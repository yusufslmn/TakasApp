import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:takasapp/pages/home_view/referance.dart';
import 'package:takasapp/services/uploadImage.dart';
import '../../utility/project_padding.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  String userImage =
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";
  String userAbout = " Hakkımda...";
  Icon icon1 = const Icon(CupertinoIcons.pencil_ellipsis_rectangle);
  Icon icon2 = const Icon(CupertinoIcons.pencil_ellipsis_rectangle);
  Icon icon3 = const Icon(CupertinoIcons.pencil_ellipsis_rectangle);

  bool enabled = false;
  final user = FirebaseAuth.instance;
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final aboutController = TextEditingController();
  String? userName;
  String? lastname;
  @override
  void initState() {
    super.initState();
    getUserDetails(user.currentUser!.uid);
  }

  getUserDetails(String userID) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userID)
        .get()
        .then((value) {
      setState(() {
        userName = value.data()?["name"];
        lastname = value.data()?["lastname"];
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
        title: TextButton(
          onPressed: () async {
            ImagePicker imagePicker = ImagePicker();
            XFile? file =
                await imagePicker.pickImage(source: ImageSource.gallery);
            await uploadProfile(file);
            getUserDetails(user.currentUser!.uid);
          },
          child: const Text("Profil Resmini Düzenle"),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onTap: () {
                    setState(() {
                      icon1 = const Icon(CupertinoIcons.check_mark);
                    });
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: userName,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            userName = nameController.text;
                            icon1 = const Icon(
                                CupertinoIcons.pencil_ellipsis_rectangle);
                          });
                        },
                        icon: icon1),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onTap: () {
                    setState(() {
                      icon2 = const Icon(CupertinoIcons.check_mark);
                    });
                  },
                  controller: lastnameController,
                  decoration: InputDecoration(
                    hintText: lastname,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            lastname = lastnameController.text;
                            icon2 = const Icon(
                                CupertinoIcons.pencil_ellipsis_rectangle);
                          });
                        },
                        icon: icon2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onTap: () {
                    setState(() {
                      icon3 = const Icon(CupertinoIcons.check_mark);
                    });
                  },
                  controller: aboutController,
                  decoration: InputDecoration(
                    hintText: userAbout,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            userAbout = aboutController.text;
                            icon3 = const Icon(
                                CupertinoIcons.pencil_ellipsis_rectangle);
                          });
                        },
                        icon: icon3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: width * 0.9,
                    height: height * 0.07,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          backgroundColor:
                              const Color.fromARGB(255, 255, 119, 7),
                        ),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(user.currentUser!.uid)
                              .update({
                            "name": userName,
                            "lastname": lastname,
                            "about": userAbout
                          });
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Referance()));
                        },
                        child: const Text("Güncelle"))),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
