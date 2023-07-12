import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:takasapp/pages/home_view/referance.dart';
import 'package:takasapp/services/location_service.dart';
import 'package:takasapp/services/model/advertise_modal.dart';
import 'package:takasapp/utility/project_colors.dart';
import '../../../services/uploadImage.dart';

// ignore: must_be_immutable
class PublishAdvertise extends StatefulWidget {
  PublishAdvertise({super.key, required this.modal, required this.controller});
  AdsModal modal;
  MultiImagePickerController controller;
  @override
  State<PublishAdvertise> createState() => _PublishAdvertiseState();
}

class _PublishAdvertiseState extends State<PublishAdvertise> {
  String? city, country;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("İlan Konumu"),
        backgroundColor: ProjectColor.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "İlanın Konum Bilgileri",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                shape:
                    const StadiumBorder(side: BorderSide(color: Colors.black)),
                leading: Text(
                  "$city,$country",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                trailing: TextButton(
                  onPressed: () => getLocation(),
                  child: const Text("konum getir"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: width * 0.9,
                  height: height * 0.06,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        backgroundColor: const Color.fromARGB(255, 255, 119, 7),
                      ),
                      onPressed: () async {
                        if (city == null) {
                          return showDialog(
                            context: context,
                            builder: (context) => const AlertDialog(
                                title: Text(
                                    "Lütfen Konum Getir Butonunu Kullanız!")),
                          );
                        }
                        await uploadImage(
                            widget.controller.images, widget.modal);
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const Referance()),
                            (Route<dynamic> route) => true);
                      },
                      child: const Text("Yayınla"))),
            ),
          ],
        ),
      ),
    ));
  }

  void getLocation() async {
    final service = LocationService();
    final locationData = await service.getCurrentLocation();

    if (locationData != null) {
      final placeMark = await service.getPlaceMark(locationData);

      setState(() {
        country = placeMark!.country;
        city = placeMark.administrativeArea;
      });
    }
  }
}
