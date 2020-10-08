import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

import '../models.dart';
import '../services.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  Status _status = Status.Uninitialized;
  StreamSubscription<User> _sub;
  UserModel _userModel;
  bool _initialized = false;

  UserModel get userModel => _userModel;
  Status get status => _status;
  User get user => _user;
  List<Order> orders = [];

  AuthProvider();

  void init() {
    if (_initialized) return;
    _initialized = true;
    _auth = FirebaseAuth.instance;
    _sub = _auth.authStateChanges().listen((user) {
      _onStateChanged(user);
    });
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      await UserService.instance.createUser({
        'name': name,
        'email': email,
        'uid': userCredential.user.uid,
        'stripeId': '',
      });

      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onStateChanged(User user) async {
    if (user == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = user;
      _userModel = await UserService.instance.getUserById(user.uid);
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<bool> addToCart({Product product, String size, String color}) async {
    try {
      String cartItemId = Uuid().v4();

      List<CartItem> cart = _userModel.cartItems;

      CartItem item = CartItem.fromMap({
        "id": cartItemId,
        "name": product.name,
        "image": product.picture,
        "productId": product.id,
        "price": product.price,
        "size": size,
        "color": color
      });

      print("CART ITEMS ARE: ${cart.toString()}");
      await UserService.instance.addToCart(userId: _user.uid, cartItem: item);

      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> removeFromCart({CartItem cartItem}) async {
    print("THE PRODUC IS: ${cartItem.toString()}");

    try {
      await UserService.instance.removeFromCart(userId: _user.uid, cartItem: cartItem);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<void> getOrders() async {
    orders = await OrderService.instance.getUserOrders(_user.uid);
    notifyListeners();
  }

  Future<void> reloadUserModel() async {
    _userModel = await UserService.instance.getUserById(user.uid);
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
