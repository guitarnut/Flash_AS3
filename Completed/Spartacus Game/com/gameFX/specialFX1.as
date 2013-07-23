package com.gameFX {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	
	public class specialFX1 extends MovieClip {
		
		private var alphaTween:Tween;
		private var xScale:Tween;
		private var yScale:Tween;
		
		public function specialFX1():void {
			this.alpha = 0;
			this.x = 400;
			this.y = 300;
			init();
		}
		private function init():void {
			addEventListener(Event.ADDED_TO_STAGE, addMe);
		}
		private function addMe(event:Event):void {
			alphaTween = new Tween(this, "alpha", None.easeNone, 0, 1, 1, true);
			alphaTween.addEventListener(TweenEvent.MOTION_FINISH, removeMe);
			//xScale = new Tween(this, "scaleX", None.easeNone, 1, 1.2, 1, true);
			//yScale = new Tween(this, "scaleY", None.easeNone, 1, 1.2, 1, true);
		}
		public function removeMe(event:TweenEvent):void {
			alphaTween.removeEventListener(TweenEvent.MOTION_FINISH, removeMe);
			alphaTween.yoyo();
			alphaTween.addEventListener(TweenEvent.MOTION_FINISH, removeFromStage);
		}
		private function removeFromStage(event:TweenEvent):void {
			alphaTween.removeEventListener(TweenEvent.MOTION_FINISH, removeFromStage);
			MovieClip(this.parent).removeChild(this);
		}
	}
}