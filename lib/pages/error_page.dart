import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_rounded,
              size: 120,
            ),
            Text(
              "errorpage.error_title".tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                "errorpage.error_subtitle".tr(),
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Gap(10),
            Container(
              height: 40,
              width: 120,
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(10000),
              ),
              clipBehavior: Clip.hardEdge,
              child: TextButton(
                onPressed: () {
                  Modular.to.navigate('/home');
                },
                style: TextButton.styleFrom(backgroundColor: Colors.white),
                child: Text(
                  "errorpage.go_home_button".tr(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
