package com.screens{

	import flash.display.MovieClip;
	import flash.events.*;
	import fl.video.FLVPlayback;
	import fl.video.VideoEvent;

	public class instructionsScreen extends MovieClip {

		public function instructionsScreen():void {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(event:Event):void {
			but_Play.visible = false;
			playVideo();
		}
		/* ------------------------------------------------------------------------- Video Playback ------------------------------------------------------------ */
		private function playVideo():void {
			myFLV.source = "http://www.starz.com/videos/Spartacus_BS_NoPrem.flv";
			myFLV.play();
			myFLV.addEventListener(VideoEvent.COMPLETE, videoComplete)
		}
		private function videoComplete(event:VideoEvent):void {
			myFLV.removeEventListener(VideoEvent.COMPLETE, videoComplete);
			createNavigation();
			removeChild(textTip);
		}
		/* ------------------------------------------------------------------------- Game Navigation ------------------------------------------------------------ */
		/* We'll handle all basic game navigation with these three functions */
		private function createNavigation():void {
			makeButton(but_Play);
		}
		private function makeButton(buttonName:MovieClip):void {
			but_Play.visible = true;
			buttonName.buttonMode=true;
			buttonName.addEventListener(MouseEvent.MOUSE_DOWN, buttonClicked);
		}
		private function buttonClicked(event:MouseEvent):void {
			MovieClip(this.parent.parent).changeScreens(MovieClip(this.parent.parent).myCharacterScreen);
		}
	}
}