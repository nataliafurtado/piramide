import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comportamentocoletivo/login/autenticacao.dart';
import 'package:comportamentocoletivo/model/carteira.dart';
import 'package:comportamentocoletivo/model/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends BlocBase {
  final BuildContext context;
  LoginBloc(this.context);
//  LoginBloc();

  // await _autenticacao.signOut();

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );
//ca-app-pub-4315692542852907~8105772849
//PIRÂMIDE COLETIVAca-app-pub-4315692542852907~8105772849
//bannerca-app-pub-4315692542852907/4611033356

//PIRÂMIDE COLETIVAca-app-pub-4315692542852907~8105772849
//intersticialca-app-pub-4315692542852907/8181794467

  GoogleSignInAccount _currentUser;

  final Atenticacao _autenticacao = Atenticacao();
  final db = Firestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _senhaCotroller = BehaviorSubject<String>();
  Observable<String> get senhaFluxo => _senhaCotroller.stream;
  Sink<String> get senhaEvent => _senhaCotroller.sink;

  final _senha2Cotroller = BehaviorSubject<String>();
  Observable<String> get senha2Fluxo => _senha2Cotroller.stream;
  Sink<String> get senha2Event => _senha2Cotroller.sink;

  final nomeCotroller = BehaviorSubject<String>();
  Observable<String> get nomeFluxo => nomeCotroller.stream;
  Sink<String> get nomeEvent => nomeCotroller.sink;

  final _emailController = BehaviorSubject<String>();
  Observable<String> get emailFluxo => _emailController.stream;
  Sink<String> get emailEvent => _emailController.sink;

  var controllerLoading = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get outLoading => controllerLoading.stream;

  // Future<String> onClickGoogle() async {
  //   String erro = '';
  //   try {
  //     _currentUser = await _googleSignIn.signIn();
  //   } catch (error) {
  //     erro = error;
  //     //  print(error);
  //   }

  //   if (_currentUser != null) {
  //     erro = null;
  //   }
  //   return erro;
  // }

  Future<String> garantirEstarLogadoGoolgle() async {
    String erro = 'Um erro ocorreu. ';
    GoogleSignInAccount user = _googleSignIn.currentUser;
    FirebaseUser user1;
    // if (user == null) {
    user = await _googleSignIn.signIn();
    print('logou google');

    //  }

    // if (await _auth.currentUser() == null) {
    GoogleSignInAuthentication credentialGoogle =
        await _googleSignIn.currentUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: credentialGoogle.accessToken,
      idToken: credentialGoogle.idToken,
    );

    user1 = (await _auth.signInWithCredential(credential)).user;
    // hyhy
    // }
    _currentUser = user;

    if (user != null) {
      erro = null;
      // _senha2Cotroller.value = "aaaaaa";
      // _senhaCotroller.value = "aaaaaa";
      _emailController.value = user.email;
      nomeCotroller.value = user.displayName;
      await novoUsuarioPeloGoogle(user1.uid);

      // try {
      //   await _autenticacao.loginUser(
      //       _emailController.value, _senhaCotroller.value);
      // } catch (e) {
      //   erro = e.code;
      //   return erro;
      // }

      _carregarSharedPerferenciasLogado(_emailController.value);
    }
    return erro;
  }

  Future<String> verSeEstaLogado() async {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      _currentUser = account;

      if (_currentUser != null) {
        //0fazer o q tem q fazer se logado
        return null;
      }
    });

    return 'Algo ocorreu';

    // if (account == null) {
    //   account = await _googleSignIn.signInSilently();
    //   print(_currentUser.toString());
    //   if (account != null) {
    //     print('nao é nulll');
    //     return null;
    //   } else {
    //     return 'Algo ocorreu';
    //   }
    // } else {
    //   return 'Algo ocorreu';
    // }
  }

  Future<String> logar() async {
    String aviso = '';
    String uid = '';
    //print(_emailController.value);
    if (_senhaCotroller.value == null || _emailController.value == null) {
      return 'Preencha todos os campos';
    }

    // _emailController.value = 'qq@qq.com';
    // _senhaCotroller.value = 'qqqqqq';
    //  _emailController.value = 'ee@ee.com';
    //   _senhaCotroller.value = 'eeeeee';
    //   _emailController.value='qqq@qqq.com';
    // _senhaCotroller.value='qqqqqq';
    controllerLoading.add(!controllerLoading.value);
    try {
      uid = await _autenticacao.loginUser(
          _emailController.value.trim(), _senhaCotroller.value.trim());
      // _emailController.value, _senhaCotroller.value);
      aviso = null;
    } catch (e) {
      aviso = e.code;
    }

    controllerLoading.add(!controllerLoading.value);
    _carregarSharedPerferenciasLogado(_emailController.value);
    return aviso == null ? null : _excecaoAviso(aviso);
  }

  _carregarSharedPerferenciasLogado(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
  }

  Future<String> novoUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('mostraPiramideAdm', false);
    String aviso = '';
    String uid = '';
    if (_senhaCotroller.value != _senha2Cotroller.value) {
      return 'As senhas estão diferentes';
    } else if (_senhaCotroller.value == null ||
        _senha2Cotroller.value == null ||
        _emailController.value == null ||
        nomeCotroller.value == null) {
      return 'Preencha todos os campos';
    }
    if (nomeCotroller.value == null || nomeCotroller.value.length < 2) {
      return 'Nome de ter pelo menos 3 caracteres';
    }
    //   _emailController.value='qq@qq.com';
    // _senhaCotroller.value='qqqqqq';

    // //   _emailController.value='pp@pp.com';
    // // _senhaCotroller.value='pppppp';

    controllerLoading.add(!controllerLoading.value);
    print(_emailController.value + '_emailController.value');
    try {
      uid = await _autenticacao.signUp(
          _emailController.value.trim(), _senhaCotroller.value.trim());
      aviso = null;
    } catch (e) {
      aviso = e.code;
      //  print('ggggghhhhhhhhh');
      return aviso;
    }

    if (uid != null) {
      DocumentReference usuDoc = await db.collection('usuarios').document(uid);

      db.collection('usuarios').document(usuDoc.documentID).setData(Usuario(
          publicidade: true,
          nome: nomeCotroller.value,
          npiramides: 0,
          piramidesPodeRelatarId: []).toMap());

      DocumentSnapshot snapNovo =
          await db.collection('usuarios').document(usuDoc.documentID).get();
      Usuario user1 = Usuario.fromMap(snapNovo.data, snapNovo.documentID);

      user1.piramidesPodeRelatarId.add('Fl6Qod4bU0BrmPRUIx5y');
      user1.piramidesPodeRelatarId.add('Ay9fVHcq2nhDxJJXqPiA');
      await db.collection('usuarios').document(uid).updateData(user1.toMap());

      DocumentReference carteiraDoc =
          await db.collection('carteiras').document();
      db
          .collection('carteiras')
          .document(carteiraDoc.documentID)
          .setData(Carteira(saldo: 1.0, usuarioId: usuDoc.documentID).toMap());

      //      DocumentReference fff =
      //     await db.collection('carteiras').document();
      // db
      //     .collection('carteiras')
      //     .document(fff.documentID)
      //     .setData(Carteira(saldo: 0.0, usuarioId: 'Kfhc7oTuEMXRfmzC2crhZ2lmJfV2').toMap());
    }

    _carregarSharedPerferenciasLogado(_emailController.value);
    if (aviso == null) {
      return null;
    } else {
      return _excecaoAvisoNovoUsuario(aviso);
    }
  }

  void novoUsuarioPeloGoogle(String uid) async {
    print(uid);
    DocumentSnapshot snap = await db.collection('usuarios').document(uid).get();
    print(snap.exists);
    Usuario user1;
    if (snap == null || !snap.exists) {
      DocumentReference usuDoc = await db.collection('usuarios').document(uid);
      db.collection('usuarios').document(usuDoc.documentID).setData(Usuario(
          publicidade: true,
          nome: nomeCotroller.value,
          npiramides: 0,
          piramidesPodeRelatarId: []).toMap());

      DocumentSnapshot snapNovo =
          await db.collection('usuarios').document(usuDoc.documentID).get();
      user1 = Usuario.fromMap(snapNovo.data, snapNovo.documentID);
    } else {
      user1 = Usuario.fromMap(snap.data, snap.documentID);
    }

    user1.piramidesPodeRelatarId.add('Fl6Qod4bU0BrmPRUIx5y');
    user1.piramidesPodeRelatarId.add('Ay9fVHcq2nhDxJJXqPiA');
    await db.collection('usuarios').document(uid).updateData(user1.toMap());
    DocumentReference carteiraDoc = await db.collection('carteiras').document();
    db
        .collection('carteiras')
        .document(carteiraDoc.documentID)
        .setData(Carteira(saldo: 1.0, usuarioId: uid).toMap());
  }

  String _excecaoAviso(String aviso) {
    if (aviso.contains('ERROR_WRONG_PASSWORD')) {
      return 'Senha errada';
    } else if (aviso.contains('ERROR_INVALID_EMAIL')) {
      return 'Email inválido';
    } else if (aviso.contains('ERROR_USER_NOT_FOUND')) {
      return 'Usuário não encontrado';
    } else if (aviso.contains('ERROR_TOO_MANY_REQUESTS')) {
      return 'Muitas tentativas, aguarde e tente denovo';
    } else if (aviso.contains('ERROR_OPERATION_NOT_ALLOWED')) {
      return 'Usuário não permitido';
    }
  }

  String _excecaoAvisoNovoUsuario(String aviso) {
    if (aviso.contains('ERROR_WEAK_PASSWORD')) {
      return 'Senha fraca';
    } else if (aviso.contains('ERROR_INVALID_EMAIL')) {
      return 'Email inválido';
    } else if (aviso.contains('ERROR_EMAIL_ALREADY_IN_USE')) {
      return 'Email ja possui conta ativa';
    }
  }

  String _excecaoRecuperacaoEmail(String aviso) {
    if (aviso.contains('ERROR_INVALID_EMAIL')) {
      return 'Email inválido!';
    } else if (aviso.contains('ERROR_USER_NOT_FOUND')) {
      return 'Usuário não encontrado!';
    }
    return 'Email não encontrado!';
  }

  @override
  void dispose() {
    controllerLoading.close();
    _emailController.close();
    _senhaCotroller.close();
    _senha2Cotroller.close();
    nomeCotroller.close();
    super.dispose();
  }

  Future<int> verOndeDirecionar() async {
    final FirebaseUser user = await _auth.currentUser();
    // print(user);
    final String uid = user.uid;
    //  print('zzxxxzzxxzzxxzzxx' + uid);
    QuerySnapshot rrr = await db
        .collection('piramides')
        .where('usuarioId', isEqualTo: uid)
        .limit(1)
        .getDocuments();

    final List<DocumentSnapshot> documents = rrr.documents;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (documents.isEmpty) {
      prefs.setBool('mostraPiramideAdm', false);
      DocumentSnapshot result =
          await db.collection('usuarios').document(uid).get();
      print(result.data.toString());
      Usuario user1 = Usuario.fromMap(result.data, result.documentID);
      if (user1.piramidesPodeRelatarId != null &&
          user1.piramidesPodeRelatarId.isNotEmpty) {
        return 1;
      } else {
        return 2;
      }
    } else {
      prefs.setBool('mostraPiramideAdm', true);
      return 0;
    }
  }

  @override
  Future<String> resetPassword() async {
    String aviso;
    if (_emailController.value == null || _emailController.value.isEmpty) {
      return 'Digite um email válido!';
    }
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.value);
      aviso = null;
    } catch (e) {
      // print(e.code);
      aviso = _excecaoRecuperacaoEmail(e.code);
    }
    return aviso;
  }
}
