import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monawpaty/src/shared/styles/colors.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfo extends StatefulWidget {
  const AppInfo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AppInfoState();
  }
}

class AppInfoState extends State<AppInfo> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget _infoTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle.isEmpty ? 'Not set' : subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_forward))
        ],
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text("حول التطبيق"),
        titleTextStyle: TextStyle(
            fontFamily: GoogleFonts.cairo().fontFamily,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17),
      ),
      body: Column(
        children: <Widget>[
          _infoTile('App name', _packageInfo.appName),
          _infoTile('Package name', _packageInfo.packageName),
          _infoTile('App version', _packageInfo.version),
          _infoTile('Build Number', _packageInfo.buildNumber),
          const ListTile(
            title: Text("Powered by"),
            subtitle:
                Text(" Saeed Alskaf \n Abdalkafi Albrejawi \n Hamza Alekhwan"),
          )
        ],
      ),
    );
  }
}
