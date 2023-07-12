import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:takasapp/pages/ads_view/ads_custom/homeads.dart';
import 'package:takasapp/utility/project_colors.dart';
import 'package:takasapp/utility/project_padding.dart';

import '../ads_view/ads_custom/category_ads.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    FutureAds();
    super.initState();
  }

  String searchString = "Takaslamak istediğiniz her şey...";
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: ProjectPadding.allPadding,
            child: TextTop(controller: controller, searchString: searchString),
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
                    Expanded(child: FutureAds()),
                  ],
                ),
              ))
        ],
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
              onPressed: () {},
            ),
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
