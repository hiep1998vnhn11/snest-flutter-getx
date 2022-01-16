import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class ResourceTab extends StatefulWidget {
  const ResourceTab({Key? key}) : super(key: key);

  @override
  _ResourceTabState createState() => _ResourceTabState();
}

class _ResourceTabState extends State<ResourceTab> {
  Future<void> _facebookLogin() async {
    final LoginResult result = await FacebookAuth.instance.login();
    print(result);
  }

  @override
  void initState() {
    // _facebookLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Resource'),
    );
  }
}
