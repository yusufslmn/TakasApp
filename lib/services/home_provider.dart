import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/ads_view/ads_custom/advertise_detail.dart';
import '../utility/project_padding.dart';
import 'ads_services.dart';
import 'firebase_notification.dart';

class HomeService extends ChangeNotifier {
  Stream<QuerySnapshot> getAllAds() {
    final db = FirebaseFirestore.instance;
    return db.collection("ads").snapshots();
  }

  final FirebaseNotifications notifications = FirebaseNotifications();
  String searchString = "Takaslamak istediğiniz her şey...";
  final controller = TextEditingController();
  ScrollController scrollController = ScrollController();
}

final homeProvider = ChangeNotifierProvider((ref) {
  return HomeService();
});
