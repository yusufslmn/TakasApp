import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takasapp/pages/ads_view/ads_custom/ads_search.dart';
import 'package:takasapp/services/home_provider.dart';
import 'package:takasapp/utility/project_colors.dart';
import 'package:takasapp/utility/project_padding.dart';
import '../ads_view/ads_custom/advertise_detail.dart';
import '../ads_view/ads_custom/category_ads.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    ref.read(homeProvider).notifications.connectNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: ProjectPadding.allPadding,
            child: TextTop(
                controller: ref.watch(homeProvider).controller,
                searchString: ref.watch(homeProvider).searchString),
          ),
          Expanded(
              flex: 3,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return customCategoryContainer(index, context);
                  })),
          Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        child: const Padding(
                          padding: ProjectPadding.mediumHorizontal,
                          child: Text("Aktif İlanlar",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        )),
                    const Divider(
                      thickness: 1,
                    ),
                    Expanded(
                        child: StreamBuilder(
                      stream: ref.watch(homeProvider).getAllAds(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final adsList = snapshot.data!.docs
                              .map((document) =>
                                  _buildAdsItem(document, context, height))
                              .toList();
                          return GridView(
                            controller:
                                ref.watch(homeProvider).scrollController,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5),
                            shrinkWrap: true,
                            addAutomaticKeepAlives: true,
                            dragStartBehavior: DragStartBehavior.start,
                            children: adsList,
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    )),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildAdsItem(DocumentSnapshot document, context, height) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AdvertiseDetail(
                  adsName: data["adsName"],
                  adsID: data["adsID"],
                  userID: data["userID"],
                )));
      },
      child: SizedBox(
        height: height * 0.4,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 2,
          color: const Color.fromARGB(255, 243, 242, 242),
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: Padding(
                  padding: ProjectPadding.allPadding,
                  child: Image.network(
                    data["imagesURL"].first,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
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
                          data["adsName"] as String,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textWidthBasis: TextWidthBasis.parent,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(right: 10, left: 6),
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          data["adsPrice"] + "₺" as String,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
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
  }
}

class TextTop extends StatelessWidget {
  const TextTop({
    super.key,
    required this.controller,
    required this.searchString,
  });

  final TextEditingController controller;
  final String searchString;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return SizedBox(
      height: height * 0.06,
      child: TextField(
        controller: controller,
        maxLines: 1,
        cursorHeight: 15,
        decoration: InputDecoration(
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ProjectColor.mainColor)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                    color: ProjectColor.mainColor, style: BorderStyle.solid)),
            suffixIconColor: ProjectColor.mainColor,
            prefixIconColor: ProjectColor.mainColor,
            filled: true,
            prefixIcon: IconButton(
                icon: const Icon(
                  CupertinoIcons.search,
                ),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Search(
                          search: controller.text,
                        )))),
            suffixIcon: IconButton(
              icon: const Icon(
                CupertinoIcons.bell_fill,
              ),
              onPressed: () {},
            ),
            hintText: searchString,
            hintStyle: const TextStyle(fontSize: 10),
            alignLabelWithHint: true),
      ),
    );
  }
}

List<String> imagespath = [
  "images/telefon.png",
  "images/chairs.png",
  "images/elektronik.png",
  "images/car.png",
  "images/giyim.png",
  "images/spor.png"
];

List<String> categoryName = [
  "Telefon",
  "Eşya",
  "Elektronik",
  "Araç",
  "Giyim",
  "Spor"
];
List<Color?> colors = [
  Colors.yellowAccent[700],
  Colors.redAccent,
  Colors.lightGreen,
  Colors.blueAccent,
  Colors.teal,
  Colors.pinkAccent
];

InkWell customCategoryContainer(int index, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CategoryAds(
                categoryName: categoryName[index],
              )));
    },
    child: Column(
      children: [
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: colors[index],
                  borderRadius: BorderRadius.circular(35)),
              child: Image.asset(
                imagespath[index],
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(categoryName[index],
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        )
      ],
    ),
  );
}
