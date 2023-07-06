import 'package:flutter/material.dart';

import '../services/ads_services.dart';
import '../services/model/advertise_modal.dart';
import '../utility/project_padding.dart';
import 'advertise_detail.dart';

// ignore: must_be_immutable
class FutureAds extends StatelessWidget {
  FutureAds({super.key});
  Future<List<AdsModal>> _stream() async {
    return await getAllAds();
  }

  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return FutureBuilder<List<AdsModal>>(
      future: _stream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return GridView.builder(
              controller: controller,
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
