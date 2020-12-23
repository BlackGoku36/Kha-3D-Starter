package;

import kha.math.FastVector3;
import kha.math.FastMatrix4;

class CameraController {

	public var mvp:FastMatrix4;

	public var model:FastMatrix4;
	public var view:FastMatrix4;
	public var projection:FastMatrix4;

	public var position:FastVector3;
	public var look:FastVector3;
	public var up:FastVector3;

	var mouse = Input.getMouse();
	var kb = Input.getKeyboard();

	var horizontalAngle = 3.14;
	var verticalAngle = -0.52;

	var speed = 0.1;
	var mouseSpeed = 0.005;

	public function new() {
		position = new FastVector3(0.0, 5.0, 10.0);
		projection = FastMatrix4.perspectiveProjection(45.0, 4.0 / 3.0, 0.1, 100.0);

		view = FastMatrix4.lookAt(new FastVector3(0, 0, 0), new FastVector3(0, 0, 0), new FastVector3(0, 1, 0));

		model = FastMatrix4.identity();

		mvp = FastMatrix4.identity();
		mvp = mvp.multmat(projection);
		mvp = mvp.multmat(view);
		mvp = mvp.multmat(model);
	}

	public function update() {

		if (mouse.down(1)) {
			horizontalAngle += mouseSpeed * mouse.movementX * -1;
			verticalAngle += mouseSpeed * mouse.movementY * -1;
		}

		var direction = new FastVector3(Math.cos(verticalAngle) * Math.sin(horizontalAngle), Math.sin(verticalAngle),
		Math.cos(verticalAngle) * Math.cos(horizontalAngle));

		var right = new FastVector3(Math.sin(horizontalAngle - 3.14 / 2.0), 0, Math.cos(horizontalAngle - 3.14 / 2.0));

		up = right.cross(direction);


		if (kb.down(W)) {
			var v = direction.mult(speed);
			position = position.add(v);
		}
		if (kb.down(S)) {
			var v = direction.mult(speed * -1);
			position = position.add(v);
		}
		if (kb.down(D)) {
			var v = right.mult(speed);
			position = position.add(v);
		}
		if (kb.down(A)) {
			var v = right.mult(speed * -1);
			position = position.add(v);
		}
		if(kb.down(Q)){
			var v = up.mult(speed * -1);
			position = position.add(v);
		}
		if(kb.down(E)){
			var v = up.mult(speed);
			position = position.add(v);
		}

		if(kb.down(Shift))
			speed = 0.2;
		else
			speed = 0.1;

		look = position.add(direction);

		view = FastMatrix4.lookAt(position, look, up);

		mvp = FastMatrix4.identity();
		mvp = mvp.multmat(projection);
		mvp = mvp.multmat(view);
		mvp = mvp.multmat(model);

	}
}