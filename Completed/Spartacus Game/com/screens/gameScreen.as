package com.screens {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	
	public class gameScreen extends MovieClip {
		
		private var alphaTween:Tween;
		
		public function gameScreen():void {
			this.alpha = 0;
			init();
		}
		private function init():void {
			addEventListener(Event.ADDED_TO_STAGE, addMe);
		}
		private function addMe(event:Event):void {
			alphaTween = new Tween(this, "alpha", None.easeNone, 0, 1, .5, true);
		}
		public function removeMe():void {
			alphaTween.yoyo();
			alphaTween.addEventListener(TweenEvent.MOTION_FINISH, removeFromStage);
		}
		private function removeFromStage(event:TweenEvent):void {
			alphaTween.removeEventListener(TweenEvent.MOTION_FINISH, removeFromStage);
			MovieClip(this.parent).removeChild(this);
		}
	}
}