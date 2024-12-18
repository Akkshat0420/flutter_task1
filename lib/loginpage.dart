import 'package:flutter/material.dart';
//import 'package:flutter_task1/productform.dart';
import 'dart:convert';
import 'homepage.dart';
import 'package:http/http.dart' as http;

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC4A4C4),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            height: 700,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.network(
                        "https://as2.ftcdn.net/v2/jpg/03/86/51/03/1000_F_386510351_03Qk3je4FGnVLo4vXRdOpoDWfZjtmajd.jpg",
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Image.network(
                                  'https://cdn-icons-png.freepik.com/256/3296/3296464.png',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                        .hasMatch(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Image.network(
                                  'https://cdn-icons-png.freepik.com/256/4302/4302127.png',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Password',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    } else if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 160,
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w100),
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final email = _emailController
                                  .text; // Get email from input field
                              final password = _passwordController.text;
                              if (_formKey.currentState?.validate() ?? false) {
                                login(email, password);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Login successful'),
                                  ),
                                );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Homepage()));
                              }
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.blueAccent),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'OR',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w100),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(192, 250, 250, 250),
                              ),
                              child: Row(
                                children: [
                                  Image.network(
                                    'https://cdn-icons-png.freepik.com/256/13170/13170545.png?ga=GA1.1.622267497.1734445978&semt=ais_hybrid',
                                    width: 40,
                                    height: 30,
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    'Login with Google',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "New to Login? ",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Colors.blue, // Highlight with blue color
                                  fontWeight:
                                      FontWeight.bold, // Optional: make it bold
                                  decoration: TextDecoration
                                      .underline, // Optional: underline for emphasis
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse('https://reqres.in/api/login'); // API URL
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Set content type to JSON
        },
        body: jsonEncode({
          'email': email,
          'password': password, // Required fields for the API
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        print("Login successful! Token: $token");
        // Handle successful login (e.g., save token, navigate to the next page)
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        print("Error: ${data['error']}");
        // Handle invalid login (e.g., show error to user)
      } else {
        print("Unexpected error: ${response.statusCode}");
        // Handle unexpected responses
      }
    } catch (error) {
      print("An error occurred: $error");
      // Handle network or other errors
    }
  }
}
