import wollok.game.*
import Marco.*

class ElementoVisual {
	var property image
	var property position
	
	method dibujarElemento(){
		game.addVisual(self)
	}
	
	method borrarElemento(){
		game.removeVisual(self)
	}
}


class ElementoDinamico inherits ElementoVisual{
	method nuevaPosicionAlAzar () {
		var x = marco.inicioHorizontal().randomUpTo(marco.limiteHorizontal()).truncate(0)
		var y = marco.inicioVertical().randomUpTo(marco.limiteVertical()).truncate(0)
		position = game.at (x, y)
	}
}