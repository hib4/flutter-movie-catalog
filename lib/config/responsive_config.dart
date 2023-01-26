import 'package:flutter/cupertino.dart';

bool isLandscape(BuildContext context) =>
    MediaQuery.of(context).size.height < 400;
