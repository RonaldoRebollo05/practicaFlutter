import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: GameScreen(),
  ));
}

abstract class Combatiente {
  void atacar();
  void recibirDano(int cantidad);
}

class Monstruo implements Combatiente {
  String nombre = "";
  int vida = 0;

  Monstruo(this.nombre, this.vida);

  void recibirDano(int cantidad) {
    vida = vida - cantidad;
    if (vida > 0) {
      print("$nombre: ¡Auch! Me dieron duro. (Vida restante: $vida)");
    } else {
      print("El $nombre ha muerto en combate");
    }
  }

  void atacar() {
    print("Lanzando un ataque");
  }

  @override
  String toString() {
    return "$nombre (Vida $vida)";
  }
}

class Jugador implements Combatiente {
  String nombre = "";
  double vida = 0;

  static const double vidaMaxima = 3000.0;
  Jugador(this.nombre, this.vida);

  void atacar() {
    print("Lanzando un ataque");
  }

  void recibirDano(int cantidad) {
    vida = vida - cantidad;
    if (vida > 0) {
      print("$nombre: ¡Oh no! Recibí un golpe. (Vida restante: $vida)");
    } else {
      print("¡El $nombre ha caído en combate! Game Over.");
    }
  }
}

class Jefe extends Monstruo {
  Jefe(super.nombre, super.vida);

  void lanzarFuego() {
    print("Jefe ataca con bola de fuego");
  }

  @override
  void recibirDano(int cantidad) {
    var danoReducido = cantidad ~/ 2;
    super.recibirDano(danoReducido);
    print("El demonio no recibio todo el daño, en total fue $danoReducido");
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Monstruo> _crearEnemigosIniciales() {
    return [
      Monstruo("Dragon Morado", 1000),
      Monstruo("Goblin", 50),
      Jefe("Demonio de las sombras", 5000)
    ];
  }

  Jugador Jugador1 = Jugador("Ronaldo", 3000);
  late List<Monstruo> enemigosEnPantalla;

  @override
  void initState() {
    super.initState();
    enemigosEnPantalla = _crearEnemigosIniciales();
  }

  void iniciarTurno() {
    setState(() {
      Jugador1.atacar();
      enemigosEnPantalla[0].recibirDano(1000);
      for (var enemigo in enemigosEnPantalla) {
        if (enemigo.vida > 0) {
          print("El ${enemigo.nombre} ataca a ${Jugador1.nombre} con 50 de daño!");
          Jugador1.recibirDano(50);
        }
      }
      enemigosEnPantalla.removeWhere((m) => m.vida <= 0);
    });
  }

  void reiniciarJuego() {
    setState(() {
      Jugador1 = Jugador("Ronaldo", 3000.0);
      enemigosEnPantalla = _crearEnemigosIniciales();
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
            LinearProgressIndicator(
              value: Jugador1.vida / Jugador.vidaMaxima,
            ),
            const SizedBox(height: 20),
            ...enemigosEnPantalla.map((enemigo) =>
                Text("El enemigo es ${enemigo.nombre} con vida ${enemigo.vida}")
            ).toList(),
            const SizedBox(height: 20),
            (Jugador1.vida <= 0 || enemigosEnPantalla.isEmpty)
                ? (enemigosEnPantalla.isEmpty
                ? Column(
              children: [
                const Text("¡VICTORIA! Has derrotado a todos los enemigos."),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: reiniciarJuego,
                    child: const Text("Reiniciar")
                ),
              ],
            )
                : Column(
              children: [
                const Text("GAME OVER. Fuiste derrotado."),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: reiniciarJuego,
                    child: const Text("Reiniciar")
                ),
              ],
            )
            )
                : ElevatedButton(
                onPressed: iniciarTurno,
                child: const Text("Atacar")
            ),
          ],
        ),
      ),
    );
  }
}