package com.starz.view.screens
{
	import flash.display.MovieClip;
	import com.greensock.TweenLite;
	import flash.events.Event;

	public class TransitionScreen extends MovieClip
	{
		private static const TWEEN_SPEED:Number = 1;
		private var _squares:Array;
		private var _lastTween:TweenLite;

		public function TransitionScreen()
		{
			init();
		}
		private function init():void
		{
			_squares = new Array();

			for (var i:Number = 0; i < this.numChildren; i++)
			{
				_squares.push(this.getChildAt(i));
				MovieClip(this.getChildAt(i)).alpha = 0;
				MovieClip(this.getChildAt(i)).scaleX = 0;
				MovieClip(this.getChildAt(i)).scaleY = 0;
			}
		}
		public function show():void
		{
			this.visible = true;
			for (var i:Number = 0; i <= _squares.length-2; i++)
			{
				new TweenLite(_squares[i],Math.random() * TWEEN_SPEED,{alpha:1, scaleX: 1, scaleY: 1});
			}
			_lastTween = new TweenLite(_squares[_squares.length - 1],TWEEN_SPEED,{alpha:1, scaleX: 1, scaleY: 1, onComplete:hide});
		}
		private function hide():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
			
			for (var i:Number = 0; i <= _squares.length-2; i++)
			{
				new TweenLite(_squares[i],Math.random() * TWEEN_SPEED,{alpha:0, scaleX: 0, scaleY: 0});
			}
			_lastTween = new TweenLite(_squares[_squares.length - 1],TWEEN_SPEED,{alpha:0, scaleX: 0, scaleY: 0, onComplete:destroy});
		}
		private function destroy():void
		{
			this.visible = false;
		}
	}
}