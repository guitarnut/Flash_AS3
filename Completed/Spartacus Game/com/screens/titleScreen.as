package com.screens{

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Timer;

	public class titleScreen extends MovieClip {

		private var myTimer:Timer;

		public function titleScreen():void {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(event:Event):void {
			startDelay();
			playMusic();
		}
		/* ------------------------------------------------------------------------- Game Navigation ------------------------------------------------------------ */
		private function startDelay():void {
			myTimer=new Timer(7000,1);
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
			myTimer.start();
		}
		private function timerHandler(event:TimerEvent):void {
			myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
			MovieClip(this.parent.parent).changeScreens(MovieClip(this.parent.parent).myInstructionsScreen);
		}
		/* ------------------------------------------------------------------------- Audio ------------------------------------------------------------ */
		private function playMusic():void {
			MovieClip(this.parent.parent).playMusic("Title");
		}
	}
}