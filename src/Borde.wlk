import Elemento.*
import wollok.game.*

class Borde inherits ElementoVisual{
	var property elementosDeBorde = []
	
	method dibujarBorde(){
		elementosDeBorde.forEach({elemento => elemento.dibujarElemento()})
	}
	
	method borrarBorde(){
		elementosDeBorde.forEach({elemento => elemento.borrarElemento()})
	}
}

class BordeVertical inherits Borde{
	method crearBordeVertical(xInicial, yInicial, tamanio,imagen){
		(0..(tamanio)).forEach({iterador => elementosDeBorde.add(new ElementoVisual(image=imagen,position=game.at(xInicial,yInicial+iterador)))})
	}
	
}

class BordeHorizontal inherits Borde{
	method crearBordeHorizontal(xInicial, yInicial, tamanio,imagen){
		(0..(tamanio)).forEach({iterador => elementosDeBorde.add(new ElementoVisual(image=imagen,position=game.at(xInicial+iterador,yInicial)))})
	}
	
}