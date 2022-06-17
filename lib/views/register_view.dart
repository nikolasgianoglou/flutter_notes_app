import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import 'package:mynotes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Enter your password here'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(email: email, password: password);
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              }on WeakPasswordAuthException{
                await showErrorDialog(context, 'Weak password');
              }on EmailAlreadyInUseAuthException{
                await showErrorDialog(context, 'Email is already in use');
              }on InvalidEmailAuthException{
                await showErrorDialog(context, 'This is a invalid email');
              }on GenericAuthException{
                await showErrorDialog(context, "Failed to register");
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Already Registered? Login here!'))
        ],
      ),
    );
  }

//   @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: const Text("Register"),
//     ),
//     body: FutureBuilder(
//       future: Firebase.initializeApp(
//           options: DefaultFirebaseOptions.currentPlatform),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.done:
//             // TODO: Handle this case.
//             return Column(
//               children: [
//                 TextField(
//                   controller: _email,
//                   enableSuggestions: false,
//                   autocorrect: false,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: const InputDecoration(
//                       hintText: 'Enter your email here'),
//                 ),
//                 TextField(
//                   controller: _password,
//                   obscureText: true,
//                   enableSuggestions: false,
//                   autocorrect: false,
//                   decoration: const InputDecoration(
//                       hintText: 'Enter your password here'),
//                 ),
//                 TextButton(
//                   onPressed: () async {
//                     final email = _email.text;
//                     final password = _password.text;
//                     try {
//                       UserCredential credential = await FirebaseAuth.instance
//                           .createUserWithEmailAndPassword(
//                               email: email, password: password);
//                     } on FirebaseAuthException catch (e) {
//                       if (e.code == 'weak-password') {
//                         print('weak password');
//                       } else if (e.code == 'email-already-in-use') {
//                         print('email-already-in-use');
//                       } else if (e.code == 'invalid-email') {
//                         print('invalid-email');
//                       }
//                     }
//                   },
//                   child: const Text("Register"),
//                 ),
//               ],
//             );
//           default:
//             return Text("Loading...");
//         }
//       },
//     ),
//   );
// }
}
