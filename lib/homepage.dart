import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final items = List<String>.generate(20, (i) => "item$i");
  ScrollController scrollController = ScrollController();
  bool isFAB = false;
  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset > 10) {
        setState(() {
          isFAB = true;
        });
      } else {
        setState(() {
          isFAB = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildListview(),
      floatingActionButton: isFAB ? buildExtendedFAB() : buildFAB(),
    );
  }

  Widget buildListview() => ListView.builder(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            // ignore: unnecessary_string_interpolations
            title: Text('${items[index]}'),
          );
        },
      );
}

AppBar buildAppBar() => AppBar(
      title: const Text('Gmail FAB Animation'),
    );

Widget buildExtendedFAB() => FloatingActionButton.extended(
      onPressed: () {},
      icon: const Icon(Icons.edit),
      label: const Center(
        child: Text(
          'Compose',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
Widget buildFAB() => AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
      height: 50,
      width: 50,
      child: FloatingActionButton.extended(
        onPressed: () {},
        label: const SizedBox(),
        icon: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Icon(Icons.edit),
        ),
      ),
    );
