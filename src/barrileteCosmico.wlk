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
	var equipaje 
	var descuentos = [] 
	const kilometroDeLocalidad
				
	method esDestacado() {
			return precioOriginal > 2000
	}
	
	method distanciaA(otraLocalidad) {
			var distancia = kilometroDeLocalidad - otraLocalidad.kilometroDeLocalidad() 
			return distancia.abs()
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
		
	method esPeligroso() {
        	return self.requiereLlevarVacuna()
    }
    
    method kilometroDeLocalidad() = kilometroDeLocalidad
}

class Viaje {
	var property localidadOrigen
	var property localidadDestino
	var property transporte
	
	method precioDeViaje() {
			return localidadDestino.precio() + 
			transporte.precioDeTransporteEntre(localidadOrigen, localidadDestino) 
	}

	method distanciaRecorrida() {
			return localidadOrigen.distanciaA(localidadDestino)
	}
	
	method localidadDestinoEsPeligrosa(){
		return localidadDestino.esPeligrosa()
	}

	
	method localidadDestinoEsDestacada(){
		return localidadDestino.esDestacada()
	}
	
	method distanciaRecorrida(){
		return localidadDestino.distanciaA(localidadOrigen)
	}
	
	method requiereLlevar(unItem){
		return localidadDestino.poseeEnElEquipaje(unItem)
	}
}

// faltan definir estos metodos que se usan en barrilete cosmico, los deje asi para no olvidarme (marti)

class Transporte {
	var horasDeViaje
	var precioPorKilometro
	
	method precioDeTransporteEntre(localidadDeOrigen, localidadDeDestino) {
			var kilometrosDeViaje = localidadDeOrigen.distanciaA(localidadDeDestino)
			return precioPorKilometro * kilometrosDeViaje
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
			viajes.forEach { unViaje => unViaje.aplicarDescuento(unDescuento) }
	}
	
	method esEmpresaExtrema() {
			return (self.obtenerViajesDestacados()).any { unViaje => 
				unViaje.localidadDestinoEsPeligrosa()}
	}
		
	method conocerCartaDeViajes() {
			return viajes.map { unViaje => unViaje.localidadDestino() }
	}		
	
	method preciosDeLosViajes() {
        	return viajes.map { unViaje => unViaje.precioDelViaje() }
    }
    
    method todosLosViajesPoseen(unItem) {
    		return viajes.all { unViaje => unViaje.requiereLLevar(unItem) }
    }
    
    method viajesConDestinosPeligrosos() {
    		return viajes.filter { unViaje => unViaje.localidadDestinoEsPeligrosa() }
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
			if(!self.puedeViajarA(unDestino)) {
				throw new ViajeException(message = "No se puede viajar al destino.")		
			}	
	}
	
	method descontarDeLaCuenta(unMonto) {
			dineroEnCuenta -= unMonto
	}
	
	method puedeViajarA(unDestino) {
			return dineroEnCuenta >= unDestino.precio()
	}
	
	method viajoA(unLugar) {
       		return lugaresQueConoce.contains(unLugar)
    } 
        
	method obtenerKilometros() {
			return 0.1 * (self.precioTotalDeLosLugaresVisitados())
	}
	
	method precioTotalDeLosLugaresVisitados() {
			return lugaresQueConoce.sum { destino => destino.precio() }
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