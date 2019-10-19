
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
		
	method esPeligrosa()
    
    method kilometroDeLocalidad() = kilometroDeLocalidad
    
    method precio(){
			return precioOriginal - self.descuentosAplicados() 
	} 
}

object playa inherits Localidad{
	
	override method esPeligrosa(){
		return false
	}
}

class Montania inherits Localidad{
	const altura
	
	override method esPeligrosa(){
		return altura > 500 and
			   self.requiereLlevarVacuna()
	}
	
	override method esDestacada(){
		return true
	}
}

class CiudadHistorica inherits Localidad{
	var cantidadMuseos
	
	override method esPeligrosa(){
		return self.requiereEnEquipaje("Seguro de asistencia")
	}
	
	override method esDestacada(){
		return cantidadMuseos >= 3 and
			   super()
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
	var property transportes = [] // quizas conviene que sea un set (marti)
	
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
			    transporte = self.seleccionarTransporte()
			)
			unUsuario.validarViaje(unViaje)
			return unViaje
	}

	method seleccionarTransporte() {
			return transportes.anyOne()
	}
}

class Usuario {
	var nombreDeUsuario
	var property localidadOrigen
	var property viajes
	var usuariosQueSigue = []
	var property dineroEnCuenta
	
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
	
}

class Descuento {
	var porcentaje 
	
	method calcularDescuento(unTotal) {
			return unTotal * porcentaje
	}
}

class ViajeException inherits Exception {
	
}