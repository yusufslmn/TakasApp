import 'package:flutter/material.dart';
import 'package:takasapp/utility/project_colors.dart';

import '../services/ads_services.dart';
import '../services/model/advertise_modal.dart';
import '../utility/project_padding.dart';
import 'advertise_detail.dart';

// ignore: must_be_immutable
class CategoryAds extends StatefulWidget {
  CategoryAds({super.key, required this.categoryName});
  String? categoryName;
  @override
  State<CategoryAds> createState() => _CategoryAdsState();
}

class _CategoryAdsState extends State<CategoryAds> {
  Future<List<AdsModal>> _stream() async {
    return await getCategoryAds(widget.categoryName!);
  }

  ScrollController controller = ScrollController();
  @override
  void initState() {
    _stream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ProjectColor.mainColor,
          centerTitle: true,
          title: Text(widget.categoryName!),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<AdsModal>>(
            future: _stream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    controller: controller,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AdvertiseDetail(
                                    adsName: snapshot.data![index].adsName,
                                    adsID: snapshot.data![index].adsID,
                                    userID: snapshot.data![index].userID,
                                  )));
                        },
                        child: SizedBox(
                          height: height * 0.4,
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
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            textAlign: TextAlign.left,
                                            snapshot.data![index].adsName,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            textWidthBasis:
                                                TextWidthBasis.parent,
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
                  return const Center(
                      child: Text("bir şeyler yanlış gitti..."));
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
