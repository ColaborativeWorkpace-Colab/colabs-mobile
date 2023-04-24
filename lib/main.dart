import 'package:colabs_mobile/controllers/authenticator.dart';
import 'package:colabs_mobile/screens/login.dart';
import 'package:colabs_mobile/screens/home.dart';
import 'package:colabs_mobile/screens/signup.dart';
import 'package:colabs_mobile/themes/default_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const ColabsApp());
}

class ColabsApp extends StatelessWidget {
  const ColabsApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<Authenticator>(create: (_) => Authenticator()),
      ],
      builder: (BuildContext context, _){
        Authenticator auth = Provider.of<Authenticator>(context);

        return MaterialApp(
          title: 'Colabs',
          theme: defaultTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: auth.isUserAuthorized ? '/' : '/login',
          routes: <String, Widget Function(BuildContext)>{
            '/': (_) => const HomeScreen(),
            '/login': (_) => LoginScreen(),
            '/signup': (_) => SignupScreen(),
          }
        );
      }
    );
  }
}
