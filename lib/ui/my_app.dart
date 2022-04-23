import 'package:f_chat_template/ui/controllers/chat_room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/authentication_controller.dart';
import 'controllers/chat_controller.dart';
import 'firebase_cental.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ChatController());
    Get.put(AuthenticationController());
    Get.put(ChatRoomController());

    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Firebase demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const FirebaseCentral());
  }
}
