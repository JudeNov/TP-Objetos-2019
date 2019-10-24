
class Localidad {
	var property nombre 
	var equipajeNecesario 
	var descuentos = [] 
	const kilometroDeLocalidad
	const precioOriginal
				
	method esDestacada() {
			return precioOriginal > 2000
	}
	
	method distanciaA(otraLocalidad) {
			return (kilometroDeLocalidad - otraLocalidad.kilometroDeLocalidad()).abs() 
	}
	
	method aplicarDescuento(unDescuento) {
			descuentos.add(unDescuento) 
			equipajeNecesario.add("Certificado de descuento")
	} 
	
	method descuentosAplicados() {
			return descuentos.sum { unDescuento => unDescuento.calcularDescuento(precioOriginal) } 
	}
	
	method requiereLlevarVacuna() {
			return vacunasRegistradas.vacunas().any { unElemento => self.requiereEnEquipaje(unElemento) }
	} 

	method requiereEnEquipaje(unElemento) {
			return equipajeNecesario.contains(unElemento)
	}
		
	method esPeligrosa() {
			return self.requiereLlevarVacuna()
	}
        
    method precio() {
			return precioOriginal - self.descuentosAplicados() 
	} 
	
	method kilometroDeLocalidad() = kilometroDeLocalidad
	method equipajeNecesario() = equipajeNecesario
	
}

object playa inherits Localidad {
	override method esPeligrosa() = false
}

class Montania inherits Localidad{
	const altura
	
	override method esPeligrosa() {
			return altura > 5000 and super() 
	}
	
	override method esDestacada() = true
}

class CiudadHistorica inherits Localidad {
	var cantidadMuseos
	
	override method esPeligrosa() {
			return self.requiereEnEquipaje("Seguro de asistencia").negate()
	}
	
	override method esDestacada() {
			return cantidadMuseos >= 3 and super()
	}
}

class Viaje {
	var property localidadOrigen
	var property localidadDestino
	var property transporte
	
	constructor(_localidadOrigen, _localidadDestino, _transporte){
		localidadOrigen = _localidadOrigen
		localidadDestino = _localidadDestino
		transporte = _transporte  
	}
	
	method precioDeViaje() {
			return localidadDestino.precio() + transporte.precioDeTransporteEntre(localidadOrigen, localidadDestino) 
	}
	
	method elViajeEsPeligroso() {
			return localidadDestino.esPeligrosa()
	}
	
	method localidadDestinoEsDestacada() {
			return localidadDestino.esDestacada()
	}
	
	method distanciaRecorrida() {
			return localidadDestino.distanciaA(localidadOrigen)
	}
	
	method requiereLlevar(unItem) {
			return localidadDestino.requiereEnEquipaje(unItem)
	}
	
	method aplicarDescuentoAlDestino(unDescuento) {
			localidadDestino.aplicarDescuento(unDescuento)
	}

	method asignarTransporte(unTransporte) {
			transporte = unTransporte
	}
	
	method equipajeNecesario() {
			return localidadDestino.equipajeNecesario()
	}
}

class Transporte {
	var horasDeViaje = 0
  
	method precioPorKm()
	
	method precioDeTransporteEntre(localidadDeOrigen, localidadDeDestino) {
			return self.precioPorKm() * (localidadDeOrigen.distanciaA(localidadDeDestino))
	}
	
	method horasDeViaje() = horasDeViaje
} 

class Avion inherits Transporte {
	var turbinas = []
		
	override method precioPorKm() {
			return turbinas.sum { unaTurbina => unaTurbina.nivelImpulso() }
	}
	
}

class Turbina {
	var nivelImpulso
	
	method nivelImpulso() = nivelImpulso
}

class Barco inherits Transporte {
	var probabilidadChoque
	
	override method precioPorKm() {
			return 1000 * probabilidadChoque
	}
}

object micro inherits Transporte {
	override method precioPorKm() = 5000
}

object tren inherits Transporte {
	
	override method precioPorKm() {
			return 0.62 * 2300
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
	var property transportes = #{}
	
	method obtenerViajesDestacados() {
			return viajes.filter { unViaje => unViaje.localidadDestinoEsDestacada() }
	}
	
	method aplicarDescuentosAViajes(unDescuento) {
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
    		return viajes.filter { unViaje => unViaje.elViajeEsPeligroso() }
    }
        
	method armarViajePara(unUsuario, unDestino) {
			var unViaje = new Viaje(unUsuario.localidadOrigen(), unDestino, null) 
			//Luego de seleccionar el transporte se le asigna el transorte adecuado.
			unUsuario.seleccionarTransporte(unViaje)
			unUsuario.validarViaje(unViaje)
			return unViaje
	}
	
	method transporteMasRapido() {
				return self.transporteMasRapidoEntre(transportes)
	}
	
	method transporteCosteableYRapidoPara(unUsuario, unViaje) {
				return self.transporteMasRapidoEntre(self.transportesCosteablesPor(unUsuario, unViaje)) 
	}
	
	method transporteMasRapidoEntre(unosTransportes) {
			return unosTransportes.min { unTransporte => unTransporte.horasDeViaje() }
	}
	
	method transportesCosteablesPor(unUsuario, unViaje) {
			return transportes.filter { unTransporte => unUsuario.leAlcanzaElPresupuesto(unViaje, unTransporte) }
	}
	
	method transporteAleatorio() {
			return transportes.anyOne()
	}
	
}

class Usuario {
	var nombreDeUsuario
	var property localidadOrigen
	var property viajes
	var usuariosQueSigue = []
	var property dineroEnCuenta
	var property perfil
	var mochila
	
	method hacerUnViaje(unViaje) {
			self.validarViaje(unViaje)
			self.agregarViajeRealizado(unViaje)
			self.descontarDeLaCuenta(unViaje.precioDeViaje())
			self.actualizarLocalidadDeOrigen(unViaje)
	}
	
	method actualizarLocalidadDeOrigen(unViaje) {
			localidadOrigen = unViaje.localidadDestino()
	}
	
	method agregarViajeRealizado(unViaje) {
			viajes.add(unViaje)
	}
	
	method validarViaje(unViaje) {
			self.validarEquipaje(unViaje)
			self.validarPresupuesto(unViaje)	
	}
		
	method descontarDeLaCuenta(unMonto) {
			dineroEnCuenta -= unMonto
	}
	
	method validarPresupuesto(unViaje) {
			if(!self.poseeDineroParaElViaje(unViaje)) {
				throw new ViajeException(message = "No puede viajar al destino por falta de dinero.")		
			}	
	}
	
	method validarEquipaje(unViaje) {
			if(!self.tieneEquipajeNecesarioPara(unViaje)) {
				throw new ViajeException(message = "No puede viajar al destino por falta del equipaje adecuado.")		
			}	
	}
	
	method poseeDineroParaElViaje(unViaje) {
			return dineroEnCuenta >= unViaje.precioDeViaje()
	}
	
	method tieneEquipajeNecesarioPara(unViaje) {	
			return unViaje.equipajeNecesario().all { unElemento => self.tieneEnMochila(unElemento) }
	}
	
	method tieneEnMochila(unElemento) {
			return mochila.contains(unElemento)
	}
	
	method obtenerKilometros() {
			return viajes.sum { unViaje => unViaje.distanciaRecorrida() }
	}
	
	method viajoA(unLugar) {
      		return self.lugaresQueConoce().contains(unLugar)
  	} 
  
  	method lugaresQueConoce() {
  			return viajes.map { unViaje => unViaje.localidadDestino() }
  	}

	method seguirAUsuario(otroUsuario) {
			otroUsuario.agregarSeguido(self)
			self.agregarSeguido(otroUsuario)
	}
	
	method agregarSeguido(usuario) {
			usuariosQueSigue.add(usuario)
	}
	
	method usuariosQueSigue() = usuariosQueSigue
	
	method seleccionarTransporte(unViaje) {
			unViaje.asignarTransporte(perfil.seleccionarTransporte(self, unViaje))
	}
	
	method leAlcanzaElPresupuesto(unViaje, unTransporte) {
			return dineroEnCuenta >= unTransporte.precioDeTransporteEntre(unViaje.localidadOrigen(), unViaje.localidadDestino()) 
	}
	
	method agregarAMochila(unElemento){ //metodo utilizado para un test
		mochila.add(unElemento)
	}

}

//Borre la clase porque no tenia sentido tener un metodo que se sobreescribia todo el tiempo,
//no estaban compartiendo ningun comportamiento. Asi que lo deje como que el perfil es una interfaz.

object perfilEmpresarial {
	
	method seleccionarTransporte(unUsuario, unViaje) {
			return barrileteCosmico.transporteMasRapido()
	}
}

object perfilEstudiantil {
		
		method seleccionarTransporte(unUsuario, unViaje) {
				return barrileteCosmico.transporteCosteableYRapidoPara(unUsuario, unViaje)
		}				
}

object perfilGrupoFamiliar {
		method seleccionarTransporte(unUsuario, unViaje) {
				return barrileteCosmico.transporteAleatorio()
		}
}

class Descuento {
	var porcentaje 
	
	method calcularDescuento(unTotal) {
			return unTotal * porcentaje
	}
}

class ViajeException inherits Exception { }