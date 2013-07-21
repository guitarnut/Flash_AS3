package com.components {
	import com.greensock.TweenLite;

	import flash.display.MovieClip;

	/**
	 * @author rhenley
	 */
	public class ScrollingBackground extends MovieClip {
		private static const TWEEN_SPEED : Number = 30;

		private var _tween : TweenLite;
		private var _yDistance : Number;

		public function ScrollingBackground() {
			//_yDistance = this.height - 600;
		}
		public function animateMe():void {
			//_tween = new TweenLite(this, TWEEN_SPEED, {y: this.y - _yDistance});
		}
		public function resetMe():void {
			//_tween.pause();
			//this.y = 0;
		}
	}
}
