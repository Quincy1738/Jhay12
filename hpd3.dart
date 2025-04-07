import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ComponentPage.dart';

class hpd3 extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  hpd3({required this.onThemeChanged, required this.isDarkMode});

  @override
  _hpd3State createState() => _hpd3State();
}

class _hpd3State extends State<hpd3> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _animation2;
  TextEditingController _searchController = TextEditingController();
  late bool _isDarkMode;

  List<Map<String, String>> allComponents = [
    {
      "title": "Resistor",
      "description": "A passive electrical component that resists current.",
      "image": "lib/assets/1.jpg"
    },
    {
      "title": "Capacitor",
      "description": "Stores electrical energy temporarily.",
      "image": "lib/assets/2.jpg"
    },
    {
      "title": "Transistor",
      "description": "Used to amplify or switch electronic signals.",
      "image": "lib/assets/3.jpg"
    },
    {
      "title": "Diode",
      "description": "Allows current to flow in one direction only.",
      "image": "lib/assets/4.jpg"
    },
    {
      "title": "Inductor",
      "description": "Stores energy in a magnetic field when electric current flows through it.",
      "image": "lib/assets/5.jpg"
    },
    {
      "title": "Relay",
      "description": "Electrically operated switch.",
      "image": "lib/assets/6.jpg"
    },
    {
      "title": "Rectifier",
      "description": "Converts AC to DC.",
      "image": "lib/assets/7.jpg"
    },
  ];

  List<Map<String, String>> filteredComponents = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _controller, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {});
      });

    _animation2 = Tween<double>(begin: 0, end: -30).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    filteredComponents = allComponents;
    _isDarkMode = widget.isDarkMode;
  }

  void _filterComponents(String query) {
    setState(() {
      filteredComponents = allComponents.where((component) {
        return component["title"]!
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    });
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    widget.onThemeChanged(value);
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: _isDarkMode ? Colors.grey[900] : Color(0xFF2194F4),
        elevation: 0,
        title: Text(
          'Electronics Dictionary',
          style: TextStyle(
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode
                  ? CupertinoIcons.sun_max_fill
                  : CupertinoIcons.moon_fill,
              color: _isDarkMode ? Colors.yellow : Colors.white,
            ),
            onPressed: () => _toggleDarkMode(!_isDarkMode),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterComponents,
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Search for components...',
                hintStyle: TextStyle(
                  color: _isDarkMode ? Colors.grey : Colors.black54,
                ),
                prefixIcon: Icon(CupertinoIcons.search,
                    color: _isDarkMode ? Colors.white : Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: _isDarkMode ? Colors.white : Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: _isDarkMode ? Colors.white : Colors.black),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.only(top: 15),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // This creates two columns
                crossAxisSpacing: 10, // Space between columns
                mainAxisSpacing: 10, // Space between rows
                childAspectRatio: 1.0, // Aspect ratio of the grid items
              ),
              itemCount: filteredComponents.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: cards(filteredComponents[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget cards(Map<String, String> component) {
    return Opacity(
      opacity: _animation.value,
      child: Transform.translate(
        offset: Offset(0, _animation2.value),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComponentPage(
                  title: component["title"]!,
                  isDarkMode: _isDarkMode,
                ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _isDarkMode ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _isDarkMode
                      ? Colors.black45
                      : Colors.grey.shade300,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(component["image"]!, width: 50, height: 50),
                SizedBox(height: 10),
                Text(
                  component["title"]!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
