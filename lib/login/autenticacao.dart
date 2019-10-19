import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class Atenticacao {
  final _fireBase = FirebaseAuth.instance;

//   Future<bool> isSignedIn() async {
//   final currentUser = await _auth.currentUser();
//   return currentUser != null;
// }

// Future<String> getUser() async {
//   return (await _auth.currentUser()).email;
// }

//   Future<bool> logarPorEmail(String verificacao , String codugoSms) async {
//   //  final logimResultado = await _fireBase.signInWithPhoneNumber(verificationId: verificacao,smsCode: codugoSms);
//   //  if (logimResultado?.uid != null) {
//   //    return true;

//   //  }else {
//   //    return false;
//   //  }

//   }

  Future<void> signOut() async {
    _googleSignIn.signOut();
    return Future.wait([
      _auth.signOut(),
      // _googleSignIn.signOut(),
    ]);
  }

  Future<String> loginUser(String email, String password) async {
    try {
      //print(password);print(password);
      AuthResult result = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      print('pppppppppppppppp  :  ooooooo    : ' +
          result.additionalUserInfo.toString());
   //   print(result.user.uid);

      return result.user.uid;
    } catch (e) {
      print(e.code + "   :    " + e.message);
      throw new AuthException(e.code, e.message);
    }
  }

  Future<String> signUp(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
        
      );
      return result.user.uid;
    } catch (e) {
      // print(e.code + "   :    " + e.message);
      throw new AuthException(e.code, e.message);
    }
  }

// Future<FirebaseUser> _handleSignIn() async {
//   final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//   final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//   final AuthCredential credential = GoogleAuthProvider.getCredential(
//     accessToken: googleAuth.accessToken,
//     idToken: googleAuth.idToken,
//   );

//   final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
//   print("signed in " + user.displayName);
//   return user;
// }

  Future verificarFone(String numeroCel) async {
    //  await _fireBase.verifyPhoneNumber(
    //    phoneNumber: numeroCel,
    //    timeout: Duration(seconds: 3),
    //    codeAutoRetrievalTimeout: (time){
    //      print(time);
    //    },
    //    verificationCompleted: (vv){
    //      print("ver complete");
    //    },
    //    verificationFailed: (aut){
    //      print('ggggggggddddddddddddd');
    //    },
    //    codeSent: (String verified,[int forceResend]) {
    //      print('vistooooooooooooooooo;');
    //      print(verified);
    //    },
    //  );
  }
}
