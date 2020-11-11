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
	
	method cumplirMision(mision) = self.reuneHabilidadesParaMision(mision)
	
	method reuneHabilidadesParaMision(mision) = mision.habilidadesRequeridas().all({habilidad=>self.puedeUsarHabilidad(habilidad)})
	
	method recibirDanio(mision){
		if(self.cumplirMision(mision))
			self.perderVida(mision.peligrosidad())
	}
	method perderVida(cantidad){
		salud-=cantidad
	}
	method finalizarMision(mision){
		if(salud > 0)
			misionesCompletadas.add(mision)
			rol.beneficio(self,mision)
		}

}

//"Roles"
object espia{
	method saludCritica() = 15
	method aprenderHabilidad(habilidad,empleado){
		empleado.habilidades().add(habilidad)
	}
	method beneficio(empleado,mision){
		const habilidadesMision = mision.habilidadesRequeridas()
		habilidadesMision.forEach({hab=>self.aprenderHabilidad(hab,empleado)})
	}
}

class Oficinista{
	var property estrellas = 0
	method saludCritica() = 40-5*estrellas
	method beneficio(empleado,mision){
		self.ganarEstrella()
		if(estrellas==3)
			empleado.rol(espia)
	}
	method ganarEstrella(){
		estrellas +=1		
	}
}

class Equipo{
	const integrantes = []
	
	method puedeHacer(mision) = integrantes.any({integrante=>integrante.cumplirMision(mision)})
	method cumplirMision(mision){
		if(self.puedeHacer(mision))
			self.recibirDanio(mision)
		}
	method recibirDanio(mision){
			integrantes.forEach({integrante=>integrante.perderVida(mision.peligrosidad()/3)})
	}
	method finalizarMision(mision)
}

class Mision{
	const habilidadesRequeridas = []
	const property peligrosidad
}
