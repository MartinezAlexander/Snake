import Elemento.*
import wollok.game.*

class Numero {
	var numeros = ["cero.png","uno.png","dos.png","tres.png","cuatro.png","cinco.png","seis.png","siete.png","ocho.png","nueve.png"]
	var posUnidad
	var posDecena
	
	method informarNumero(numero){
		var unidad = numero % 10
		var decena = numero.div(10)
		self.dibujarNumero( self.obtenerNombreDeNumero(unidad) , posUnidad)
		self.dibujarNumero( self.obtenerNombreDeNumero(decena) , posDecena)
	}
	
	method dibujarNumero(nombreNumero,parteDeNumero){
		var nuevoNumero = new ElementoVisual(image=nombreNumero, position=game.at(parteDeNumero,11))
		nuevoNumero.dibujarElemento()
	}
	
	method obtenerNombreDeNumero(numero){
		return numeros.get(numero)
	}
}

object informePeso {
	var numero
	method iniciarInforme(){
		numero = new Numero(posUnidad = 9, posDecena = 8)
	}
	
	method informarPeso(peso){
		numero.informarNumero(peso)
	}
}