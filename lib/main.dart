import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/data.dart';
import 'package:flutter_application_2/data/repo/repository.dart';
import 'package:flutter_application_2/data/source/hive_task_Source.dart';
import 'package:flutter_application_2/screens/home/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

const taskBoxName = 'tasks';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<Task>(taskBoxName);
  runApp(ChangeNotifierProvider<Repository<Task>>(
      create: (context) =>
          Repository<Task>(HiveTaskDataSource(Hive.box(taskBoxName))),
      child: const MyApp()));
}

const Color primaryColor = Color(0xff794CFF);
const lowPriorityColor = Color(0xff3BE1F1);
const normalPriorityColor = Color(0xffF09819);
const highPriorityColor = primaryColor;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xff1D2830);
    const secondaryTextColor = Color(0xffAFBED0);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: InputBorder.none,
              labelStyle: TextStyle(
                fontSize: 14,
                color: secondaryTextColor,
              ),
              prefixIconColor: secondaryTextColor),
          textTheme: GoogleFonts.poppinsTextTheme(
            const TextTheme(
                titleLarge:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                bodyLarge:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ),
          colorScheme: const ColorScheme.light(
              primary: primaryColor,
              primaryContainer: Color(0xff5C0AFF),
              background: Color(0xffF3F5F8),
              onBackground: primaryTextColor,
              onSurface: primaryTextColor,
              secondary: primaryColor,
              onSecondary: secondaryTextColor,
              onPrimary: Colors.white),
        ),
        home: MyHomePage());
  }
}
