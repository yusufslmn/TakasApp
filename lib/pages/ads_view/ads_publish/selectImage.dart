// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:takasapp/pages/ads_view/ads_publish/ads_location.dart';
import 'package:takasapp/services/model/advertise_modal.dart';
import 'package:takasapp/utility/project_colors.dart';

// ignore: must_be_immutable
class SelectImage extends StatefulWidget {
  SelectImage({Key? key, required this.modal}) : super(key: key);
  AdsModal modal;

  @override
  State<SelectImage> createState() => _SelectImage();
}

class _SelectImage extends State<SelectImage> {
  final controller = MultiImagePickerController(
    maxImages: 10,
    withReadStream: true,
    allowedImageTypes: ['png', 'jpg', 'jpeg'],
  );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            MultiImagePickerView(
              onChange: (list) {
                debugPrint(list.toString());
              },
              controller: controller,
              padding: const EdgeInsets.all(10),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: width * 0.9,
              height: height * 0.06,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    backgroundColor: ProjectColor.mainColor,
                  ),
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PublishAdvertise(
                              controller: controller,
                              modal: widget.modal,
                            )));
                  },
                  child: const Text("İlerle")),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: ProjectColor.mainColor,
        title: const Text('Fotoğrafları Seçiniz'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_upward),
            onPressed: () {
              final images = controller.images;
              // use these images
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(images.map((e) => e.name).toString())));
            },
          ),
        ],
      ),
    );
  }
}
