class Destino {
	var property nombre
	var property precio
	var property equipaje
	
	//Habría que volver a revisar al final si es necesario poner el property
	//en todas las variables o no. (Juli)
	
	method esDestacado() {
		return precio > 2000
	}
	
	method aplicarDescuento(porcentajeADescontar) {
		precio -= (porcentajeADescontar * precio) / 100 
		equipaje.add("Certificado de Descuento")
	}	
	
	method requiereLlevarVacuna() {
		return self.requiereEnElEquipaje("Vacuna Gripal") or 
		self.requiereEnElEquipaje("Vacuna B")
	} 
	
	method requiereEnElEquipaje(unElemento){
		return equipaje.contains(unElemento)
	}
	//Se me ocurrio para que sea más genérico el hecho de verificar que en el string aparezca
	//la palabra vacuna nada más, pero no se de que tanto serviría o quedaría mejor
	//en este caso...(Juli)
	
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
		any{ destino => destino.requiereLlevarVacuna() }
	}
		
	method conocerCartaDestinos() {
		return destinos.map{ destino => destino.nombre() }
	}		
	
}
//tengo una duda muy grande sobre la Class destino,
//osea, el enunciaod esta todo el tiempo hablando de una
//"lista de destinos" supongo que esa lista se armara en los tests
//y ahi si hacer que todo esto compile.. o capaz lo estoy pensando mal
//pero pense hacer una Class destino simplemente porque todos los destinos
//comparten los mismos atributos y los mismos methods (Guido)

//Por ahora modelo al usuario como clase, pero si les parece que es un objeto
//cambien nomas. (Juli)

class Usuario {
	
	var nombreDeUsuario
	var lugaresQueConoce
	var dineroEnCuenta
	var usuariosQueSigue
	
	method volarADestino(unDestino) {
		if(self.puedeViajarA(unDestino)){
			lugaresQueConoce.add(unDestino)
			dineroEnCuenta -= unDestino.precio()		
		}		
	}
	
	method puedeViajarA(unDestino) {
		return dineroEnCuenta >= unDestino.precio()
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
	
	//Me genera muchas dudas el método seguirAUsuario :/ (Juli)
	
	
}





}