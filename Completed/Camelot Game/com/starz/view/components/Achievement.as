package com.starz.view.components
{
	import flash.display.MovieClip;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import com.starz.constants.ApplicationSettings;

	public class Achievement extends MovieClip
	{

		private static const TWEEN_SPEED:Number = .25;
		private static const DELAY:Number = 3.5;
		private var _showTween:TweenLite;
		private var _hideTween:TweenLite;

		public function Achievement()
		{
			init();
		}
		private function init():void
		{
			x = 160;
			y = 80;
			addEventListener(Event.ADDED_TO_STAGE, showMe);
		}
		public function showMe(e:Event):void
		{
			alpha = 0;
			_showTween = new TweenLite(this,TWEEN_SPEED,{alpha:1,onComplete:hideMe});
		}
		public function hideMe():void
		{
			_hideTween = new TweenLite(this,TWEEN_SPEED,{delay:DELAY,alpha:0,onComplete:destroy});
		}
		public function destroy():void
		{
			MovieClip(this.parent).removeChild(this);
		}
	}
}