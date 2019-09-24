object vacunasRegistradas{
	var vacunas = ["Vacuna Gripal", "Vacuna B"]
	
	method nuevaVacuna(tipoVacuna){
		vacunas.add(tipoVacuna)
	}
	
	method listaVacunas(){
		return vacunas()
	}
}

class Destino {
	var property nombre 
	var precioOriginal
	var equipaje 
	var descuentos = [] 
			
	method esDestacado() {
		return precioOriginal > 2000
	}
	
	method aplicarDescuento(unDescuento) {
		descuentos.add(unDescuento) 
		equipaje.add("Certificado de descuento")
	} // donde unDescuento es una instancia de la clase descuento
	
	method precio(){
		return precioOriginal - descuentos.sum{ descuento => 
			descuento.calcularDescuento(precioOriginal) } 
	}
	
	method requiereLlevarVacuna() {
		return vacunasRegistradas.listaVacunas().any{ unElemento => self.poseeEnElEquipaje(unElemento) }
	} 

	method poseeEnElEquipaje(unElemento){
		return equipaje.contains(unElemento)
	}
		
	 method esPeligroso(){
        return self.requiereLlevarVacuna()
    }
    
}

object barrileteCosmico {
	var property destinos = []
	
	method obtenerDestinosDestacados() {
		return destinos.filter{ destino => 
		destino.esDestacado() }
	}
	
	method aplicarDescuentosADestinos(unDescuento) {
		destinos.forEach{ destino =>
		destino.aplicarDescuento(unDescuento) }
	}
	
	method esEmpresaExtrema() {
		return (self.obtenerDestinosDestacados()).
		any{ destino => destino.esPeligroso() }
	}
		
	method conocerCartaDeDestinos() {
		return destinos.map{ destino => destino.nombre() }
	}		
	
	method preciosDeLosDestinos() {
        return destinos.map{ destino => destino.precio() }
    }
    
    method todosLosDestinosPoseen(unItem){
    	return destinos.all{ destino => destino.poseeEnElEquipaje(unItem) }
    }
    
    method destinosPeligrosos(){
    	return destinos.filter{ destino => destino.esPeligroso() }
    }
}

class Usuario {
	
	var nombreDeUsuario
	var lugaresQueConoce
	var usuariosQueSigue
	var property dineroEnCuenta
	
	method volarADestino(unDestino) {
		if(!self.puedeViajarA(unDestino)){
			throw new ViajeException(message = "No se puede viajar al destino.")		
		}	
		lugaresQueConoce.add(unDestino)
		self.descontarDeLaCuenta(unDestino.precio())	
	}
	
	method descontarDeLaCuenta(unMonto) {
		dineroEnCuenta -= unMonto
	}
	
	method puedeViajarA(unDestino) {
		return dineroEnCuenta >= unDestino.precio()
	}
	
	method viajoA(unLugar){
        return lugaresQueConoce.contains(unLugar)
    } 
        
	method obtenerKilometros() {
		return 0.1 * (self.precioTotalDeLosLugaresVisitados())
	}
	
	method precioTotalDeLosLugaresVisitados() {
		return lugaresQueConoce.sum{ destino => destino.precio() }
	}
	
	method seguirAUsuario(otroUsuario) {
		otroUsuario.agregarSeguido(self)
		self.agregarSeguido(otroUsuario)
	}
	
	method agregarSeguido(usuario) {
		usuariosQueSigue.add(usuario)
	}
	
}

class Descuento {
	var porcentaje 
	//el porcentaje es indicado como un numero decimal, por ejemplo 10% es 0.1

	method calcularDescuento(unTotal) {
		return unTotal * porcentaje
	}
}
class ViajeException inherits Exception {
	
}