class Posicionable {
	var posicion
	new(p) { posicion = p }
	
	method getPosicion() = posicion
	method setPosicion(_posicion) { posicion = _posicion }
}

class Ghost inherits Posicionable {
	var color
	
	new(_posicion, _color) = super(_posicion) {
		color = _color
	}
	method getImagen() = if (wakman.isSuper())
							"ghost-scared.png"
						else 
							"ghost-" + color.getName() + ".png"
	
	method hittedWithWakman(wakman) {
		wakman.hittedWithGhost(this)
	}
	
	method eaten() {
		this.getPosicion().setX(-1)
		this.getPosicion().setY(-1)
	}
}

//object colores {
	object orange { method getName() = "orange" }
	object pink { method getName() = "pink" }
	object red { method getName() = "red" }
	object cyan { method getName() = "cyan" }
//}



class Cherry inherits Posicionable {
	new(_position) = super(_position)
	method getImagen() = "cherry.png"
	
	method hittedWithWakman(wak) {
		wak.eatCherry(this)
	}
}

object wakmanRegularMode {
	method hittedWithGhost(wak, ghost) {
		// you loose !
		wak.getPosicion().setX(5)
		wak.getPosicion().setY(5)
		//wak.say("You loose!")
	}
}

object wakmanSuperMode {
	method hittedWithGhost(wak, ghost) {
		ghost.eaten()
	}
}

object wakman inherits Posicionable(new Position(5, 5)) {
	var mode = wakmanRegularMode
	var imageCounter = 0
	var modeCounter = 0
	
	method getImagen() = {
		modeCounter++
		this.checkMode()
		imageCounter++
		if (imageCounter > 10) {
			if (imageCounter == 20) imageCounter = 0
			return "wakman-closed.png"
		}
		return "wakman.png" 
	}
	
	method checkMode() {
		if (modeCounter == 400) {
			mode = wakmanRegularMode
			modeCounter = 0
		}
	} 
	
	method hittedWith(something) {
		something.hittedWithWakman(this)	
	}
	method eatCherry(cherry) {
		mode = wakmanSuperMode
		// TODO: remove the cherry!
		cherry.getPosicion().setX(-1)
		cherry.getPosicion().setY(-1)
	}
	method hittedWithGhost(ghost) {
		mode.hittedWithGhost(this, ghost)	
	}
	method isSuper() = mode == wakmanSuperMode
}
