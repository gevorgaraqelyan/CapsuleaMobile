import 'package:capsulea_mobile/core/services/auth_service.dart';
import 'package:capsulea_mobile/ui/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimatedDrawerPage extends StatefulWidget {
  const AnimatedDrawerPage({super.key, required this.isOpened});
  final bool isOpened;
  @override
  State<AnimatedDrawerPage> createState() => _AnimatedDrawerPageState();
}

class _AnimatedDrawerPageState extends State<AnimatedDrawerPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _circleSize;
  late Animation<double> _iconSize;
  final _authService = AuthService();
  String? email;
  String? name;
  String? photo;
  getUserInfo() async {
    var prefs = await SharedPreferences.getInstance();
     email = prefs.getString('userEmail');
     name = prefs.getString('userName');
     photo = prefs.getString('userPhoto');
    print('Email: $email, Name: $name, Photo: $photo');
  }
  @override
  void initState() {
    super.initState();
     getUserInfo();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _circleSize = Tween<double>(
      begin: 60,
      end: 350,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _iconSize = Tween<double>(
      begin: 32,
      end: 100,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    if (widget.isOpened) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedDrawerPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 🔑 если isOpened поменялось — запускаем анимацию
    if (widget.isOpened != oldWidget.isOpened) {
      if (widget.isOpened) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
        top: true,
        maintainBottomViewPadding: true,
        child: Drawer(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child:  Column(
          
          children: [
            DrawerHeader(
              
              decoration: BoxDecoration(
                
                color: Theme.of(context).colorScheme.primaryContainer,
                ),
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final size = _circleSize.value;
                      
                  return Container(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    height: size + 40,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        //color: Colors.brown,
                        gradient: const LinearGradient(
                          colors: [Colors.purple, Colors.blue,Colors.deepPurple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          (1 - _controller.value) *
                              (size), // 🔑 от круга к прямоугольнику
                        ),
                      ),
                    child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       mainAxisSize: MainAxisSize.min,
                        children: [
                           photo != null && photo != '' ? SizedBox(
                              width: _iconSize.value,
                              height: _iconSize.value,
                             child: ClipRRect(
                              
                                                       borderRadius: BorderRadius.circular(
                              50
                                                       ),
                                                       child: Image.network(
                              width: _iconSize.value,
                              height: _iconSize.value,
                              filterQuality: FilterQuality.high,
                              photo!,
                              fit: BoxFit.cover,
                                                       ),
                                                     ),
                           ) : Icon(
                          Icons.person,
                          size: _iconSize.value,
                          color: Colors.white,
                        ),
                        if(name != null && name != '')  Text(
                            name!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20 * _controller.value,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        
                        if(email != null && email != '')  Text(
                            email!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18 * _controller.value,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        
                        ]),
                    )
                    
                  );
                },
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(leading: Icon(Icons.home), title: Text("Главная")),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Настройки"),
                  ),
                  ListTile(leading: Icon(Icons.logout), title: Text("Выход"), onTap: ()async {
                    await _authService.logout();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage(),));
                  },),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
