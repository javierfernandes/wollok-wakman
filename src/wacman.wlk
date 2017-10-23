class Posicionable {
	var posicion
	constructor(p) { posicion = p }
	
	method posicion() = posicion
	method posicion(_posicion) { posicion = _posicion }
}

class Ghost inherits Posicionable {
	var color
	
	constructor(_posicion, _color) = super(_posicion) {
		color = _color
	}
	method imagen() = if (wakman.isSuper())
							"ghost-scared.png"
						else 
							"ghost-" + color.getName() + ".png"
	
	method hittedWithWakman(wakman) {
		wakman.hittedWithGhost(self)
	}
	
	method eaten() {
		self.posicion().x(-1)
		self.posicion().y(-1)
	}
}

//object colores {
	object orange { method getName() = "orange" }
	object pink { method getName() = "pink" }
	object red { method getName() = "red" }
	object cyan { method getName() = "cyan" }
//}



class Cherry inherits Posicionable {
	constructor(_position) = super(_position)
	method imagen() = "cherry.png"
	
	method hittedWithWakman(wak) {
		wak.eatCherry(self)
	}
}

object wakmanRegularMode {
	method hittedWithGhost(wak, ghost) {
		// you loose !
		game.say(wak, "You loose!")
		wak.posicion().x(5)
		wak.posicion().y(5)
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
	
	method imagen() {
		modeCounter++
		self.checkMode()
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
		something.hittedWithWakman(self)	
	}
	method eatCherry(cherry) {
		mode = wakmanSuperMode
		// game.removeVisual(cherry) TODO: Not Safe!
		cherry.posicion().x(-1)
		cherry.posicion().y(-1)
	}
	method hittedWithGhost(ghost) {
		mode.hittedWithGhost(self, ghost)	
	}
	
	method isSuper() = [wakmanSuperMode].contains(mode)
}

class GhostMovement {
	var timeCounter = 0
	var move = 1
	const posicion
	
	constructor(p) { posicion = p }
	
	method move(ghost) {
		timeCounter++
		if (timeCounter > 40) {			
			posicion.moveRight(move)
			move = -move
			timeCounter = 0
		}
	}
	
	method hittedWithWakman(wak) { }
	
	method image() = "ground.png"
}
