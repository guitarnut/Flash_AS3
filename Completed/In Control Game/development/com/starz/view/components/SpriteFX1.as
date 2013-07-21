package com.starz.view.components {
	import flash.display.MovieClip;
	import com.greensock.TweenLite;
	import flash.events.Event;
	
	public class SpriteFX1 extends MovieClip {
		
		private static const TWEEN_SPEED:Number = .3;
		private var _tween:TweenLite;

		public function SpriteFX1() {
			init();
		}
		private function init() {
			this.alpha = 0;
			this.scaleX = .6;
			this.scaleY = .6;
			addEventListener(Event.ADDED_TO_STAGE, animate);
		}
		private function animate(e:Event):void {
			_tween = new TweenLite(this, TWEEN_SPEED, {scaleX: 1.5, scaleY: 1.5, alpha: 1, onComplete: hide});
		}
		private function hide():void {
			_tween = new TweenLite(this, TWEEN_SPEED, {alpha: 0, onComplete: destroy});
		}
		private function destroy():void {
			MovieClip(this.parent).removeChild(this);
		}
	}
	
}
