import wollok.game.*
import Elemento.*
import Pantallas.*
import Marco.*

class Cuerpo inherits ElementoVisual{
	var siguiente = null
	var anterior = null
	var ultimaPosicion = null
	
	var imagen = "body.png"
	override method image() = imagen
	
	method setSiguiente(nuevoSiguiente) { siguiente = nuevoSiguiente }
	method setAnterior(nuevoAnterior) { anterior = nuevoAnterior }
	method getSiguiente() = siguiente
	method getAnterior() = anterior
	method setUltimaPosicion(nuevaUltima) { ultimaPosicion = nuevaUltima}
	method getUltimaPosicion() = ultimaPosicion
	
	method mover(nuevaPosicion){
		ultimaPosicion = position
		if (anterior != null) 
			anterior.mover(ultimaPosicion)
		position = nuevaPosicion
	}
	
	method interactuar(cabeza){
		position = game.at(5,3)
		cabeza.morir()
	}
}

object cabeza inherits Cuerpo(imagen = "head_up.png", position = game.at(5,3)){
	var ultimoCuerpo = self
	var nivel
	var property estado = sobria
	var property almorce = false
	var property hiceGimnasia = false
	var cuerpos = [] 
	
	method agregarCuerpo(){
		var nuevoCuerpo = new Cuerpo()
		nuevoCuerpo.dibujarElemento()
		cuerpos.add(nuevoCuerpo)
		
		ultimoCuerpo.setAnterior(nuevoCuerpo)
		nuevoCuerpo.setSiguiente(ultimoCuerpo)
		
		nuevoCuerpo.mover(ultimoCuerpo.getUltimaPosicion())
		nuevoCuerpo.setUltimaPosicion(nuevoCuerpo.position())
		ultimoCuerpo = nuevoCuerpo
	}
	
	method engordar(cuanto){
		(1..cuanto).forEach({iterador => self.agregarCuerpo()})
	}
	
	method quitarCuerpo(){
		ultimoCuerpo.borrarElemento()
		ultimoCuerpo = ultimoCuerpo.getSiguiente()
		ultimoCuerpo.setAnterior(null)
		cuerpos = cuerpos.take(cuerpos.size()-1)
	}
	
	method adelgazar(cantidad){
		if((cantidad <= cuerpos.size())&&(cantidad !=0 )){
			(1..cantidad).forEach({iterador => self.quitarCuerpo()})
		}
		else if((cantidad > cuerpos.size()) || cantidad == 0) {
			self.morir()
		}
	}
	
	method mover(){
		ultimaPosicion = self.position()
		position = self.getNuevaPosicion()
		if (anterior != null)
		anterior.mover(ultimaPosicion)
	}
	
	method getNuevaPosicion(){
		const y = position.y()
		const x = position.x()
		if((imagen == "head_up.png") && y<marco.limiteVertical()){
			return self.position().up(1)
		}
		if((imagen == "head_down.png") && y>marco.inicioVertical()){
			return self.position().down(1)
		}
		if((imagen == "head_left.png") && x>marco.inicioHorizontal()){
			return self.position().left(1)
		}
		if((imagen == "head_right.png") && x<marco.limiteHorizontal()){
			return self.position().right(1)
		}
		return self.position()
	}
	
	method mirarA(direccion){
		var dir = estado.controlarDireccion(direccion)
		imagen = movimientosPermitidos.obtenerNuevaDireccionCabeza(imagen,dir)
	}
	
	method peso(){
		return cuerpos.size()
	}
	
	method morir(){
		nivel.finalizarNivel() 
	}
	
	method dejeDeComer(){
		if(!almorce){
			self.morir()
		}
		else{
			self.almorce(false)
		}
	}
	
	method snakeVaga(){
		if(!hiceGimnasia){
			self.morir()
		}else{
			 self.hiceGimnasia(false)
		}
	}
	
	
	method inicializarSnake(level){
		nivel = level
		ultimoCuerpo = self
		ultimoCuerpo.setAnterior(null)
		ultimoCuerpo.setSiguiente(null)
		ultimoCuerpo.position(game.at(5,5))
		ultimoCuerpo.setUltimaPosicion(game.at(5,4))
		cuerpos = []
	}
	
}

object mareada{
	method controlarDireccion(direccion){
		var dir
		if(direccion=="right"){dir = "left"}
		if(direccion== "left"){dir = "right"}
		if(direccion=="down"){dir = "up"}
		if(direccion=="up"){dir = "down"}
		return dir
	}
}

object sobria{
	method controlarDireccion(direccion){
		return direccion;
	}
}

object movimientosPermitidos{
	const movimientoHorizontal = ["left","right"]
	const movimientoVertical = ["up","down"]
	
	method seMueveVerticalmente(aDondeMira){
		return (aDondeMira=="head_up.png" || aDondeMira=="head_down.png")
	}
	
	method seMueveHorizontalmente(aDondeMira){
		return (aDondeMira=="head_left.png" || aDondeMira=="head_right.png")
	}
	
	method esUnMovimientoVertical(direccion){
		return movimientoVertical.contains(direccion)
	}
	
	method esUnMovimientoHorizontal(direccion){
		return movimientoHorizontal.contains(direccion)
	}
	
	method obtenerNuevaDireccionCabeza(aDondeMira, aDondeQuiereMirar){
		if(self.seMueveVerticalmente(aDondeMira) && self.esUnMovimientoHorizontal(aDondeQuiereMirar)){
			return "head_" + aDondeQuiereMirar + ".png"
		}
		if(self.seMueveHorizontalmente(aDondeMira) && self.esUnMovimientoVertical(aDondeQuiereMirar)){
			return "head_" + aDondeQuiereMirar + ".png"
		}
		return aDondeMira
	}
	
}