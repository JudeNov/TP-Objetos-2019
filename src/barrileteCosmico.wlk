
class Localidad {
	var property nombre 
	var precioOriginal
	var equipaje 
	var descuentos = [] 
	const kilometroDeLocalidad
				
	method esDestacada() {
			return precioOriginal > 2000
	}
	
	method distanciaA(otraLocalidad) {
			return (kilometroDeLocalidad - otraLocalidad.kilometroDeLocalidad()).abs() 
	}
	
	method aplicarDescuento(unDescuento) {
			descuentos.add(unDescuento) 
			equipaje.add("Certificado de descuento")
	} // donde unDescuento es una instancia de la clase descuento
	
	method descuentosAplicados() {
			return descuentos.sum { descuento => descuento.calcularDescuento(precioOriginal) } 
	}
	
	method requiereLlevarVacuna() {
			return vacunasRegistradas.vacunas().any { unElemento => 
				self.requiereEnEquipaje(unElemento)}
	} 

	method requiereEnEquipaje(unElemento) {
			return equipaje.contains(unElemento)
	}
		
	method esPeligrosa() {
        	return self.requiereLlevarVacuna()
    }
    
    method kilometroDeLocalidad() = kilometroDeLocalidad
    
    method precio(){
    	return precioOriginal
    }
}

class Viaje {
	var property localidadOrigen
	var property localidadDestino
	var property transporte
	
	method precioDeViaje() {
			return localidadDestino.precio() + 
			transporte.precioDeTransporteEntre(localidadOrigen, localidadDestino) 
	}
	
	method elViajeEsPeligroso(){
		return localidadDestino.esPeligrosa()
	}

	
	method localidadDestinoEsDestacada(){
		return localidadDestino.esDestacada()
	}
	
	method distanciaRecorrida(){
		return localidadDestino.distanciaA(localidadOrigen)
	}
	
	method requiereLlevar(unItem){
		return localidadDestino.requiereEnEquipaje(unItem)
	}
	
	method aplicarDescuentoAlDestino(descuento){
		localidadDestino.aplicarDescuento(descuento)
	}
}

// faltan definir estos metodos que se usan en barrilete cosmico, los deje asi para no olvidarme (marti)

class Transporte {
	var horasDeViaje
	var precioPorKilometro
	
	method precioDeTransporteEntre(localidadDeOrigen, localidadDeDestino) {
			return precioPorKilometro * (localidadDeOrigen.distanciaA(localidadDeDestino))
	}
} 

object vacunasRegistradas {
	var property vacunas = ["Vacuna Gripal", "Vacuna B"]
	
	method nuevaVacuna(tipoVacuna) {
			vacunas.add(tipoVacuna)
	}
}

object barrileteCosmico {
	var property viajes = []
	var transportes = [] // quizas conviene que sea un set (marti)
	
	method obtenerViajesDestacados() {
			return viajes.filter { unViaje => unViaje.localidadDestinoEsDestacada()}
	}
	
	method aplicarDescuentosADestinos(unDescuento) {
			viajes.forEach { unViaje => unViaje.aplicarDescuentoAlDestino(unDescuento) }
	}
	
	method esEmpresaExtrema() {
			return (self.obtenerViajesDestacados()).any { unViaje => 
				unViaje.elViajeEsPeligroso()}
	}
		
	method conocerCartaDeViajes() {
			return viajes.map { unViaje => unViaje.localidadDestino() }
	}		
	
	method preciosDeLosViajes() {
        	return viajes.map { unViaje => unViaje.precioDeViaje() }
    }
    
    method todosLosViajesPoseen(unItem) {
    		return viajes.all { unViaje => unViaje.requiereLlevar(unItem) }
    }
    
    method viajesConDestinosPeligrosos() {
    		return viajes.filter { unViaje => unViaje.localidadDestinoEsPeligrosa() }
    }
}

class Usuario {
	var nombreDeUsuario
	var localidadOrigen
	var viajes
	var usuariosQueSigue
	var property dineroEnCuenta
	
	method hacerUnViaje(viaje) {
			self.validarViajeA(viaje)
			viajes.add(viaje)
			self.descontarDeLaCuenta(viaje.precioDeViaje())
			localidadOrigen = viaje.localidadDestino()
	}
//	
	method validarViajeA(viaje) {
			if(!self.puedeViajar(viaje)){
				throw new ViajeException(message = "No se puede viajar al destino.")		
			}	
	}
	
//	
	method descontarDeLaCuenta(unMonto) {
			dineroEnCuenta -= unMonto
	}
//	
	method puedeViajar(viaje){
			return dineroEnCuenta >= viaje.precioDeViaje()
	}
	
	method obtenerKilometros(){
		return viajes.sum{viaje => viaje.distanciaRecorrida()}
	}
	
	method viajoA(unLugar) {
      		return self.lugaresQueConoce().contains(unLugar)
  } 
  
  	method lugaresQueConoce(){
  		return viajes.map{viaje => viaje.localidadDestino()}
  	}
//        
//	method obtenerKilometros() {
//			return 0.1 * (self.precioTotalDeLosLugaresVisitados())
//	}
//	
//	method precioTotalDeLosLugaresVisitados() {
//			return lugaresQueConoce.sum { destino => destino.precio() }
//	}
//	
//	method seguirAUsuario(otroUsuario) {
//			otroUsuario.agregarSeguido(self)
//			self.agregarSeguido(otroUsuario)
//	}
//	
//	method agregarSeguido(usuario) {
//			usuariosQueSigue.add(usuario)
//	}
	
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