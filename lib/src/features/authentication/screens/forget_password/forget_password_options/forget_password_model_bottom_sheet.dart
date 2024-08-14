import 'package:automated_food_ordering_system/src/features/authentication/screens/forget_password/forget_password_mail/forget_password_mail.dart';
import 'package:automated_food_ordering_system/src/features/authentication/screens/forget_password/forget_password_phone/forget_password_phone.dart';
import 'package:flutter/material.dart';
import '../../../../../constants/sizes.dart';
import 'forget_password_btn_widget.dart';

class ForgetPasswordScreen{
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (context) => Container(
        padding: const EdgeInsets.all(defaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Make Selection!',
                style: Theme.of(context).textTheme.displayMedium),
            Text(
                'Select one of the options given below to reset your password.',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 30.0),
            ForgetPasswordButtonWidget(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgetPasswordMailScreen()),
                );
              },
              title: 'E-mail',
              subtitle: 'Reset via email verification.',
              btnIcon: Icons.mail_outline_rounded,
            ),
            const SizedBox(height: 20.0),
            ForgetPasswordButtonWidget(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgetPasswordPhoneScreen()),
                );
              },
              title: 'Phone No.',
              subtitle: 'Reset via Phone verification.',
              btnIcon: Icons.mobile_friendly_rounded,
            ),
          ],
        ),
      ),
    );
  }
}