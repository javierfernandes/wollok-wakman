import wollok.game.*

class Posicionable {
	var property position
	
}

class Ghost inherits Posicionable {
	var color
	
	method image() = if (wakman.isSuper())
							"ghost-scared.png"
						else 
							"ghost-" + color.getName() + ".png"
	
	method hittedWithWakman(wakman) {
		wakman.hittedWithGhost(self)
	}
	
	method eaten() {
//		position = game.at(-1,-1)
//		self.posicion().x(-1)
//		self.posicion().y(-1)
		game.removeVisual(self)
	}
}

//object colores {
	object orange { method getName() = "orange" }
	object pink { method getName() = "pink" }
	object red { method getName() = "red" }
	object cyan { method getName() = "cyan" }
//}



class Cherry inherits Posicionable {
	method image() = "cherry.png"
	
	method hittedWithWakman(wak) {
		wak.eatCherry(self)
	}
}

object wakmanRegularMode {
	method hittedWithGhost(wak, ghost) {
		// you loose !
		game.say(wak, "You loose!")
//		wak.posicion().x(5)
//		wak.posicion().y(5)
		wak.position(game.at(5,5))
	}
}

object wakmanSuperMode {
	method hittedWithGhost(wak, ghost) {
		ghost.eaten()
	}
}

object wakman inherits Posicionable(position = game.at(5, 5)) {
	var mode = wakmanRegularMode
	var imageCounter = 0
	var modeCounter = 0
	
	method image() {
		modeCounter+=1
		self.checkMode()
		imageCounter+=1
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
		game.removeVisual(cherry) //TODO: Not Safe!
//		cherry.posicion().x(-1)
//		cherry.posicion().y(-1)
//		cherry.position(game.at(-1,-1))

	}
	method hittedWithGhost(ghost) {
		mode.hittedWithGhost(self, ghost)	
	}
	
	method isSuper() = [wakmanSuperMode].contains(mode)
}

class GhostMovement {
	var timeCounter = 0
	var move = 1
	var property position
	
	method move(ghost) {
		timeCounter+=1
		if (timeCounter > 40) {			
			position = position.right(move)
			move = -move
			timeCounter = 0
		}
	}
	
	method hittedWithWakman(wak) { }
	
	method image() = "ground.png"
}
