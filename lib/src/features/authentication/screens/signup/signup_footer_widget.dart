import 'package:automated_food_ordering_system/src/features/authentication/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';

class SignupFooterWidget extends StatelessWidget {
  const SignupFooterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('OR'),
        const SizedBox(height: formHeight - 10.0),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: Image(image: AssetImage(googleLogo), width: 20.0),
            onPressed: (){},
            label: const Text('Sign-Up with Google'),
          ),
        ),
        TextButton(
          onPressed: (){
            Navigator.pop(context);
            Get.to(() => const LoginScreen());
          },
          child: Text.rich(
            TextSpan(
              text: 'Already a member?',
              style: Theme.of(context).textTheme.titleSmall,
              children: const [
                TextSpan(
                  text: ' Log In',
                  style: TextStyle(color: Colors.orange),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
