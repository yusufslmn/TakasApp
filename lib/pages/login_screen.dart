import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:takasapp/pages/referance.dart';
import 'package:takasapp/pages/register_screen.dart';
import 'package:takasapp/utility/project_colors.dart';

import '../services/auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          dragStartBehavior: DragStartBehavior.start,
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: [
                imageLogin(width, height),
                textLogin(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: textFormFieldEmail(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: textFormFieldPassword(),
                ),
                SizedBox(
                  width: width * 0.9,
                  height: height * 0.06,
                  child: customButton(ProjectColor.mainColor),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 2,
                  indent: 15,
                  endIndent: 15,
                ),
                SizedBox(
                  width: width * 0.9,
                  height: height * 0.06,
                  child: customButton1(
                    ProjectColor.googleButton,
                  ),
                ),
                const ButtonRow()
              ],
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
          AuthService().signIn(context,
              email: _emailController.text, password: _passwordController.text);
        },
        child: const Text("Giriş Yap"));
  }

  ElevatedButton customButton1(Color colors) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100))),
          backgroundColor: colors,
        ),
        onPressed: () async {
          await AuthService().signInWithGoogle().then((value) async {
            if (value != null) {
              showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                        alignment: Alignment.center,
                        title: Center(child: Text("Hoşgeldiniz")),
                      ));
              await AuthService().registerGoogleUser(user: value.user);
              // ignore: use_build_context_synchronously
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Referance()));
            }

            if (value == null) {
              // ignore: use_build_context_synchronously
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            }
            return null;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/google.png", width: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text("Google İle Giriş Yap"),
            ),
          ],
        ));
  }

  TextFormField textFormFieldEmail() {
    return TextFormField(
      controller: _emailController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Lütfen geçerli email giriniz !";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        label: const Text("Email"),
      ),
    );
  }

  TextFormField textFormFieldPassword() {
    return TextFormField(
      obscureText: obscure,
      controller: _passwordController,
      validator: (value) {
        if (value!.length < 7) {
          return "Lütfen 7 karakterden uzun bir parola giriniz";
        }
        return null;
      },
      decoration: InputDecoration(
        suffixIcon: IconButton(
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
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        label: const Text("Password"),
      ),
    );
  }

  Container imageLogin(double width, double height) {
    return Container(
      width: width * 0.8,
      height: height * 0.45,
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: AssetImage(
            "images/login1.png",
          ))),
    );
  }

  Padding textLogin() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Giriş Yap",
        style: GoogleFonts.pacifico(
          fontSize: 25,
        ),
      ),
    );
  }
}

class ButtonRow extends StatelessWidget {
  const ButtonRow({
    super.key,
  });
  final String password = 'Parolamı Unuttum';
  final String signUp = 'Kaydol';
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
            onPressed: () {},
            child: Text(
              password,
              style: TextStyle(color: ProjectColor.grey),
            )),
        TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RegisterScreen()));
            },
            child: Text(
              signUp,
              style: TextStyle(color: ProjectColor.googleButton),
            )),
      ],
    );
  }
}
