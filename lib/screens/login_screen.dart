import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  bool obscurePassword = true;
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController nameController =
      TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  // =========================
  // EMAIL LOGIN / SIGNUP
  // =========================

  Future<void> submit() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage('Please enter email and password.');
      return;
    }

    if (!email.contains('@')) {
      showMessage('Please enter a valid email.');
      return;
    }

    if (!isLogin && name.isEmpty) {
      showMessage('Please enter your name.');
      return;
    }

    if (password.length < 6) {
      showMessage('Password must be at least 6 characters.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (isLogin) {
        // LOGIN
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (mounted) {
          showMessage('Login successful!');
        }
      } else {
        // SIGNUP
        final UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // SAVE NAME
        if (name.isNotEmpty &&
            userCredential.user != null) {
          await userCredential.user!
              .updateDisplayName(name);
        }

        if (mounted) {
          showMessage(
            'Account created successfully!',
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      showFirebaseError(e);
    } catch (e) {
      debugPrint('Auth Error: $e');

      showMessage(
        'Something went wrong. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // =========================
  // GOOGLE SIGN IN
  // =========================

  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    try {
      // GOOGLE SIGN IN
      final GoogleSignIn googleSignIn =
          GoogleSignIn(
        scopes: [
          'email',
        ],
      );

      // OPEN GOOGLE ACCOUNT SELECTOR
      final GoogleSignInAccount? googleUser =
          await googleSignIn.signIn();

      // USER CANCELLED
      if (googleUser == null) {
        return;
      }

      // GET AUTH DETAILS
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // CREATE FIREBASE CREDENTIAL
      final AuthCredential credential =
          GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // LOGIN WITH FIREBASE
      await _auth.signInWithCredential(
        credential,
      );

      if (mounted) {
        showMessage(
          'Google Sign-In successful!',
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(
        'Firebase Google Sign-In Error: '
        '${e.code} - ${e.message}',
      );

      showFirebaseError(e);
    } catch (e) {
      debugPrint(
        'Google Sign-In Error: $e',
      );

      showMessage(
        'Google Sign-In failed. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // =========================
  // FORGOT PASSWORD
  // =========================

  Future<void> forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showMessage(
        'Please enter your email first.',
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(
        email: email,
      );

      showMessage(
        'Password reset email sent.',
      );
    } on FirebaseAuthException catch (e) {
      showFirebaseError(e);
    } catch (e) {
      showMessage(
        'Something went wrong.',
      );
    }
  }

  // =========================
  // FIREBASE ERROR HANDLER
  // =========================

  void showFirebaseError(
    FirebaseAuthException e,
  ) {
    debugPrint(
      'Firebase Error: '
      '${e.code} - ${e.message}',
    );

    String message = 'Authentication failed.';

    switch (e.code) {
      case 'invalid-email':
        message = 'Invalid email address.';
        break;

      case 'user-not-found':
        message =
            'No account found with this email.';
        break;

      case 'wrong-password':
        message = 'Incorrect password.';
        break;

      case 'invalid-credential':
        message =
            'Invalid email or password.';
        break;

      case 'email-already-in-use':
        message =
            'This email is already registered.';
        break;

      case 'weak-password':
        message =
            'Password is too weak.';
        break;

      case 'network-request-failed':
        message =
            'Check your internet connection.';
        break;

      case 'operation-not-allowed':
        message =
            'This sign-in method is not enabled in Firebase.';
        break;

      case 'account-exists-with-different-credential':
        message =
            'An account already exists with this email.';
        break;

      case 'user-disabled':
        message =
            'This user account has been disabled.';
        break;

      default:
        message =
            e.message ??
            'Authentication failed.';
    }

    showMessage(message);
  }

  // =========================
  // SHOW MESSAGE
  // =========================

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF0B0B0F),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(
            24,
            30,
            24,
            30,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // LOGO

              Center(
                child: Container(
                  width: 78,
                  height: 78,

                  decoration:
                      BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(
                      24,
                    ),

                    gradient:
                        const LinearGradient(
                      colors: [
                        Color(0xFF7C3AED),
                        Color(0xFFEC4899),
                      ],
                    ),
                  ),

                  child: const Icon(
                    Icons.music_note_rounded,
                    size: 42,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              // TITLE

              Center(
                child: Text(
                  isLogin
                      ? 'Welcome Back'
                      : 'Create Account',

                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Center(
                child: Text(
                  isLogin
                      ? 'Sign in to continue listening'
                      : 'Join SERENG and discover music',

                  textAlign:
                      TextAlign.center,

                  style:
                      const TextStyle(
                    color:
                        Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(
                height: 32,
              ),

              // NAME

              if (!isLogin) ...[
                const Text(
                  'Name',

                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                inputField(
                  controller:
                      nameController,

                  hint:
                      'Your name',

                  icon:
                      Icons.person_outline,
                ),

                const SizedBox(
                  height: 18,
                ),
              ],

              // EMAIL

              const Text(
                'Email',

                style: TextStyle(
                  color: Colors.white,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              inputField(
                controller:
                    emailController,

                hint:
                    'Enter your email',

                icon:
                    Icons.email_outlined,

                keyboardType:
                    TextInputType.emailAddress,
              ),

              const SizedBox(
                height: 18,
              ),

              // PASSWORD

              const Text(
                'Password',

                style: TextStyle(
                  color: Colors.white,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              TextField(
                controller:
                    passwordController,

                obscureText:
                    obscurePassword,

                style:
                    const TextStyle(
                  color:
                      Colors.white,
                ),

                decoration:
                    InputDecoration(
                  hintText:
                      'Enter your password',

                  hintStyle:
                      const TextStyle(
                    color:
                        Colors.white38,
                  ),

                  prefixIcon:
                      const Icon(
                    Icons.lock_outline,

                    color:
                        Colors.white54,
                  ),

                  suffixIcon:
                      IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword =
                            !obscurePassword;
                      });
                    },

                    icon: Icon(
                      obscurePassword
                          ? Icons
                              .visibility_outlined
                          : Icons
                              .visibility_off_outlined,

                      color:
                          Colors.white54,
                    ),
                  ),

                  filled: true,

                  fillColor:
                      const Color(
                    0xFF18181F,
                  ),

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),

                    borderSide:
                        BorderSide.none,
                  ),
                ),
              ),

              // FORGOT PASSWORD

              if (isLogin)
                Align(
                  alignment:
                      Alignment.centerRight,

                  child: TextButton(
                    onPressed:
                        forgotPassword,

                    child:
                        const Text(
                      'Forgot Password?',
                    ),
                  ),
                )
              else
                const SizedBox(
                  height: 18,
                ),

              const SizedBox(
                height: 5,
              ),

              // LOGIN / SIGNUP BUTTON

              SizedBox(
                width:
                    double.infinity,

                height: 52,

                child:
                    ElevatedButton(
                  onPressed:
                      isLoading
                          ? null
                          : submit,

                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        Colors.white,

                    foregroundColor:
                        Colors.black,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        15,
                      ),
                    ),
                  ),

                  child:
                      isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,

                              child:
                                  CircularProgressIndicator(
                                strokeWidth:
                                    2,

                                color:
                                    Colors.black,
                              ),
                            )
                          : Text(
                              isLogin
                                  ? 'Login'
                                  : 'Create Account',

                              style:
                                  const TextStyle(
                                fontSize:
                                    16,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              // OR

              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      color:
                          Colors.white12,
                    ),
                  ),

                  Padding(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 12,
                    ),

                    child: const Text(
                      'OR',

                      style:
                          TextStyle(
                        color:
                            Colors.white38,

                        fontSize: 12,
                      ),
                    ),
                  ),

                  const Expanded(
                    child: Divider(
                      color:
                          Colors.white12,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              // GOOGLE BUTTON

              SizedBox(
                width:
                    double.infinity,

                height: 52,

                child:
                    OutlinedButton.icon(
                  onPressed:
                      isLoading
                          ? null
                          : signInWithGoogle,

                  icon:
                      const Icon(
                    Icons.g_mobiledata,
                    size: 30,
                  ),

                  label:
                      const Text(
                    'Continue with Google',
                  ),

                  style:
                      OutlinedButton
                          .styleFrom(
                    foregroundColor:
                        Colors.white,

                    side:
                        const BorderSide(
                      color:
                          Colors.white24,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        15,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              // LOGIN / SIGNUP SWITCH

              Center(
                child:
                    TextButton(
                  onPressed:
                      isLoading
                          ? null
                          : () {
                              setState(() {
                                isLogin =
                                    !isLogin;
                              });
                            },

                  child:
                      Text(
                    isLogin
                        ? "Don't have an account? Sign Up"
                        : 'Already have an account? Login',

                    style:
                        const TextStyle(
                      color:
                          Colors.white70,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              const Center(
                child: Text(
                  'By continuing, you agree to SERENG Terms & Privacy Policy.',

                  textAlign:
                      TextAlign.center,

                  style:
                      TextStyle(
                    color:
                        Colors.white30,

                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // INPUT FIELD
  // =========================

  Widget inputField({
    required TextEditingController
        controller,

    required String hint,

    required IconData icon,

    TextInputType?
        keyboardType,
  }) {
    return TextField(
      controller: controller,

      keyboardType: keyboardType,

      style:
          const TextStyle(
        color: Colors.white,
      ),

      decoration:
          InputDecoration(
        hintText: hint,

        hintStyle:
            const TextStyle(
          color:
              Colors.white38,
        ),

        prefixIcon:
            Icon(
            icon,

          color:
              Colors.white54,
        ),

        filled: true,

        fillColor:
            const Color(
          0xFF18181F,
        ),

        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            15,
          ),

          borderSide:
              BorderSide.none,
        ),
      ),
    );
  }
}
