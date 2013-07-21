package com.view.components {

	/**
	 * @author rhenley
	 */
	public class MovementFX extends SpaceScroller {
		private var _isScrolling:Boolean = false;
		public function MovementFX() {
			this.visible = false;
		}
		public function moveForwards():void {
			if(!_isScrolling) {
				this.visible = true;
				this.gotoAndPlay("forwards");
			}
			_isScrolling = true;
		}
		public function moveBackwards():void {
			if(!_isScrolling){
				this.visible = true;
				this.gotoAndPlay("backwards");
			}
			_isScrolling = true;
		}
		public function stopScrolling():void {
			this.stop();
			this.visible = false;
			_isScrolling = false;
		}
	}
}