// ignore_for_file: file_names
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'model/advertise_modal.dart';

Future<void> uploadImage(Iterable<ImageFile> controller, AdsModal modal) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  Reference referenceRoot = FirebaseStorage.instance.ref();
  Reference referenceDirImage = referenceRoot
      .child('images')
      .child(currentUser!.uid)
      .child(modal.adsName.toString());
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
          .child(modal.adsName.toString())
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
