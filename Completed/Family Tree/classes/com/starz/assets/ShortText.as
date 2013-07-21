package com.starz.assets {
	import com.greensock.TweenLite;

	import flash.display.MovieClip;

	/**
	 * @author rhenley
	 */
	public class ShortText extends MovieClip {
		private static const TWEEN_SPEED_1 : Number = .25;

		private var _alpha : TweenLite;

		public function ShortText() : void {
			visibility();
			this.alpha = 0;
		}

		public function showMe() : void {
			visibility(true);
			_alpha = new TweenLite(this, TWEEN_SPEED_1, {alpha: 1, onReverseComplete: visibility});
		}

		public function hideMe() : void {
			if(_alpha)_alpha.reverse();
		}

		public function visibility(isVisible : Boolean = false) : void {
			this.visible = isVisible;
		}
	}
}
