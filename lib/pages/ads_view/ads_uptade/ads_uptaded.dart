import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:takasapp/pages/ads_view/ads_uptade/ads_uptade_image.dart';
import 'package:takasapp/utility/project_colors.dart';

// ignore: must_be_immutable
class AdsUpdate extends StatefulWidget {
  AdsUpdate({super.key, required this.adsID});
  String? adsID;
  @override
  State<AdsUpdate> createState() => _AdsUpdateState();
}

class _AdsUpdateState extends State<AdsUpdate> {
  final adsNameController = TextEditingController();
  final adsSituationController = TextEditingController();
  final adsPriceController = TextEditingController();

  Icon icon1 = const Icon(CupertinoIcons.pencil_ellipsis_rectangle);
  Icon icon2 = const Icon(CupertinoIcons.pencil_ellipsis_rectangle);
  Icon icon3 = const Icon(CupertinoIcons.pencil_ellipsis_rectangle);

  String? adsName;
  String? adsSituation;
  String? adsPrice;
  List<dynamic>? imagesList;

  @override
  void initState() {
    getAdsDetails(widget.adsID!);
    super.initState();
  }

  getAdsDetails(String userID) {
    FirebaseFirestore.instance
        .collection("ads")
        .doc(widget.adsID)
        .get()
        .then((value) {
      setState(() {
        adsName = value.data()?["adsName"];
        adsSituation = value.data()?["adsSituation"];
        adsPrice = value.data()?["adsPrice"];
        imagesList = value.data()?["imagesURL"];
      });
    });
  }

  String? adsnameValidate(String? name) {
    if (name!.isEmpty) {
      return 'İlan ismi boş olamaz !';
    }
    return null;
  }

  String? adsSituationValidate(String? value) {
    return (value!.isNotEmpty && value.length > 10)
        ? null
        : '10 Karakterden küçük olamaz!';
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("İlan Güncelleme"),
        backgroundColor: ProjectColor.mainColor,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "İlan Adı",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.disabled,
                  onTap: () {
                    setState(() {
                      icon1 = const Icon(CupertinoIcons.check_mark);
                    });
                  },
                  controller: adsNameController,
                  decoration: InputDecoration(
                    hintText: adsName,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            adsName = adsNameController.text;
                            icon1 = const Icon(
                                CupertinoIcons.pencil_ellipsis_rectangle);
                          });
                        },
                        icon: icon1),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "İlan Açıklaması",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.disabled,
                  maxLines: 5,
                  onTap: () {
                    setState(() {
                      icon2 = const Icon(CupertinoIcons.check_mark);
                    });
                  },
                  controller: adsSituationController,
                  decoration: InputDecoration(
                    hintText: adsSituation,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            adsSituation = adsSituationController.text;
                            icon2 = const Icon(
                                CupertinoIcons.pencil_ellipsis_rectangle);
                          });
                        },
                        icon: icon2),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "İlan Fiyatı",
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                  keyboardType: TextInputType.number,
                  controller: adsPriceController,
                  decoration: InputDecoration(
                    hintText: adsPrice,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            adsPrice = adsPriceController.text;
                            // ignore: avoid_print
                            print(adsPrice);
                            icon3 = const Icon(
                                CupertinoIcons.pencil_ellipsis_rectangle);
                          });
                        },
                        icon: icon3),
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
                              .collection("ads")
                              .doc(widget.adsID)
                              .update({
                            "adsName": adsName,
                            "adsSituation": adsSituation,
                            "adsPrice": adsPrice
                          });

                          // ignore: use_build_context_synchronously
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UptadeImage(
                                    imagesUrl: imagesList,
                                    adsId: widget.adsID!,
                                  )));
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
