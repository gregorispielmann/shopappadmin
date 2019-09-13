
import 'dart:async';

class LoginValidators {

  final validateUser = StreamTransformer<String, String>.fromHandlers(
    handleData: (user, sink){
      if(user.contains('@')){
        sink.add(user);
      } else {
        sink.addError('Insira um e-mail válido');
      }
    }
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (pass, sink){
      if(pass.length > 4){
        sink.add(pass);
      } else {
        sink.addError('Senha inválida! Deve ter pelo menos 5 caracteres');
      }
    }
  );

}