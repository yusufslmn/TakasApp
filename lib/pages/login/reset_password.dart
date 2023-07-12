import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:takasapp/pages/login/login_screen.dart';
import 'package:takasapp/utility/project_colors.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Parolamı Unuttum"),
          centerTitle: true,
          backgroundColor: ProjectColor.mainColor,
        ),
        body: Form(
          autovalidateMode: AutovalidateMode.disabled,
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                    "Sıfırlamak istediğiniz hesabın emailini giriniz!"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: emailValidator,
                  autovalidateMode: AutovalidateMode.disabled,
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    hintText: "Email",
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
                          backgroundColor:
                              const Color.fromARGB(255, 255, 119, 7),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await resetPassword();
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    title:
                                        Text("Bilgilerinizi Kontrol Ediniz!"),
                                  );
                                });
                          }
                        },
                        child: const Text("Sıfırla"))),
              )
            ],
          ),
        ),
      ),
    );
  }

  String? emailValidator(String? email) {
    final bool isValid = EmailValidator.validate(email!);
    return (isValid && email.isNotEmpty) ? null : 'Doğrulanmamış email !';
  }

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _controller.text.trim());
      // ignore: use_build_context_synchronously
      await showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("Sıfırlama bağlantısı gönderildi"),
              ));
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.message!),
              ));
      Navigator.of(context).pop();
    }
  }
}
