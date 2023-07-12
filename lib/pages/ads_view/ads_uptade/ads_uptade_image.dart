// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:takasapp/pages/home_view/referance.dart';
import 'package:takasapp/services/uploadImage.dart';
import 'package:takasapp/utility/project_colors.dart';

// ignore: must_be_immutable
class UptadeImage extends StatefulWidget {
  UptadeImage({super.key, required this.imagesUrl, required this.adsId});
  List<dynamic>? imagesUrl;
  String? adsId;

  @override
  State<UptadeImage> createState() => _UptadeImageState();
}

class _UptadeImageState extends State<UptadeImage> {
  final controller = MultiImagePickerController(
    maxImages: 10,
    withReadStream: true,
    allowedImageTypes: ['png', 'jpg', 'jpeg'],
  );
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: ProjectColor.mainColor,
        centerTitle: true,
        title: const Text("Resimleri Güncelle"),
      ),
      body: Column(children: [
        Expanded(
            flex: 4,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.imagesUrl!.length,
                itemBuilder: (context, index) {
                  return Stack(children: [
                    SizedBox(
                        height: height * 0.3,
                        child: Card(
                            child: Image.network(widget.imagesUrl![index]))),
                    Positioned(
                      right: 0,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              widget.imagesUrl!
                                  .remove(widget.imagesUrl![index]);
                            });
                          },
                          icon: Icon(
                            CupertinoIcons.clear,
                            color: ProjectColor.mainColor,
                          )),
                    )
                  ]);
                })),
        Expanded(
          flex: 6,
          child: MultiImagePickerView(
            onChange: (list) {
              debugPrint(list.toString());
            },
            controller: controller,
            padding: const EdgeInsets.all(10),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: width * 0.9,
                height: height * 0.07,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      backgroundColor: const Color.fromARGB(255, 255, 119, 7),
                    ),
                    onPressed: () async {
                      final images = controller.images.toList();
                      await uptadeImage(
                          images, widget.adsId!, widget.imagesUrl, context);

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Referance()));
                    },
                    child: const Text("Kaydet"))),
          ),
        ),
      ]),
    ));
  }
}
