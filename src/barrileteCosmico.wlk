class Destino {
	var property nombre 
	var property precioOriginal
	var property equipaje 
	var descuentos = [] 
	// los descuentos que se necesiten son instancias de la nueva clase descuentos
	
	method esDestacado() {
		return precioOriginal > 2000
	} //creo que el precio a comparar el el que esta sin descuentos, pero tengo dudas
	
	method aplicarDescuento(unDescuento) {
		descuentos.add(unDescuento) 
		equipaje.add("Certificado de descuento")
	} // donde unDescuento es una instancia de la clase descuento
	
	method precio(){
		return precioOriginal - descuentos.sum{ descuento => 
			descuento.calcularDescuento(precioOriginal) } 
	}
	
	method requiereLlevarVacuna() {
		return self.poseeEnElEquipaje("Vacuna Gripal") or 
		self.poseeEnElEquipaje("Vacuna B")
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
	
	var property nombreDeUsuario
	var property lugaresQueConoce
	var property dineroEnCuenta
	var property usuariosQueSigue
	
	// puse todos con property para probar los tests, falta chequear cual es necesario que lo tenga y cual no
	
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
    } //Es un método que se usa para ayudar en uno de los tests.(Juli)
        
    // a esto de aca fede, fue lo que te pregunte que no nos entendimos nada en slack
    // se puede hacer un method en el .wlk que solamente sirva para facilitar el uso de los tests? 
    // porque fijate que viajoA no es un method que el objeto use por lo menos en los puntos del tp (Guido)
	
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