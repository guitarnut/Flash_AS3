package com.gameFX {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	
	public class specialFX2 extends MovieClip {
		
		private var alphaTween:Tween;
		private var effectDuration:Number = 1.5;
		
		public function specialFX2():void {
			this.alpha = 0;
			init();
		}
		private function init():void {
			addEventListener(Event.ADDED_TO_STAGE, addMe);
		}
		private function addMe(event:Event):void {
			alphaTween = new Tween(this, "alpha", None.easeNone, 0, 1, effectDuration, true);
			alphaTween.addEventListener(TweenEvent.MOTION_FINISH, removeMe);
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