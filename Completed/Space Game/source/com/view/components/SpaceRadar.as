package com.view.components {

	/**
	 * @author rhenley
	 */
	public class SpaceRadar extends Radar {
		private var _spaceWidth : Number;
		private var _spaceHeight : Number;

		public function SpaceRadar(spaceWidth : Number, spaceHeight : Number) : void {
			_spaceWidth = spaceWidth;
			_spaceHeight = spaceHeight;
			this.alpha = .5;
		}

		public function updateRadar(objects : Array) : void {
			for (var i : Number = radarScreen.numChildren;i > 1;i--) {
				radarScreen.removeChildAt(i - 1);
			}
			for (var j : Number = 0;j < objects.length;j++) {
				if(objects[j].isVisible) {
					if((objects[j].x > 0) && (objects[j].x < _spaceWidth) && (objects[j].y > 0) && (objects[j].y < _spaceHeight)) {
						var blip : RadarBlip = new RadarBlip();
						blip.x = objects[j].x * (this.width / _spaceWidth);
						blip.y = objects[j].y * (this.width / _spaceHeight);
						radarScreen.addChild(blip);
					}
				}
			}
		}
	}
}