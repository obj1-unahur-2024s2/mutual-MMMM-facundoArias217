class Actividad{
    const property idiomas = [] 

    method esInteresante() = idiomas.size() > 1
    method sirveParaBroncearse() = true
    method dias()
    method esRecomendable(unSocio){
        return self.esInteresante() &&
            unSocio.leAtrae(self) &&
            !unSocio.actsRealizadas().contains(self)
    }
}

class ViajeDePlaya inherits Actividad{
    const largo

    method implicaEsfuerzo() = largo > 1200
    override method dias() = largo / 500
}

class ExcursionACiudad inherits Actividad{
    var property cantAtracciones
    override method dias() = cantAtracciones / 2
    method implicaEsfuerzo() = cantAtracciones.between(5, 8)
    override method sirveParaBroncearse() = false
    override method esInteresante() = super() || cantAtracciones == 5
}

class ExcursionTropical inherits ExcursionACiudad{

    override method dias() = super() + 1
    override method sirveParaBroncearse() = true
}

class SalidaDeTrakking inherits Actividad {
    const kmDeSenderos
    const diasDeSolAlAnio

    override method dias() = kmDeSenderos / 50
    method implicaEsfuerzo() = kmDeSenderos > 80
    override method sirveParaBroncearse() {
        return (diasDeSolAlAnio > 200) || 
               (diasDeSolAlAnio.between(100, 200) && kmDeSenderos > 120)
    }
    override method esInteresante() = super() || diasDeSolAlAnio > 140
  
}

class ClaseDeGimnasia inherits Actividad{

    method initialize(){
         idiomas.clear()
         idiomas.add("español")
            if (idiomas != ["español"]) self.error("Solo se permite clase de gim en español")
    }
    override method dias() = 1
    method implicaEsfuerzo() = true
    override method sirveParaBroncearse() = false
}

class TallerLiterario inherits Actividad{
    const property libros = #{}

    method initialize(){
        idiomas.clear()
        idiomas.addAll(libros.map({i => i.idioma()}))
    }
    override method dias() = libros.size() + 1
    method implicaEsfuerzo() = libros.any({l=> l.cantPaginas() > 500}) || 
                               (libros.size() > 1 && libros.map({l => l.nombreDelAutor()}).asSet().size())  
    override method sirveParaBroncearse() = false
    override method esRecomendable(unSocio) {return
        unSocio.idiomas().size() > 1
    }

}

class Libro{
    const property idioma
    const property nombreDelAutor
    const property cantPaginas 
}

class Socio{
    const property actsRealizadas = []
    const maximoActividades
    var edad
    const property idiomas = #{}

    method edad() = edad
    method esAdoradorDelSol() = actsRealizadas.all({a => a.sirveParaBroncearse()})
    method activiadesEsforzadas() = actsRealizadas.filter({a => a.implicaEsfuerzo()})
    method registrarActividad(unaActividad){
        if(maximoActividades == actsRealizadas.size()) self.error("Alcanzó el maximo de actividades")
        actsRealizadas.add(unaActividad)
    }
    method leAtrae(unaActividad)
}

class SocioTranquilo inherits Socio{
    override method leAtrae(unaActividad) = unaActividad.dias() >= 4 
}

class SocioCoherente inherits Socio{
    override method leAtrae(unaActividad) {
        return
        if(self.esAdoradorDelSol()) {unaActividad.sirveParaBroncearse()}
        else (unaActividad.implicaEsfuerzo())
    }

}

class SocioRelajado inherits Socio{
    override method leAtrae(unaActividad){
        return not idiomas.intersection(unaActividad.idiomas().isEmpty())
    }
}