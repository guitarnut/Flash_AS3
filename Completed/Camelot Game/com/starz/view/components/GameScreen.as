package com.starz.view.components
{
	import flash.display.MovieClip;
	import com.greensock.TweenLite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.starz.events.AnalyticsEvent;
	import com.starz.core.media.audio.AudioPlayer;

	public class GameScreen extends MovieClip
	{

		protected static const TWEEN_SPEED:Number = .5;
		protected var _showTween:TweenLite;
		protected var _hideTween:TweenLite;
		protected var _music:AudioPlayer;
		protected var _soundFX:AudioPlayer;

		public function GameScreen()
		{
			init();
		}
		private function init():void
		{
			destroy();
		}
		protected function addListeners():void
		{

		}
		protected function removeListeners():void
		{

		}
		protected function playMusic(mp3:*, isMusic:Boolean = false):void
		{
			if (! _music)
			{
				_music = new AudioPlayer();
			}
			if (isMusic)
			{
				_music.playLocal(mp3);
			}
			trace("Music: "+mp3);
		}
		protected function playSoundFX(mp3:*, isFX:Boolean = false):void
		{
			if (! _soundFX)
			{
				_soundFX = new AudioPlayer();
			}
			if (isFX)
			{
				_soundFX.playLocal(mp3);
			}
			trace("SoundFX: "+mp3);
		}
		public function showMe():void
		{
			alpha = 0;
			visible = true;
			_showTween = new TweenLite(this,TWEEN_SPEED,{alpha:1});
		}
		public function hideMe():void
		{
			if (_music)
			{
				_music.fadeOut();
			}
			_hideTween = new TweenLite(this,TWEEN_SPEED,{alpha:0,onComplete:destroy});
		}
		public function destroy():void
		{
			visible = false;
		}
		protected function pauseGame(delay:Number, callBack:Array, callbackArguments:Array):void
		{
			var timer:Timer = new Timer(delay * 1000,1);
			timer.addEventListener(TimerEvent.TIMER, runCallback);
			timer.start();
			function runCallback(e:TimerEvent):void
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, runCallback);
				for (var i:Number = 0; i< callBack.length; i++)
				{
					if (callbackArguments[i] != null)
					{
						callBack[i](callbackArguments[i]);
					}
					else
					{
						callBack[i]();
					}
				}

			}
		}
		protected function analytics(eventData:String):void
		{
			var analyticsData:Object = new Object();
			analyticsData.data = eventData;
			dispatchEvent(new AnalyticsEvent(AnalyticsEvent.EVENT_TRACKING, analyticsData));
		}
	}

}