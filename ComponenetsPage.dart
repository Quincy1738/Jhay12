import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComponentPage extends StatelessWidget {
  final String title;
  final bool isDarkMode;

  const ComponentPage({
    required this.title,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Color(0xFF2194F4),
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        title: Text(
          title,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black, // Correct icon color
          ),
          onPressed: () {
            Navigator.pop(context); // Back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView( // Make entire body scrollable to avoid overflow
        child: Center(
          child: title == "Capacitor"
              ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20), // Add some space from the top
              Image.asset(
                'lib/assets/8.jpg',
                width: 550, // Adjust width to moderate size
                height: 350, // Adjust height to moderate size
                fit: BoxFit.contain, // Ensure the image fits well without distortion
              ),
              SizedBox(height: 20), // Add some space between the image and description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add horizontal padding to avoid text too close to edges
                child: Text(
                  'A capacitor is a two-terminal electronic component used to store electrical energy in an electric field. It consists of two conductive plates separated by an insulating material called a dielectric. The stored energy can be released when needed. Capacitors are commonly used for filtering, smoothing power supply voltages, energy storage, and signal coupling in various circuits.',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.3, // Reduced line height to bring lines closer
                  ),
                  textAlign: TextAlign.justify, // Align text neatly
                ),
              ),
            ],
          )
              : Container(), // You can add content for other components here
        ),
      ),
    );
  }
}
