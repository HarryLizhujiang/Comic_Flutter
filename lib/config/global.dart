import 'dart:convert';
import 'dart:io';
import 'package:comic_flutter/model/ComicHistory.dart';
import 'package:comic_flutter/model/DComic.dart';
import 'package:comic_flutter/router/routers.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:comic_flutter/utils/storage.dart';
import 'package:comic_flutter/router/Application.dart';
import 'package:comic_flutter/values/storages.dart';
import 'package:flutter/services.dart';

/// 全局配置
class Global {
  /// 是否第一次打开
  static bool isFirstOpen = false;

  /// init
  static Future init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();

    // 工具初
    await StorageUtil.init();

    // 初始化路由
    Router router = Router();
    Routers.configureRoutes(router);
    Application.router = router;
    // 读取设备第一次打开
    isFirstOpen = !StorageUtil().getBool(STORAGE_DEVICE_ALREADY_OPEN_KEY);
    if (isFirstOpen) {
      StorageUtil().setBool(STORAGE_DEVICE_ALREADY_OPEN_KEY, true);
      //初始化空关注第一次打开
      Map<String, DComic> list = new Map();
      StorageUtil().setJSON(COMIC_ID, json.encode(list));
      //初始化空历史记录
      // ignore: non_constant_identifier_names
      Map<String, ComicHistory> HistoryList = new Map();
      StorageUtil().setJSON(COMIC_HISTORYID, json.encode(HistoryList));
    }
    // android 状态栏为透明的沉浸
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle =
          SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}
