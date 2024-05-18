import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:netflix_1/screens/splash_screen.dart';


import 'signup.dart';
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String username = '';
  String password = '';
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  //
  Future<void> _signIn(String emailSignin ,String passwordSignin) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailSignin,
      password: passwordSignin,
      
    );
     
    print('Utilisateur connecté: ${userCredential.user?.email}');
    _passwordController.clear();
      _usernameController.clear();
      username = '';
      password = '';
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
    // Rediriger l'utilisateur vers une autre page ou effectuer d'autres actions après la connexion réussie
  } catch (e) {
    print('Erreur de connexion: $e');
    // Afficher un message d'erreur à l'utilisateur si nécessaire
  }
}


  //
  
  void _resetPassword(String emailReset) async {
    try {
      if(_validateEmail(emailReset)==null){
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailReset);
      print("email sent");
      }
      
     

    } catch (e) {
      print("erreu :$e");
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: (){
              _resetPassword(username);
        }
        , icon:const Icon(Icons.lock_reset_outlined))
        ],
        title: Container(
                  child: ClipOval(
                  child: Image.asset(
                  'bb.jpg',
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                ),
              ),
          
        ),
       
        backgroundColor: Color.fromARGB(212, 255, 39, 39),),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('netflex.jpg'), // Add a suitable background image in your assets
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign In',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red, fontFamily: 'Jokerman'),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    errorText: _emailError,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _emailError = _validateEmail(value);
                      username = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      
                    ),
                    errorText: _passwordError,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _passwordError = _validatePassword(value);
                      password = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  
                  onPressed: () {
                    if (_emailError == null && _passwordError == null  && password!='' && username!='') {
                      // Handle sign in logic here
                      //print("username: $username ,Password: $password");
                      _signIn(username, password);
                      
                      //accec authetication
                      /*Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SplashScreen(),
                          );
                        },
                      ),
                    );*/
                      //

                      
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text('Sign In', style: TextStyle(fontSize: 18)),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SignUpPage(),
                          );
                        },
                      ),
                    );
                  },
                  child: Text(
                    "Don't have an account ? Sign Up",
                    style: TextStyle(color: Colors.white, fontFamily: 'Tw Cen MT', ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter your password';
    }
    // Add any additional password validation logic here
    return null;
  }
}
