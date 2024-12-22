import 'package:flutter/material.dart';
import 'package:task/core/custom_snackbar.dart';
import 'package:task/feat/home/presentation/pages/home_page.dart';
import 'package:task/feat/map/presentation/cubit/map_cubit.dart';
import 'package:task/feat/map/presentation/pages/map_page/map_page.dart';
import 'package:task/feat/table/presentation/pages/table_page.dart';
import 'package:task/feat/table/table_data_model.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: CustomSnackbar.scaffoldMessengerKey,
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        TablePage.routeName: (context) => TablePage(
              tableDataModel: TableDataModel.mock(),
            ),
        MapPage.routeName: (context) => MapPage(
              mapCubit: MapCubit(),
            ),
      },
    );
  }
}
