class Destino {
	var property nombre 
	var property precio
	var property equipaje 
	
	method esDestacado() {
		return precio > 2000
	}
	
	method aplicarDescuento(porcentajeADescontar) {
		precio -= (porcentajeADescontar * precio) / 100 
		equipaje.add("Certificado de descuento")
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

class ViajeException inherits Exception {
	
}