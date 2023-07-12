import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:takasapp/services/auth_services.dart';
import 'package:takasapp/utility/custom_textformfield.dart';
import '../services/model/users_modal.dart';
import 'referance.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final EdgeInsets padding =
      const EdgeInsets.symmetric(vertical: 25.0, horizontal: 4);
  final users = Users(
      name: Controller._nameController.text,
      lastname: Controller._lastnameController.text,
      email: Controller._emailController.text,
      password: Controller._passwordController.text);
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: padding,
                    child: customTextFormField(
                        name: formName[0],
                        customController: Controller._nameController),
                  ),
                  Padding(
                    padding: padding,
                    child: customTextFormField(
                        name: formName[1],
                        customController: Controller._lastnameController),
                  ),
                  Padding(
                    padding: padding,
                    child: customTextFormField(
                        validate: emailValidator,
                        name: formName[2],
                        customController: Controller._emailController),
                  ),
                  Padding(
                    padding: padding,
                    child: customTextFormField(
                        validate: passwordValidator,
                        name: formName[3],
                        customController: Controller._passwordController,
                        obscure: obscure,
                        func: IconButton(
                          onPressed: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                          isSelected: true,
                          icon: obscure
                              ? const Icon(
                                  CupertinoIcons.eye,
                                  color: Colors.black,
                                )
                              : const Icon(
                                  CupertinoIcons.eye_slash_fill,
                                  color: Colors.black,
                                ),
                        )),
                  ),
                  Padding(
                    padding: padding,
                    child: customTextFormField(
                        name: formName[4],
                        customController: Controller._repasswordController,
                        obscure: true),
                  ),
                  SizedBox(
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
                          onPressed: () {
                            final user = Users(
                                name: Controller._nameController.text,
                                lastname: Controller._lastnameController.text,
                                email: Controller._emailController.text,
                                password: Controller._passwordController.text);

                            if (formKey.currentState!.validate() &&
                                (Controller._passwordController.text ==
                                    Controller._repasswordController.text)) {
                              AuthService().signUp(
                                  name: user.name,
                                  lastname: user.lastname,
                                  email: user.email,
                                  password: user.password!);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const Referance()));
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
                          child: const Text("Kaydol"))),
                ],
              )),
        ),
      ),
    );
  }
}

List<String> formName = [
  "Ad",
  "Soyad",
  "Email",
  "Parola",
  "Parolayı Tekrar Giriniz",
];

class Controller {
  static final TextEditingController _nameController = TextEditingController();
  static final TextEditingController _lastnameController =
      TextEditingController();
  static final TextEditingController _emailController = TextEditingController();
  static final TextEditingController _passwordController =
      TextEditingController();
  static final TextEditingController _repasswordController =
      TextEditingController();
}

String? emailValidator(String? email) {
  final bool isValid = EmailValidator.validate(email!);
  return (isValid && email.isNotEmpty) ? null : 'Doğrulanmamış email !';
}

String? passwordValidator(String? password) {
  return (password!.length > 7) ? null : 'Parolanız 7 haneden küçük !';
}
