import 'package:credit_debit/views/denied_permissions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:credit_debit/utils/router.dart';
import 'package:credit_debit/utils/constants.dart';
import 'package:credit_debit/viewmodels/customer_state.dart';
import 'package:credit_debit/viewmodels/transaction_state.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    _checkPermissionStatus(); // Call function to request permissions on startup
  }

  bool _hasPermission = false;
  Future<void> _requestPermissions() async {
    final DeviceInfoPlugin info = DeviceInfoPlugin();
    final AndroidDeviceInfo androidDeviceInfo = await info.androidInfo;
    final int androidVersion = int.parse(androidDeviceInfo.version.release);
    if (androidVersion >= 13) {
      final request = await [
        Permission.videos,
        Permission.photos,
        // Permission.audio,
      ].request();
      setState(() {
        _hasPermission = request.values
            .every((status) => status == PermissionStatus.granted);
      });
    } else {
      PermissionStatus storagePermission = await Permission.storage.request();
      if (storagePermission.isGranted) {
        setState(() {
          _hasPermission = true;
        });
      } else if (storagePermission.isDenied) {
        setState(() {
          _hasPermission = false;
        });
      }
    }
  }

  Future<void> _checkPermissionStatus() async {
    PermissionStatus storagePermission = await Permission.storage.status;
    if (storagePermission.isGranted) {
      setState(() {
        _hasPermission = true; // Permission granted, proceed with the app
      });
    } else {
      _requestPermissions(); // Request permission
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomerState()),
        ChangeNotifierProvider(create: (_) => TransactionState()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightBlueAccent,
          ),
          datePickerTheme: const DatePickerThemeData(
            dividerColor: Colors.blue,
            shadowColor: Colors.blue,
            elevation: 15,
            headerBackgroundColor: Colors.lightBlueAccent,
            backgroundColor: kScaffoldColor,
            headerForegroundColor: Colors.white,
          ),
          useMaterial3: true,
        ),
        routerConfig: MyRoutes.routes,
        builder: (context, child) {
          // Block the app if permission is not granted
          if (!_hasPermission) {
            return PermissionDeniedPage(onGrant: _checkPermissionStatus);
          }
          return child!;
        },
      ),
    );
  }
}
