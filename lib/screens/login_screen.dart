// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_otp/utils/colors.dart';
import 'package:mobile_otp/utils/utils.dart';
import 'package:mobile_otp/widgets/text_field_input.dart';
import 'package:pinput/pinput.dart';
import 'package:country_picker/country_picker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _otpSent = false; // New state variable to track OTP sent status
  final _phoneController = TextEditingController();
  late var _verificationId = "";
  Country? country;
  final auth = FirebaseAuth.instance;
  var _pin = "";

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country _country) {
          setState(() {
            country = _country;
          });
        });
  }

  void verifyOtp(String verificationId, String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await auth.signInWithCredential(credential);
      // Verification successful, you can navigate to the next screen or perform any necessary action.
      print('Verification Successful!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, 'Verification failed. ${e.message}');
    }
  }

  // Function to handle OTP sending logic
  void sendOtp() async {
    if (country != null && _phoneController.text.isNotEmpty) {
      String phoneNumber = _phoneController.text.trim();
      print('+${country!.phoneCode}$phoneNumber');

      try {
        await auth.verifyPhoneNumber(
          phoneNumber: '+${country!.phoneCode}$phoneNumber',
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            throw Exception(e.message);
          },
          codeSent: (String verificationId, int? resendToken) async {
            print('Code Sent! Verification ID: $verificationId');
            setState(() {
              _verificationId = verificationId;
              _otpSent = true;
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } on FirebaseAuthException catch (e) {
        showSnackBar(context, e.toString());
      }
    } else {
      showSnackBar(context, 'Fill out all the fields');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(137, 127, 255, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 42, 42, 43)),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(137, 127, 255, 1),
              Color.fromRGBO(137, 127, 255, 0.1),
             
              // Add your additional gradient color here
              // For example: Color.fromRGBO(100, 100, 255, 1),
              // Adjust the colors and stops according to your design
            ],
          ),
        ),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(width * 0.1),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "flaze",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                    ),
                    Text(
                      "tech",
                      style: TextStyle(fontSize: 50),
                    )
                  ],
                ),
                const Text(
                  "Sign In to continue ",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextButton(
                  onPressed: pickCountry,
                  child: const Text(
                    "Pick Country",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (country != null) Text('+${country!.phoneCode}'),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: width * 0.6,
                      child: TextFieldInput(
                        textInputType: TextInputType.phone,
                        textEditingController: _phoneController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Pinput(
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  length: 6,
                  showCursor: true,
                  onCompleted: (pin) {
                    if (_otpSent) {
                      // If OTP is sent, verify OTP
                      _pin = pin;
                    }
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () {
                    if (!_otpSent) {
                      // If OTP is not sent, send OTP
                      sendOtp();
                    } else {
                      verifyOtp(_verificationId, _pin);
                      // Handle verification logic here
                    }
                  },
                  child: Container(
                    width: width * 0.6,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      color: Color.fromRGBO(
                          137, 127, 255, 1), // Default color for "Send OTP"
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: primaryColor,
                          )
                        : Text(
                            _otpSent
                                ? 'Verify OTP'
                                : 'Send OTP', // Change text based on state
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Flexible(
                  flex: 2,
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
