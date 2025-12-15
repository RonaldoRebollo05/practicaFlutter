import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(const MaterialApp(
    home: GameScreen(),
  ));

  // var Jugador1 = Jugador("Ronaldo", 3000);
  //
  //
  // List<Monstruo> enemigosEnPantalla = [
  //   Monstruo("Dragon Morado", 1000),
  //   Monstruo("Goblin", 50),
  //   Jefe("Demonio de las sombras", 5000)
  // ];
  //
  // for (var enemigo in enemigosEnPantalla){
  //   enemigo.recibirDano(100);
  //   if (enemigo is Jefe && enemigo.vida> 0){
  //     enemigo.lanzarFuego();
  //   }
  // }
  //
  //
  // while( Jugador1.vida> 0 && enemigosEnPantalla.isNotEmpty){
  //   Jugador1.atacar();
  //   enemigosEnPantalla[0].recibirDano(1000);
  //   for (var enemigo in enemigosEnPantalla){
  //     if(enemigo.vida > 0){
  //       print("El ${enemigo.nombre} ataca a ${Jugador1.nombre} con 50 de daño!");
  //       Jugador1.recibirDano(50);
  //     }
  //   }
  //   enemigosEnPantalla.removeWhere((m) => m.vida <= 0 );
  // }
  //
  // if (Jugador1.vida> 0){
  //   print("El jugador gano el juego, bien hecho");
  // }else{
  //   print("Los enemigos ganaron, suerte la proxima vez");
  // }

}

abstract class Combatiente{
  void atacar();
  void recibirDano (int cantidad);
}



class Monstruo implements Combatiente{
  String nombre = "";
  int vida = 0;

  Monstruo(this.nombre, this.vida);

  void recibirDano(int cantidad){
    vida = vida - cantidad;
    if (vida > 0){
      print("$nombre: ¡Auch! Me dieron duro. (Vida restante: $vida)");
    }else{
      print("El $nombre ha muerto en combate");
    }
  }

  void atacar (){
    print("Lanzando un ataque");
  }

  @override
  String toString(){
    return "$nombre (Vida $vida)";
  }
}

class Jugador implements Combatiente{
  String nombre ="";
  int vida = 0;

  Jugador(this.nombre, this.vida);

  void atacar (){
    print("Lanzando un ataque");
  }

  void recibirDano(int cantidad){
    vida = vida - cantidad;
    if(vida> 0){
      print("$nombre: ¡Oh no! Recibí un golpe. (Vida restante: $vida)");
    }else{
      print("¡El $nombre ha caído en combate! Game Over.");
    }
  }

}

class Jefe extends Monstruo{
  Jefe(super.nombre, super.vida);

  void lanzarFuego(){
    print("Jefe ataca con bola de fuego");
  }

  @override
  void recibirDano(int cantidad){
    var danoReducido = cantidad ~/ 2;
    super.recibirDano(danoReducido);
    print("El demonio no recibio todo el daño, en total fue  $danoReducido");
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>{
  Jugador Jugador1 = Jugador("Ronaldo", 3000);
  List<Monstruo> enemigosEnPantalla = [
    Monstruo("Dragon Morado", 1000),
    Monstruo("Goblin", 50),
    Jefe("Demonio de las sombras", 5000)
  ];

  void iniciarTurno(){
    setState(() {
      Jugador1.atacar();
      enemigosEnPantalla[0].recibirDano(1000);
      for (var enemigo in enemigosEnPantalla){
        if(enemigo.vida > 0){
          print("El ${enemigo.nombre} ataca a ${Jugador1.nombre} con 50 de daño!");
          Jugador1.recibirDano(50);
        }
      }
      enemigosEnPantalla.removeWhere((m) => m.vida <= 0 );
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('El nombre es: ${Jugador1.nombre}'),
            Text('La vida total es de: ${Jugador1.vida}'),
            const SizedBox(height: 20),

            ...enemigosEnPantalla.map((enemigo) =>
            Text("El enemigo es ${enemigo.nombre} con vida ${enemigo.vida}")
            ).toList(),
            ElevatedButton(onPressed:(Jugador1.vida <= 0
                || enemigosEnPantalla.isEmpty) ? null : iniciarTurno,
                child: const Text("Atacar"))
          ],
        )
      )
    );
  }
}

