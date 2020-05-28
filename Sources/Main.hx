package;

import kha.Assets;
import kha.Scheduler;
import kha.System;

class Main {
	public static function main() {
		kha.System.start({title: "Project", width: 1024, height: 768}, function (_) {
			kha.Assets.loadEverything(function () {
				var app = new App();
				kha.Scheduler.addTimeTask(function () { app.update(); }, 0, 1 / 60);
				kha.System.notifyOnFrames(function (frames) { app.render(frames[0]); });
			});
		});
	}
}
