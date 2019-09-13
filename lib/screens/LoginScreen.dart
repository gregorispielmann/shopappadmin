import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopappadmin/blocs/LoginBloc.dart';
import 'package:shopappadmin/screens/HomeScreen.dart';
import 'package:shopappadmin/widgets/InputField.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void dispose() { 
    _loginBloc.dispose();
    super.dispose();
  }

 final _loginBloc = LoginBloc(); 

  @override
  void initState() { 
    super.initState();
    _loginBloc.outState.listen((state){
      switch(state){
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen())
          );
          break;
        case LoginState.FAIL:
          showDialog(context: context, builder: (context) => AlertDialog(
            title: Text('Erro'),
            content: Text('Você não é administrador!\nVerifique seu usuário e senha!', textAlign: TextAlign.left,),
          ));
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:
    }});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoginState>(
      stream: _loginBloc.outState,
      initialData: LoginState.LOADING,
      builder: (context, snapshot){

        print(snapshot.data);
        switch(snapshot.data){
          case LoginState.LOADING:
            return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.pink),),);
          case LoginState.FAIL:
          case LoginState.SUCCESS:
          case LoginState.IDLE:
            return Scaffold(
              resizeToAvoidBottomPadding: false,
              backgroundColor: Colors.grey[850],
              body: Center(
                child: SingleChildScrollView(
                child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                //TOP
                Container(
                  child: Icon(
                    Icons.shopping_cart,
                    size: 100,
                    color: Colors.pink,
                    ),
                margin: EdgeInsets.fromLTRB(0,0,0,20),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.pink, width: 2)
                  ),
                  child: Text(
                    'Administrador da Loja',
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold
                      ),
                    textAlign: TextAlign.center,
                  ),
                ),


                //USER (EMAIL)
                InputField(hint: 'Usuário', icon: Icons.account_circle, obscure: false, stream: _loginBloc.outUser, onChanged: _loginBloc.changeUser,),
                SizedBox(height: 10,),

                //PASSWORD  
                InputField(hint: 'Senha', icon: Icons.lock, obscure: true, stream: _loginBloc.outPass, onChanged: _loginBloc.changePassword,),
                SizedBox(height: 20,),

                //ENTRAR
                StreamBuilder(
                  stream: _loginBloc.outSubmitvalid,
                  builder: (context, snapshot){
                    return FlatButton(
                      disabledColor: Colors.white10,
                      padding: EdgeInsets.all(12),
                      color: Colors.pink,
                      child: Text('Entrar',
                      style: TextStyle(color: snapshot.hasData ? Colors.white : Colors.white10),),
                      onPressed: snapshot.hasData ? _loginBloc.submit : null,
                    );
                  },
                )


              ],),
            ),),)
          ); 
        }
      },
    );
  }
}

