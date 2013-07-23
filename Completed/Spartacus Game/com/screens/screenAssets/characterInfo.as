package com.screens.screenAssets{

	import flash.display.MovieClip;
	import flash.events.*;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.text.TextField;

	public class characterInfo extends MovieClip {

		/* Variables */
		private var alphaTween:Tween;

		public function characterInfo():void {
			init();
		}
		private function init():void {
			addEventListener(Event.ADDED_TO_STAGE, addMe);
			this.x = 100;
			this.y = 275;
		}
		private function addMe(event:Event):void {
			alphaTween=new Tween(this,"alpha",None.easeNone,0,1,.25,true);
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