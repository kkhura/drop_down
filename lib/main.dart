import 'package:drop_down_sample/model/state_city_model.dart';
import 'package:drop_down_sample/profile_field_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_dropdown.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => ProfileFieldBloc(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController selectedStateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  late final ProfileFieldBloc profileFieldBloc;

  @override
  void initState() {
    profileFieldBloc = context.read<ProfileFieldBloc>();
    profileFieldBloc.add(LoadStates());
    super.initState();
  }

  @override
  void dispose() {
    selectedStateController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          BlocBuilder<ProfileFieldBloc, ProfileFieldState>(
            buildWhen: (previous, current) =>
                current == ProfileFieldState.stateState ||
                current == ProfileFieldState.stateLoaded,
            builder: (context, state) {
              return dropdownField(
                "State",
                "Select State",
                selectedStateController.text,
                profileFieldBloc.stateCityList?.getStates() ?? [],
                (value) {
                  selectedStateController.text = value ?? '';
                  cityController.text='';
                  profileFieldBloc.cityList.clear();
                  profileFieldBloc
                      .add(LoadCityData(selectedStateController.text));
                },
              );
            },
          ),
          BlocBuilder<ProfileFieldBloc, ProfileFieldState>(
            buildWhen: (previous, current) =>
                current == ProfileFieldState.cityLoaded ||
                current == ProfileFieldState.cityState,
            builder: (context, state) {
              return dropdownField(
                "City",
                "Select City",
                cityController.text,
                profileFieldBloc.cityList,
                (value) {
                  cityController.text = value ?? '';
                  profileFieldBloc
                      .add(UpdateField(ProfileFieldState.cityState));
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget dropdownField(
    String label,
    String hint,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(
          height: 6,
        ),
        BaseDropdown<String>(
          items: items,
          value: value,
          hintText: hint,
          itemToString: (item) => item,
          onChanged: onChanged,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
