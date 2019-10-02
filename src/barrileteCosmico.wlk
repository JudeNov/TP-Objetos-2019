/*class Destino {
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
		return precioOriginal - self.descuentosAplicados()
	}
	
	method descuentosAplicados() {
		return descuentos.sum{ descuento => descuento.calcularDescuento(precioOriginal) } 
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
    
}*/

class Localidad {
	var property nombre 
	var precioOriginal
	var kilometro
	var equipaje 
	var descuentos = [] 
	var transportes = []
			
	method esDestacado() {
		return precioOriginal > 2000
	}
	
	method kilometro(){
		return kilometro
	}
	
	method distanciaACiudad(ciudad){
		var distancia = kilometro-ciudad.kilometro() 
		return distancia.abs()
	}
	
	method aplicarDescuento(unDescuento) {
		descuentos.add(unDescuento) 
		equipaje.add("Certificado de descuento")
	} // donde unDescuento es una instancia de la clase descuento
	
	method precioViaje(transporte){
		return precioOriginal + self.precioPorKilometros(transporte) - self.descuentosAplicados()
	}
	
	method precioPorKilometros(transporte){
		//calcular distancia hasta la otra localidad y ver el precioPorKilometro del transporte que va a usar.... verificar que ese transporte esté disponible
	}
	
	
	method descuentosAplicados() {
		return descuentos.sum{ descuento => descuento.calcularDescuento(precioOriginal) } 
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

class mediosTransporte{
	var tiempo
	var precioPorKilometro
}




object vacunasRegistradas{
	var vacunas = ["Vacuna Gripal", "Vacuna B"]
	
	method nuevaVacuna(tipoVacuna){
		vacunas.add(tipoVacuna)
	}
	
	method listaVacunas(){
		return vacunas
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
	var localidad
	var lugaresQueConoce
	var usuariosQueSigue
	var property dineroEnCuenta
	
	method volarADestino(unDestino) {
		self.validarViajeA(unDestino)
		lugaresQueConoce.add(unDestino)
		self.descontarDeLaCuenta(unDestino.precio())
		localidad = unDestino	
	}
	
	method validarViajeA(unDestino) {
		if(!self.puedeViajarA(unDestino)){
			throw new ViajeException(message = "No se puede viajar al destino.")		
		}	
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