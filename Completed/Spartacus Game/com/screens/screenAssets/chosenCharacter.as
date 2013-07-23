package com.screens.screenAssets{

	import flash.display.MovieClip;
	import flash.events.*;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.text.TextField;

	public class chosenCharacter extends MovieClip {

		/* Variables */
		private var alphaTween:Tween;

		public function chosenCharacter():void {
			createNavigation();
			init();
		}
		private function init():void {
			addEventListener(Event.ADDED_TO_STAGE, addMe);
		}
		private function addMe(event:Event):void {
			alphaTween=new Tween(this,"alpha",None.easeNone,0,1,.25,true);
		}
		private function removeMe():void {
			alphaTween.yoyo();
			alphaTween.addEventListener(TweenEvent.MOTION_FINISH, removeFromStage);
		}
		private function removeFromStage(event:TweenEvent):void {
			alphaTween.removeEventListener(TweenEvent.MOTION_FINISH, removeFromStage);
			MovieClip(this.parent).removeChild(this);
		}
		/* ------------------------------------------------------------------------- Game Navigation ------------------------------------------------------------ */
		/* We'll handle all basic game navigation with these three functions */
		private function createNavigation():void {
			makeButton(but_Play);
			makeButton(but_Back);
		}
		private function makeButton(buttonName:MovieClip):void {
			buttonName.buttonMode=true;
			buttonName.addEventListener(MouseEvent.MOUSE_DOWN, buttonClicked);
		}
		private function buttonClicked(event:MouseEvent):void {
			switch (event.target.name) {
				case "but_Play" :
					MovieClip(this.parent.parent.parent).changeScreens(MovieClip(this.parent.parent.parent).myBattleScreen);
					break;
				case "but_Back" :
					removeMe();
					break;
			}
		}
	}
}