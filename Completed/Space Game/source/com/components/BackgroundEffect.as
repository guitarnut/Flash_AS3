package com.components {
	import com.greensock.TweenLite;

	import flash.display.MovieClip;

	/**
	 * @author rhenley
	 */
	public class BackgroundEffect extends MovieClip {
		private static const TWEEN_SPEED : Number = 3;

		private var _tween : TweenLite;

		public function BackgroundEffect() {
			this.alpha = 0;
		}

		public function startFX() : void {
				_tween = new TweenLite(this, TWEEN_SPEED, {alpha: .9, scaleX: 1.1, scaleY: 1.1, onComplete: reverseFX});
		}

		public function reverseFX() : void {
				_tween = new TweenLite(this, TWEEN_SPEED, {alpha: .1, scaleX: 1, scaleY: 1, onComplete: startFX});
		}

		public function stopFX() : void {
		}
	}
}
