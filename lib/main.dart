import 'package:diaries/components/bottom_nav_bar.dart';
import 'package:diaries/models/diarydatabase.dart';
import 'package:diaries/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Diarydatabase.initalize();
  await SharedPreferences.getInstance();
  runApp(
    const MyApp(),
    // TODO: Include the new provider in th multi provider
    // MultiProvider(
    //   providers: [],
    //   child: const MyApp(),
    // ),
    // ChangeNotifierProvider(
    //   create: (context) => Diarydatabase(),
    //   child: const MyApp(),
    // ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeChanger = ThemeChanger(); // Initialize the theme changer
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeChanger>(create: (_) => themeChanger),
        ChangeNotifierProvider<Diarydatabase>(create: (_) => Diarydatabase()),
      ],
      builder: (context, child) {
        final theme = context.watch<ThemeChanger>();
        return MaterialApp(home: const ButtomNavBar(), theme: theme.themeData);
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

// // Assuming these are your provider and theme files
// import 'package:diaries/providers/theme.dart'; // Your ThemeChanger class
// import 'package:diaries/models/diarydatabase.dart'; // Your Diarydatabase class
// import 'package:diaries/providers/theme/themes.dart'; // Your lightmode/darkmode definitions

// // You'll need your actual HomePage or initial screen
// import 'package:diaries/components/bottom_nav_bar.dart'; // Example: replace with your actual home page

// void main() async {
//   // 1. Ensure Flutter binding is initialized.
//   // This is crucial if you need to call platform-specific code (like SharedPreferences)
//   // before runApp().
//   WidgetsFlutterBinding.ensureInitialized();

//   // 2. Initialize SharedPreferences.
//   // This line gets the singleton instance of SharedPreferences.
//   // We're not explicitly using 'prefs' here, but the act of calling
//   // getInstance() ensures it's ready for subsequent calls within ThemeChanger.
//   // Alternatively, you could pass 'prefs' directly to ThemeChanger's constructor
//   // if you want to explicitly manage the instance, but for simple preferences,
//   // the singleton access within ThemeChanger is fine after this initial call.
//   await SharedPreferences.getInstance();

//   // 3. Create an instance of ThemeChanger.
//   // Its constructor will now safely call _loadThemePreference(),
//   // which internally uses SharedPreferences.getInstance() again.
//   final themeChanger = ThemeChanger();

//   // 4. Run the app with MultiProvider.
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => Diarydatabase()),
//         ChangeNotifierProvider(
//           create: (context) => themeChanger,
//         ), // Provide the pre-initialized instance
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Consume ThemeChanger to set the app's theme
//     return Consumer<ThemeChanger>(
//       builder: (context, themeChanger, child) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Diaries App', // Set a title for your app
//           theme:
//               themeChanger.themeData, // This will update when the theme changes
//           home: const ButtomNavBar(), // Your main home screen
//         );
//       },
//     );
//   }
// }
