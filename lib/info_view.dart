import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'info_view_model.dart';

class InfoView extends StatelessWidget {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    InfoViewModel infoVM = context.read<InfoViewModel>().getInfo();
    return Scaffold(
      body: Column(
        children: _ui(infoVM),
      ),
    );
  }

  _ui(InfoViewModel infoVM) {
    if (infoVM.loading) {
      return [const Text("loading...")];
    }
    return [Text(infoVM.info.version), Text(infoVM.info.buildNumber)];
  }
}
