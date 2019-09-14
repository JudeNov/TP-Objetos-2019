class Destino {
	var property nombre 
	var property precio
	var property equipaje // creo que equipaje tampoco iria como property, no se que opinan ustedes (marti)
	
	//Habría que volver a revisar al final si es necesario poner el property
	//en todas las variables o no. (Juli)
	
	method esDestacado() {
		return precio > 2000
	}
	
	method aplicarDescuento(porcentajeADescontar) {
		precio -= (porcentajeADescontar * precio) / 100 
		equipaje.add("Certificado de descuento")
	}	
	
	//Acá tendría que revisarse el tema de que no haya efecto sobre el precio real. Se podría 
	//agregar una variable de precioConDescuento para evitarlo. (Juli)
		
	method requiereLlevarVacuna() {
		return self.poseeEnElEquipaje("Vacuna Gripal") or 
		self.poseeEnElEquipaje("Vacuna B")
	} 
	
	method poseeEnElEquipaje(unElemento){
		return equipaje.contains(unElemento)
	}
	//Se me ocurrio para que sea más genérico el hecho de verificar que en el string aparezca
	//la palabra vacuna nada más, pero no se de que tanto serviría o quedaría mejor
	//en este caso...(Juli) -- para mi asi esta bien, en el caso de que en otro momento se hable de mas
	// tipos de vacunas es una buena idea para modificar ese metodo (marti)
	
	 method esPeligroso(){
        return nombre == "Last Toninas"
    }
    //Como no encontramos en el enunciado cómo se definía el método, lo hicimos así para que respete los tests.
    //Pero está sujeto a cambios en el futuro :) (Juli)
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
		
	method conocerCartaDeDestinos() {
		return destinos.map{ destino => destino.nombre() }
	}		
	
	method preciosDeLosDestinos() {
        return destinos.map{ destino => destino.precio() }
    }
    
    method todosLosDestinosPoseen(unItem){
    	return destinos.all{ destino => destino.poseeEnElEquipaje(unItem) }
    }
    
    method obtenerDestinosPeligrosos(){
    	return destinos.filter{ destino => destino.esPeligroso() }
    }
}
/*Tengo una duda muy grande sobre la Class destino,
osea, el enunciado esta todo el tiempo hablando de una
"lista de destinos" supongo que esa lista se armara en 
los tests y ahi si hacer que todo esto compile.. o capaz 
lo estoy pensando mal pero pense hacer una Class destino 
simplemente porque todos los destinos comparten los mismos 
atributos y los mismos methods (Guido) ----- para mi asi 
esta joya (marti)*/ 

class Usuario {
	
	var property nombreDeUsuario
	var property lugaresQueConoce
	var property dineroEnCuenta
	var property usuariosQueSigue
	
	// puse todos con property para probar los tests, falta chequear cual es necesario que lo tenga y cual no
	
	method volarADestino(unDestino) {
		if(self.puedeViajarA(unDestino)){
			lugaresQueConoce.add(unDestino)
			dineroEnCuenta -= unDestino.precio()		
		}
		/*No se si convendría o no agregar un else que retorne "El dinero no es suficiente para pagar el viaje",
		o algo así (Juli)*/		
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
	
	/*Se modela como una clase y no como un objeto porque en el enunciado menciona
	la posibilidad de que en el futuro se carguen muchos usuarios con las
	mismas características.*/
}
