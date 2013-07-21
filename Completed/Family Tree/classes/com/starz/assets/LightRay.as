package com.starz.assets {
	import com.greensock.TweenLite;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author rhenley
	 */
	public class LightRay extends Light {
		private var _tween : TweenLite;

		public function LightRay() {
			this.alpha = 0;
			this.scaleY = 0;
		}

		public function determineAngle(startingX : Number, startingY : Number, endingX : Number, endingY : Number) : void {
			var myX : Number = endingX - startingX;
			var myY : Number = endingY - startingY;
			var angle : Number = Math.atan2(myY, myX);
			angle = angle * (180 / Math.PI)
			this.rotation = angle;
			if(width < 0)width *= -1;
		}

		public function showMe() : void {
			_tween = new TweenLite(this, 2, {scaleY: 1, alpha: 1});
		}

		public function hideMe() : void {
			_tween = new TweenLite(this, .5, {scaleY: 0, alpha: 0, onComplete: removeMe});
		}

		public function removeMe() : void {
			DisplayObjectContainer(this.parent).removeChild(this);
		}
	}
}
