import Elemento.*
import wollok.game.*
import Snake.*
import Numero.*

class Comestible inherits ElementoDinamico{
	const sonido
	method interactuar(cabeza)
	method reposicionar() { self.nuevaPosicionAlAzar()}
}

class ComestibleConCalorias inherits Comestible{
	const calorias
	var caloriasQuemadas = 1
	override method interactuar(cabeza){
		if (calorias > 0)
			{
				cabeza.almorce(true)
				cabeza.engordar(calorias)
			}
		else
			{
				caloriasQuemadas = (-calorias)
				cabeza.hiceGimnasia(true)
				cabeza.adelgazar(caloriasQuemadas)
			}
		informePeso.informarPeso(cabeza.peso())
		game.sound(sonido)
		self.reposicionar()
	}
	
	
}

class ComestibleConEstado inherits Comestible{
	const estadoQueAplica
	override method interactuar(cabeza){
		cabeza.estado(estadoQueAplica)
		game.sound(sonido)
		self.reposicionar()
	}
}

const manzana = new ComestibleConCalorias(image = "manzana.png", position = game.at(3,3), calorias = 1, sonido = "come.mp3")

const hamburguesa = new ComestibleConCalorias(image = "burguer.png", position = game.at(4,4), calorias = 3, sonido = "come.mp3")

const mancuerna = new ComestibleConCalorias(image = "mancuerna.png", position = game.at(7,5), calorias = -2, sonido = "Tarzan.mp3")

const cerveza = new ComestibleConEstado(image = "cerveza.png", position = game.at(6,3), estadoQueAplica = mareada, sonido = "eructo.mp3")

const agua = new ComestibleConEstado(image = "botella.png", position = game.at(8,8), estadoQueAplica = sobria, sonido = "eructo.mp3")