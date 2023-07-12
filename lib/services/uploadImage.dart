// ignore_for_file: file_names, avoid_print
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'model/advertise_modal.dart';

Future<void> uploadImage(Iterable<ImageFile> controller, AdsModal modal) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  Reference referenceRoot = FirebaseStorage.instance.ref();
  Reference referenceDirImage = referenceRoot
      .child('images')
      .child(currentUser!.uid)
      .child(modal.adsID.toString());
  List<String> imagesURL = [];
  final images = controller.toList();

  for (int i = 0; i < images.length; i++) {
    try {
      Reference referenceImageToUpload = referenceDirImage.child("$i");
      await referenceImageToUpload.putFile(File(images[i].path as String));
      String getURL = await FirebaseStorage.instance
          .ref()
          .child('images')
          .child(currentUser.uid)
          .child(modal.adsID.toString())
          .child("$i")
          .getDownloadURL();
      imagesURL.add(getURL);
    } catch (e) {
      print(e);
    }
  }
  modal.imagesUrl = imagesURL;
  modal.adsUpload();
}

Future<void> uploadProfile(XFile? file) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  String? imagesURL;
  Reference referenceRoot = FirebaseStorage.instance.ref();
  Reference referenceDirImage =
      referenceRoot.child('profileImages').child(currentUser!.uid);

  try {
    Reference referenceImageToUpload = referenceDirImage.child("file");
    await referenceImageToUpload.putFile(File(file!.path));
    String getURL = await FirebaseStorage.instance
        .ref()
        .child('profileImages')
        .child(currentUser.uid)
        .child("file")
        .getDownloadURL();
    imagesURL = getURL;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .update({"profileImageUrl": imagesURL});
  } catch (e) {
    print(e);
  }
}

Future<void> uptadeImage(
    List<ImageFile> image, String adsId, List<dynamic>? list1, context) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  Reference referenceRoot = FirebaseStorage.instance.ref();
  Reference referenceDirImage =
      referenceRoot.child('uptaded').child(currentUser!.uid).child(adsId);
  List<String> list = [];
  print(image.length);
  for (int i = 0; i < image.length; i++) {
    try {
      Reference referenceImageToUpload = referenceDirImage.child("$i");
      await referenceImageToUpload.putFile(File(image[i].path as String));
      String getURL = await FirebaseStorage.instance
          .ref()
          .child('uptaded')
          .child(currentUser.uid)
          .child(adsId)
          .child("$i")
          .getDownloadURL();
      list.add(getURL);
    } catch (e) {
      showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                title: Text(e.toString()),
              )));
    }
  }

  list1!.addAll(list);

  print(list.length);
  print(list1.length);
  await FirebaseFirestore.instance
      .collection("ads")
      .doc(adsId)
      .update({"imagesURL": list1});
}
