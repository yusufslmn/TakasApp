import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/advertise_modal.dart';

Future<AdsModal> getAdsDetails(String adsId) async {
  final db = FirebaseFirestore.instance;
  final snapshot =
      await db.collection("ads").where("adsID", isEqualTo: adsId).get();
  final adsData = snapshot.docs.map((e) => AdsModal.fromSnapshot(e)).single;
  return adsData;
}

Stream<QuerySnapshot> getAllAds() {
  final db = FirebaseFirestore.instance;
  return db.collection("ads").snapshots();
}

Future<List<AdsModal>> getUserAds(String? userID) async {
  final db = FirebaseFirestore.instance;
  final snapshot =
      await db.collection("ads").where("userID", isEqualTo: userID).get();
  final adsData = snapshot.docs.map((e) => AdsModal.fromSnapshot(e)).toList();
  return adsData;
}

Future<List<AdsModal>> getSearch(String? search) async {
  final db = FirebaseFirestore.instance;
  final List<AdsModal> newList = [];
  final snapshot = await db.collection("ads").get();
  final adsData = snapshot.docs.map((e) => AdsModal.fromSnapshot(e)).toList();
  for (int i = 0; i < adsData.length; i++) {
    if (adsData[i].adsName.toLowerCase().contains(search!.toLowerCase())) {
      newList.add(adsData[i]);
    }
  }
  return newList;
}

Future<List<AdsModal>> getCategoryAds(String category) async {
  final db = FirebaseFirestore.instance;
  final snapshot = await db
      .collection("ads")
      .where("adsCategory", isEqualTo: category)
      .get();
  final adsData = snapshot.docs.map((e) => AdsModal.fromSnapshot(e)).toList();
  return adsData;
}

Future<void> deleteAds(String adsId) async {
  final db = FirebaseFirestore.instance;
  await db.collection("ads").doc(adsId).delete();
}
