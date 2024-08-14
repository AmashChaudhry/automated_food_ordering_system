import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';
import '../signup/signup_screen.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
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
            label: const Text('Sign-In with Google'),
          ),
        ),
        TextButton(
          onPressed: (){
            Navigator.pop(context);
            Get.to(() => const SignupScreen());
          },
          child: Text.rich(
            TextSpan(
              text: 'Not a member yet?',
              style: Theme.of(context).textTheme.titleSmall,
              children: const [
                TextSpan(
                  text: ' Sign Up',
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
