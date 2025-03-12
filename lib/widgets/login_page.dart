import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF004E92), Color(0xFF000428)], // Gradient blue background
          ),
        ),
        child: Center(
          child: SingleChildScrollView( // Wrap with SingleChildScrollView for keyboard overflow
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Align to the top
              children: <Widget>[
                const SizedBox(height: 80), // Adjust spacing as needed
                const CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('../../assets/rk.jpg'), // Replace with your logo
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                    style: GoogleFonts.lato(fontSize: 18, color: Colors.white), // White text
                    decoration: InputDecoration(
                      hintText: 'Korisnicko ime',
                      hintStyle: GoogleFonts.lato(fontSize: 18, color: Colors.white70), // Grey hint
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54), // White underline
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // White focused underline
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                    obscureText: true, // Hide password characters
                    style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Lozinka',
                      hintStyle: GoogleFonts.lato(fontSize: 18, color: Colors.white70),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector( // Make "Create Profile" clickable
                  onTap: () {
                    // Navigate to the create profile page
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProfilePage()));
                  },
                  child: Text(
                    'Napravi nalog',
                    style: GoogleFonts.lato(fontSize: 18, color: Colors.blue),
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