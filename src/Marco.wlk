import wollok.game.*
import Borde.*

object marco {
	var bordeHInf 
	var bordeHSup 
	var bordeVIzq 
	var bordeVDer 
	
	var property limiteVertical
	var property limiteHorizontal
	var property inicioVertical
	var property inicioHorizontal
	
	method crearMarco(xInicial, yInicial, alto, ancho){
		limiteHorizontal = xInicial + ancho-2
		limiteVertical = yInicial + alto-2
		inicioHorizontal = xInicial+1
		inicioVertical = yInicial+1
		
		bordeHInf = new BordeHorizontal()
		bordeHInf.crearBordeHorizontal(xInicial,yInicial,ancho-1,"piedra.jpg")
	
		bordeHSup = new BordeHorizontal()
		bordeHSup.crearBordeHorizontal(xInicial,yInicial+(alto-1),ancho-1,"piedra.jpg")
	
		bordeVIzq = new BordeVertical()
		bordeVIzq.crearBordeVertical(xInicial,yInicial,alto-1,"piedra.jpg")
	
		bordeVDer = new BordeVertical()
		bordeVDer.crearBordeVertical(xInicial+(ancho-1),yInicial,alto-1,"piedra.jpg")
	}
	
	method dibujarMarco(){
		bordeHInf.dibujarBorde()
		bordeHSup.dibujarBorde()
		bordeVIzq.dibujarBorde()
		bordeVDer.dibujarBorde()
	}
	
	method borrarMarco(){
		bordeHInf.borrarBorde()
		bordeHSup.borrarBorde()
		bordeVIzq.borrarBorde()
		bordeVDer.borrarBorde()
	}
}
