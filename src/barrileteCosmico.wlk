class Destino{
	var property nombre
	var property precio
	var property equipaje
	
	method esDestacado(){
		return precio > 2000
	}
	
	method aplicarDescuento(cuanto){
		precio = (1-cuanto) * precio
		equipaje.add("Certificado de Descuento")
	}	
	
	method hayVacunaEnEquipaje(){
		return equipaje.contains("Vacuna Gripal") or 
			   equipaje.contains("Vacuna B")
	}
	
}

object barrileteCosmico{
	
	method obtenerDestinosImportantes(listaDestinos){
		return listaDestinos.filter{destino => 
			destino.esDestacado()}
		}
	
	method aplicarDescuentosADestinos(listaDestinos,descuento){
		listaDestinos.forEach{destino =>
			destino.aplicarDescuento(descuento)}
		}
	
	method esEmpresaExtrema(listaDestinos){
		return (self.obtenerDestinosImportantes(listaDestinos))
		.any{destino=>
			destino.hayVacunaEnEquipaje()}
		}
		
	method conocerCartaDestinos(listaDestinos){
		return listaDestinos.forEach{destino=>
			destino.nombre()
		}
	}		
	

//tengo una duda muy grande sobre la Class destino,
//osea, el enunciaod esta todo el tiempo hablando de una
//"lista de destinos" supongo que esa lista se armara en los tests
//y ahi si hacer que todo esto compile.. o capaz lo estoy pensando mal
//pero pense hacer una Class destino simplemente porque todos los destinos
//comparten los mismos atributos y los mismos methods







}