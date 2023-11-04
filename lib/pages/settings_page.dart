import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              "settings.settings".tr(),
              style: TextStyle(
                // color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 30,
              ),
            ),
            floating: true,
            pinned: true,
            backgroundColor: Colors.black,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "settings.account".tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                //* Account part

                //* End account part
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "settings.general".tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                //* General part

                //* End general part
              ],
            ),
          ),
        ],
      ),
    );
  }
}
