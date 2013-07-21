package com.starz.view.components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.starz.constants.ApplicationSettings;
	import flash.display.MovieClip;
	import com.starz.events.GameEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;

	public class TVTimer extends MovieClip
	{

		private static const PANIC_TIME:Number = .65;

		public var rushTimer:Boolean = false;
		private var _tween:TweenLite;
		private var _timerTween:TweenLite;
		private var _delay:Timer;
		public var timeRemaining:Number;

		public function TVTimer():void
		{
			alpha = 0;
		}
		public function startTimer(delay:Number = 0):void
		{
			_delay = new Timer(delay * 1000,1);
			_delay.addEventListener(TimerEvent.TIMER_COMPLETE, startTimerTween);
			_delay.start();
		}
		public function setTimer(delay:Number = 0):void
		{
			_delay = new Timer(delay * 1000,1);
			_delay.addEventListener(TimerEvent.TIMER_COMPLETE, startTimerTween);
		}
		private function startTimerTween(e:TimerEvent):void
		{
			_delay.removeEventListener(TimerEvent.TIMER, startTimerTween);
			_delay.stop();
			if (_tween)
			{
				_tween.kill();
			}
			timerBar.scaleX = 0;
			_timerTween = new TweenLite(this,.25,{alpha:1});
			
			var timerSpeed:Number = MovieClip(this.parent).difficulty;
			
			if (rushTimer)
			{
				timerSpeed = timerSpeed / 2;
			}
			
			_tween = new TweenLite(timerBar,timerSpeed,{scaleX:1,onComplete:timesUp,ease:Linear.easeNone});
			addEventListener(Event.ENTER_FRAME, checkTimerStatus);
		}
		public function pauseTimer():void
		{
			timeRemaining = Math.round(timerBar.scaleX * 100);
			if (_delay)
			{
				_delay.stop();
			}
			if (_tween)
			{
				_tween.pause();
			}
		}
		public function resumeTimer():void
		{
			if (_tween)
			{
				_tween.resume();
			}
			if (_delay)
			{
				_delay.start();
			}
		}
		private function checkTimerStatus(e:Event):void
		{
			if (timerBar.scaleX > PANIC_TIME)
			{
				timeRunningOut();
			}
		}
		private function timeRunningOut():void
		{
			removeEventListener(Event.ENTER_FRAME, checkTimerStatus);
			dispatchEvent(new GameEvent(GameEvent.PANIC));
		}
		private function timesUp():void
		{
			dispatchEvent(new GameEvent(GameEvent.TIMES_UP));
			reset();
		}
		public function reset():void
		{
			rushTimer = false;
			
			if (hasEventListener(Event.ENTER_FRAME))
			{
				removeEventListener(Event.ENTER_FRAME, checkTimerStatus);
			}
			if (_delay)
			{
				_delay.stop();
			}
			if (_tween)
			{
				_tween.pause();
			}
			_timerTween = new TweenLite(this,.25,{alpha:0});
		}
	}

}