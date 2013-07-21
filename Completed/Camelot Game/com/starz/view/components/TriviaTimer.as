package com.starz.view.components {
	import com.greensock.TweenLite;
	import com.starz.constants.ApplicationSettings;
	import flash.display.MovieClip;
	import com.starz.events.GameEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class TriviaTimer extends MovieClip {
		
		private var _tween:TweenLite;
		private var _delay:Timer;
		public var timeRemaining:Number;

		public function TriviaTimer():void {
			
		}
		public function startTimer(delay:Number = 0):void {
			_delay = new Timer(delay*1000, 0);
			_delay.addEventListener(TimerEvent.TIMER, startTimerTween);
			_delay.start();
		}
		private function startTimerTween(e:TimerEvent):void {
			_delay.removeEventListener(TimerEvent.TIMER, startTimerTween);
			_tween = new TweenLite(timerBar, ApplicationSettings.TRIVIA_QUESTION_TIME, {scaleX:0, onComplete: timesUp});
		}
		public function pauseTimer():void {
			timeRemaining = Math.round(timerBar.scaleX*100);
			_delay.stop();
			if(_tween) {
				_tween.pause();
			}
		}
		public function resumeTimer():void {
			_tween.resume();
		}
		private function timesUp():void {
			dispatchEvent(new GameEvent(GameEvent.TIMES_UP));
		}
		public function reset():void {
			timerBar.scaleX = 1;
		}
	}
	
}
