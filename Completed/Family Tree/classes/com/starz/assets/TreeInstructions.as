package com.starz.assets {
	import com.greensock.TweenLite;

	import flash.events.MouseEvent;

	/**
	 * @author rhenley
	 */
	public class TreeInstructions extends Instructions {
		private var _tween : TweenLite;

		public function TreeInstructions() {			
			this.visible = false;
			this.alpha = 0;
			
			closeButton.buttonMode = true;
			closeButton.mouseChildren = false;
			closeButton.addEventListener(MouseEvent.MOUSE_DOWN, closeMe);
		}

		public function showMe() : void {
			this.visible = true;
			_tween = new TweenLite(this, .5, {alpha: 1, onReverseComplete: hideMe});
		}

		private function closeMe(event : MouseEvent) : void {
			_tween.reverse();
		}

		public function hideMe() : void {
			this.alpha = 0;
			this.visible = false;
		}
	}
}
