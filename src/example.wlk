/** Danger Zone */
class Empleado {
	const rol
	var property salud
	var property estrellas
	const habilidades = #{}
	const subordinados = []
	const misionesCompletadas = []
	method incapacitado() = salud<rol.saludCritica()
	method puedeUsarHabilidad(habilidad){
		if(self.esJefe())
			return self.subordinadoPuedeUsar(habilidad)
		else
			return !self.incapacitado() and self.tieneHabilidad(habilidad)
	}
	method tieneHabilidad(habilidad) = habilidades.contains(habilidad)
	
	method esJefe() = !subordinados.isEmpty()
	
	method subordinadoPuedeUsar(habilidad)=	subordinados.any({subordinado=>subordinado.puedeUsarHabilidad(habilidad)})
	
	/*method cumplirMision(mision){
		if(self.reuneHabilidadesParaMision(mision))
		{
			self.recibirDanio(mision)
			self.finalizarMision(mision)
		}
		else
			self.error("No puede cumplir la mision")
		}
	Le paso la responsabilidad a la mision*/
	
	//method reuneHabilidadesParaMision(mision) = mision.habilidadesRequeridas().all({habilidad=>self.puedeUsarHabilidad(habilidad)})
	//Rompo el encapsulamiento de mision, al pedirle sus habilidades, no está bueno.
	
	method recibirDanio(cantidad){
		salud-=cantidad
	}
	method finalizarMision(mision){
		if(self.sobrevivio())
			self.completarMision(self)
		}
	method sobrevivio() = salud>0
	
	method completarMision(mision){
		misionesCompletadas.add(mision)
		rol.recompensaMision(self,mision)
	}
	method aprenderHabilidad(habilidad){
		habilidades.add(habilidad)
	}
}

//"Roles"
object espia{
	method saludCritica() = 15

	method recompensaMision(empleado,mision){
		/*const habilidadesMision = mision.habilidadesRequeridas()
		habilidadesMision.forEach({hab=>empleado.aprenderHabilidad(hab)}) Estoy rompiendo encapsulamiento*/
		mision.enseniarHabilidades(empleado) 
	}
}

class Oficinista{
	var property estrellas = 0
	method saludCritica() = 40-5*estrellas
	method recompensaMision(empleado,mision){
		self.ganarEstrella()
		if(estrellas==3)
			empleado.rol(espia) //Acoplamiento. 
	}
	method ganarEstrella(){
		estrellas +=1		
	}
}

class Equipo{
	const integrantes = []
	
	//method puedeHacer(mision) = integrantes.any({integrante=>integrante.cumplirMision(mision)})
	/*method cumplirMision(mision){
		if(self.puedeHacer(mision)){
			self.recibirDanio(mision)
			self.finalizarMision(mision)
		}
		else
			self.error("No pueden cumplir con mision")
	}
	Se repite logica con Empleado, pasar responsabilidad a la mision*/
	method puedeUsarHabilidad(habilidad) = integrantes.any({integrante=>integrante.puedeUsarHabilidad(habilidad)})
	
	method recibirDanio(cantidad){
			integrantes.forEach({integrante=>integrante.recibirDanio(cantidad/3)})
	}
	method finalizarMision(mision){
		integrantes.forEach({integrante=>integrante.finalizarMision(mision)})
	}
}

class Mision{
	const habilidadesRequeridas = []
	const property peligrosidad
	method cumplidaPor(asignado){
		if(self.puedeRealizarsePor(asignado))
		{asignado.recibirDanio(peligrosidad)
		 asignado.finalizarMision(self)
		}
		else
			self.error("La mision no puede ser realizada")
	}
	method puedeRealizarsePor(asignado)= habilidadesRequeridas.all({habilidad=>asignado.puedeUsarHabilidad(habilidad)})
	method enseniarHabilidades(asignado){
		//habilidadesRequeridas.forEach({hab=>empleado.aprenderHabilidad(hab)}) 
		//COMO ES UN SET LAS HABILIDADES DE UN EMPLEADO, NO SE VAN A DUPLICAR. 
		//PERO ES MEJOR QUE LO PASEMOS FILTRADO. LA CLASE MISION NO TIENE POR QUÉ SABER QUE EL EMPLEADO TIENE UN SET
		self.habilidadesQueNoPosee(asignado).forEach({hab=>asignado.aprenderHabilidad(hab)})
	}
	method habilidadesQueNoPosee(asignado) = habilidadesRequeridas.filter({hab=>!asignado.tieneHabilidad(hab)})
}
