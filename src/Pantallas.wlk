import Elemento.*
import wollok.game.*
import Comestibles.*
import Snake.*
import Marco.*
import Numero.*

class Nivel{
	var property fondoPantalla 
	var property objetivo
	var comestibles
	var pesoMax
	var pesoMin
	var pantallaWin
	var pantallaLoser
	var tickSpeed 
	var duracionNivel
	var estadoInicialSnake 
	var nivelIniciado
	
	method crearNivel(fondoObjetivo,elementosComestibles, pesoMaximo, pesoMinimo, ganaste, perdiste, velocidad, duracion,estado){
		objetivo = new Pantalla()
		objetivo.crearPantalla(fondoObjetivo)
		fondoPantalla = new Pantalla()
		fondoPantalla.crearPantalla("fondoVerde.jpg")
		comestibles = elementosComestibles
		pesoMax = pesoMaximo
		pesoMin = pesoMinimo
		pantallaWin = ganaste
		pantallaLoser = perdiste
		tickSpeed = velocidad
		duracionNivel = duracion
		estadoInicialSnake = estado
		reloj.iniciarReloj()
		informePeso.iniciarInforme()
	}
	
	method iniciarNivel(){
		nivelIniciado = true
		fondoPantalla.dibujarElemento()
		marco.crearMarco(0, 0, 12, 12)
		marco.dibujarMarco()
		cabeza.inicializarSnake(self)
		cabeza.dibujarElemento()
		cabeza.engordar(1)
		informePeso.informarPeso(cabeza.peso())
		reloj.incremetarUnSegundo()
		cabeza.estado(estadoInicialSnake)
		comestibles.forEach({comestible => comestible.dibujarElemento()})
		
		game.onTick(860,"unSegundo",{reloj.incremetarUnSegundo()})
		game.onTick(duracionNivel,"duracion de nivel",{self.finalizarNivel()})
		game.onTick(3000,"cancionFondo",{game.sound("sonidoFondo.mp3")})
		
		keyboard.up().onPressDo { self.activarMovimiento("up") }
		keyboard.down().onPressDo { self.activarMovimiento("down") }
		keyboard.left().onPressDo { self.activarMovimiento("left")  }
		keyboard.right().onPressDo { self.activarMovimiento("right")  }
			
		game.onTick(tickSpeed,"movimiento",{ cabeza.mover() })
		game.whenCollideDo(cabeza, { elemento => elemento.interactuar(cabeza)})	
		game.whenCollideDo(hamburguesa, { elemento => hamburguesa.reposicionar()})
		game.whenCollideDo(manzana, { elemento => manzana.reposicionar()})
		game.whenCollideDo(mancuerna, { elemento => mancuerna.reposicionar()})
			
		game.onTick(10000,"verSiAlmorzo",{cabeza.dejeDeComer() })
		game.onTick(15000,"verSiHizoGimnasia",{cabeza.snakeVaga()})
	}
	
	method activarMovimiento(direccion){
		if(nivelIniciado == true){
			game.removeTickEvent("movimiento") 
			cabeza.mirarA(direccion) 
			cabeza.mover() 
			game.onTick(tickSpeed,"movimiento",{ cabeza.mover() })
		}
	}
	
	method cumpleCondicion(){
		if(cabeza.peso()>=pesoMin && cabeza.peso()<=pesoMax ){
			game.sound("win.mp3")
			pantallaWin.iniciarPantalla()
		}
		else{
			game.sound("boooo.mp3")
			pantallaLoser.iniciarPantalla()
		}
	}
	
	method finalizarNivel(){
		nivelIniciado = false
		game.removeTickEvent("cancionFondo")
		game.removeTickEvent("movimiento")
		game.removeTickEvent("verSiAlmorzo")
		game.removeTickEvent("verSiHizoGimnasia")
		game.removeTickEvent("unSegundo")
		reloj.resetearReloj()
		self.cumpleCondicion()
	}
}

class Pantalla inherits ElementoVisual{
	var conexionesPantalla
	var conQuienMeConecto = []
	
	method crearPantalla(fondo){
		image = fondo
		position = game.at(0,0)
	}
	
	method vincularPantallas(conexiones, pantallasConectadas){
		conexionesPantalla = conexiones
		conQuienMeConecto = pantallasConectadas
	}
	
	method iniciarPantalla(){
		self.dibujarElemento()
		conexionesPantalla.conectar(conQuienMeConecto)
	}
}

object conexionPrincipal { 
	method conectar(conQuienMeConecto){
		keyboard.enter().onPressDo{game.clear() conQuienMeConecto.head().iniciarPantalla() } //iniciarMenu
	}
}

object conexionMenu {
	method conectar(conQuienMeConecto){
		keyboard.num1().onPressDo{game.clear() conQuienMeConecto.get(0).iniciarPantalla()}
		keyboard.num2().onPressDo{game.clear() conQuienMeConecto.get(1).iniciarPantalla()}
		keyboard.num3().onPressDo{game.clear() conQuienMeConecto.get(2).iniciarPantalla()}
		keyboard.num4().onPressDo{game.clear() conQuienMeConecto.get(3).iniciarPantalla()}
	}
}

object conexionObjetivos {
	method conectar(conQuienMeConecto){
		keyboard.o().onPressDo{game.clear() conQuienMeConecto.head().iniciarNivel() }
	}
}

object conexionControles {
	method conectar(conQuienMeConecto){
		keyboard.r().onPressDo{game.clear() conQuienMeConecto.head().iniciarPantalla() }
	}
}

object conexionResultado {
	method conectar(conQuienMeConecto){
		keyboard.r().onPressDo{game.clear() conQuienMeConecto.head().iniciarPantalla()}
		keyboard.s().onPressDo{game.clear() game.stop()}
	}
}

object juego {
	var pantallaInicial
	var menu
	var nivel1
	var nivel2
	var nivel3
	var controles
	var ganaste
	var perdiste
	
	method crearPantallasYNiveles(){
		game.title("Snake Game")
		game.width(12)
		game.height(12)
		
		pantallaInicial = new Pantalla()
		pantallaInicial.crearPantalla("fondoPrincipal.png")
		
		menu = new Pantalla()
		menu.crearPantalla("menu.png")
		
		ganaste = new Pantalla()
		ganaste.crearPantalla("ganaste.png")
		
		perdiste = new Pantalla()
		perdiste.crearPantalla("perdiste.png")
		
		var palabraPeso = new ElementoVisual(image="peso.png",position=game.at(6,11))
		var palabraTime = new ElementoVisual(image="time.png", position=game.at(2,11))
		
		nivel1 = new Nivel()
		nivel1.crearNivel("objetivoNivelUno.png", [hamburguesa ,mancuerna ,manzana, cerveza, agua, palabraPeso,palabraTime], 20, 15, ganaste, perdiste, 600, 60000, sobria )
		nivel2 = new Nivel()
		nivel2.crearNivel("objetivoNivelDos.png", [hamburguesa ,mancuerna ,manzana, cerveza, agua, palabraPeso,palabraTime], 50, 40, ganaste , perdiste, 300, 60000, sobria)
		nivel3 = new Nivel()
		nivel3.crearNivel("objetivoNivelTres.png", [hamburguesa ,mancuerna ,manzana, palabraPeso,palabraTime], 26, 16, ganaste, perdiste, 450, 60000, mareada)
		
		controles = new Pantalla()
		controles.crearPantalla("controles.png")
		
		pantallaInicial.vincularPantallas(conexionPrincipal, [menu])
		menu.vincularPantallas(conexionMenu, [nivel1.objetivo(),nivel2.objetivo(), nivel3.objetivo(), controles])
		nivel1.objetivo().vincularPantallas(conexionObjetivos,[nivel1])
		nivel2.objetivo().vincularPantallas(conexionObjetivos,[nivel2])
		nivel3.objetivo().vincularPantallas(conexionObjetivos,[nivel3])
		controles.vincularPantallas(conexionControles, [menu])
		ganaste.vincularPantallas(conexionResultado, [menu])
		perdiste.vincularPantallas(conexionResultado, [menu])
	}
	
	method iniciarJuego(){
		pantallaInicial.iniciarPantalla()
	}
	
}

object reloj {
	var segundos = -1
	var informadorNumero
	
	method iniciarReloj(){
		informadorNumero = new Numero(posUnidad = 5,posDecena = 4)
	}
	
	method incremetarUnSegundo(){
		segundos++
		informadorNumero.informarNumero(segundos)
	}
	
	method resetearReloj(){
		segundos = -1
	}
}


