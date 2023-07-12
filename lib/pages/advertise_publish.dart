import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:takasapp/pages/selectImage.dart';
import 'package:takasapp/utility/custom_textformfield.dart';
import 'package:takasapp/utility/project_colors.dart';
import 'dart:core';
import '../services/model/advertise_modal.dart';

class Advertise extends StatefulWidget {
  const Advertise({super.key});

  @override
  State<Advertise> createState() => _AdvertiseState();
}

class _AdvertiseState extends State<Advertise> {
  final category = [
    "Telefon",
    "Eşya",
    "Elektronik",
    "Araç",
    "Giyim",
    "Spor",
  ];
  final adsStatus = [
    "Kullanılmamış",
    "Az Kullanılmış",
    "Yıpranmış",
    "Kötü Durumda",
  ];
  // ignore: unused_field
  final _formKey = GlobalKey<FormState>();
  String? _selectedVal2;
  String? _selectedVal1;
  TextEditingController adsName = TextEditingController();
  TextEditingController adsSitutation = TextEditingController();
  TextEditingController adsPrice = TextEditingController();
  String? adsnameValidate(String? name) {
    if (name!.isEmpty) {
      return 'İlan ismi boş olamaz !';
    }
    return null;
  }

  String? adsSituationValidate(String? value) {
    return (value!.isNotEmpty && value.length > 10)
        ? null
        : '10 Karakterden küçük olamaz!';
  }

  String? adsPriceValidate(String? value) {
    return (value!.isNotEmpty) ? null : 'Fiyat Giriniz!';
  }

  String? dropValidate(String? value) {
    return value == null ? "Seçim Yapınız" : null;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: dropDown1(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: dropDown2(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: customTextFormField(
                        validate: adsnameValidate,
                        name: "İlan Başlığı",
                        customController: adsName),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: customTextFormField(
                        validate: adsSituationValidate,
                        name: "Ürün Hakkında...",
                        customController: adsSitutation,
                        value: 5),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: customTextFormField(
                        validate: adsPriceValidate,
                        name: "Ürün Fiyatı...",
                        customController: adsPrice,
                        type: TextInputType.number,
                        tl: "₺"),
                  ),
                  SizedBox(
                    width: width * 0.9,
                    height: height * 0.06,
                    child: customButton(ProjectColor.mainColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton customButton(Color colors) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100))),
          backgroundColor: colors,
        ),
        onPressed: () {
          var uniqName = DateTime.now().millisecondsSinceEpoch.toString();
          if (_formKey.currentState!.validate()) {
            final auth = FirebaseAuth.instance;
            var modal = AdsModal(
                adsID: uniqName,
                adsSituation: adsSitutation.text,
                status: _selectedVal2!,
                adsName: adsName.text,
                category: _selectedVal1!,
                imagesUrl: [],
                adsPrice: adsPrice.text,
                userID: auth.currentUser!.uid);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SelectImage(
                      modal: modal,
                    )));
          }
        },
        child: const Text("İlerle"));
  }

  DropdownButtonFormField<String> dropDown2() {
    return DropdownButtonFormField(
      validator: dropValidate,
      hint: const Text("Ürünün Durumu..."),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      items: adsStatus
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
          .toList(),
      onChanged: (val1) {
        setState(() {
          _selectedVal2 = val1!;
        });
      },
    );
  }

  DropdownButtonFormField<String> dropDown1() {
    return DropdownButtonFormField(
      validator: dropValidate,
      hint: const Text(
        "Ürünün Kategorisi...",
        style: TextStyle(),
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      items: category
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
          .toList(),
      onChanged: (val) {
        setState(() {
          _selectedVal1 = val!;
        });
      },
    );
  }
}
