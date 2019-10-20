
class Localidad {
	var property nombre 
	var equipaje 
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
			equipaje.add("Certificado de descuento")
	} 
	
	method descuentosAplicados() {
			return descuentos.sum { descuento => descuento.calcularDescuento(precioOriginal) } 
	}
	
	method requiereLlevarVacuna() {
			return vacunasRegistradas.vacunas().any { unElemento => self.requiereEnEquipaje(unElemento) }
	} 

	method requiereEnEquipaje(unElemento) {
			return equipaje.contains(unElemento)
	}
		
	method esPeligrosa(){
		return self.requiereLlevarVacuna()
	}
    
    method kilometroDeLocalidad() = kilometroDeLocalidad
    
    method precio(){
			return precioOriginal - self.descuentosAplicados() 
	} 
}

object playa inherits Localidad {
	override method esPeligrosa() = false
}

class Montania inherits Localidad{
	const altura
	
	override method esPeligrosa(){
		return altura > 5000 and super() 
	}
	
	override method esDestacada() = true
}

class CiudadHistorica inherits Localidad {
	var cantidadMuseos
	
	override method esPeligrosa(){
			return self.requiereEnEquipaje("Seguro de asistencia").negate()
	}
	
	override method esDestacada(){
			return cantidadMuseos >= 3 and super()
	}
}

class Viaje {
	var property localidadOrigen
	var property localidadDestino
	var property transporte
	
	method precioDeViaje() {
			return localidadDestino.precio() + transporte.precioDeTransporteEntre(localidadOrigen, localidadDestino) 
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
	
	method aplicarDescuentoAlDestino(unDescuento){
			localidadDestino.aplicarDescuento(unDescuento)
	}
}

class Transporte {
	var horasDeViaje
	
	method precioPorKm()
	
	method precioDeTransporteEntre(localidadDeOrigen, localidadDeDestino) {
			return self.precioPorKm() * (localidadDeOrigen.distanciaA(localidadDeDestino))
	}
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

class Barco inherits Transporte{
	var probabilidadChoque
	
	override method precioPorKm(){
		return 1000 * probabilidadChoque
	}
}

object micro inherits Transporte {
	override method precioPorKm() = 5000
}

object tren inherits Transporte{
	
	override method precioPorKm(){
		return 0.6 * 2300
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
			var unViaje = new Viaje(
				localidadOrigen = unUsuario.localidadOrigen(),
				localidadDestino = unDestino,
			    transporte = self.seleccionarTransporte(unUsuario,unViaje.distanciaRecorrida())
			)
			unUsuario.validarViaje(unViaje)
			return unViaje
	}

	method seleccionarTransporte(unUsuario,kmsDelViaje) {
			return unUsuario.transporteCorrespondiente(transportes,kmsDelViaje)
	}
}

class Usuario {
	var nombreDeUsuario
	var property localidadOrigen
	var property viajes
	var usuariosQueSigue = []
	var property dineroEnCuenta
	var property perfil 
	
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
			if(!self.puedeViajar(unViaje)){
				throw new ViajeException(message = "No se puede viajar al destino.")		
			}	
	}
		
	method descontarDeLaCuenta(unMonto) {
			dineroEnCuenta -= unMonto
	}
	
	method puedeViajar(unViaje) {
			return dineroEnCuenta >= unViaje.precioDeViaje()
	}
	
	method obtenerKilometros(){
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
	
	method transporteCorrespondiente(unosTransportes,kmsDelViaje){
		return perfil.seleccionarTransporte(unosTransportes,self,kmsDelViaje)
	}

}

class Perfil{
	
	method seleccionarTransporte(unosTransportes,unUsuario,kmsDelViaje)
	method transporteMasRapido(unosTransportes) {
		return unosTransportes.min { unTransporte => unTransporte.horasDeViaje() }
	}
}

object perfilEmpresarial inherits Perfil {
	
	override method seleccionarTransporte(unosTransportes,unUsuario,kmsDelViaje) {
		return self.transporteMasRapido(unosTransportes)
	}
}

object perfilEstudiantil inherits Perfil {
		
		
		override method seleccionarTransporte(unosTransportes,unUsuario,kmsDelViaje) {
				return self.transporteMasRapido(self.transportesQuePuedeCostear(unosTransportes,unUsuario,kmsDelViaje))
		}
		
		method transportesQuePuedeCostear(unosTransportes,unUsuario,kmsDelViaje) {
				return unosTransportes.filter { unTransporte => self.alcanzaElPresupuestoPara(unTransporte,unUsuario,kmsDelViaje) }
		}
		
		method alcanzaElPresupuestoPara(unTransporte,unUsuario,kmsDelViaje){
			return unUsuario.presupuesto() >= kmsDelViaje * unTransporte.precioPorKm()
		}
		
}

object perfilGrupoFamiliar inherits Perfil {
		override method seleccionarTransporte(unosTransportes,unUsuario,kmsDelViaje) {
				return unosTransportes.anyOne()
		}
}

class Descuento {
	var porcentaje 
	
	method calcularDescuento(unTotal) {
			return unTotal * porcentaje
	}
}

class ViajeException inherits Exception {
	
}