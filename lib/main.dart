import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'screens/main_screen.dart';
import 'screens/hospital_detail_screen.dart';
import 'screens/search_screen.dart';
import 'screens/filter_screen.dart';
import 'models/hospital.dart';
import 'constants/api_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 환경 변수 로드
  await dotenv.load(fileName: '.env');

  // HIRA API 키 설정
  ApiConstants.hiraApiKey = dotenv.env['HIRA_API_KEY'];

  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '메디게이션',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(),
      onGenerateRoute: (settings) {
        // 라우트 처리
        switch (settings.name) {
          case '/hospital-detail':
            final hospital = settings.arguments as Hospital;
            return MaterialPageRoute(
              builder: (context) => HospitalDetailScreen(hospital: hospital),
            );
          case '/search':
            return MaterialPageRoute(
              builder: (context) => const SearchScreen(),
            );
          case '/filter':
            return MaterialPageRoute(
              builder: (context) => const FilterScreen(),
            );
          default:
            return null;
        }
      },
    );
  }
}
