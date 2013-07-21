package com.starz.view.components
{
	import flash.display.Sprite;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import com.starz.events.GameEvent;

	public class MoveSlot extends Sprite
	{
		private var _tween:TweenLite;
		public var currentCommand:MovieClip;

		public function MoveSlot()
		{
			init();
		}
		private function init():void
		{
			upArrow.alpha = 0;
			downArrow.alpha = 0;
			leftArrow.alpha = 0;
			rightArrow.alpha = 0;
			incorrect.alpha = 0;
		}
		public function setCommand(eventType:String):void
		{
			switch (eventType)
			{
				case GameEvent.UP_KEY :
					showCommand(upArrow);
					break;
				case GameEvent.DOWN_KEY :
					showCommand(downArrow);
					break;
				case GameEvent.LEFT_KEY :
					showCommand(leftArrow);
					break;
				case GameEvent.RIGHT_KEY :
					showCommand(rightArrow);
					break;
			}
		}
		private function showCommand(command:MovieClip):void
		{
			currentCommand = command;
			if (! MoveDisplay(this.parent).isUser)
			{
				_tween = new TweenLite(currentCommand,.25,{alpha:1, onComplete: eraseCommand});
			} else {
				_tween = new TweenLite(currentCommand,.25,{alpha:1});
			}
		}
		public function wrongAnswer():void
		{
			incorrect.alpha = 1;
		}
		private function eraseCommand():void {
			_tween = new TweenLite(currentCommand,.25,{delay: 1, alpha:0});
		}
		public function reset():void
		{
			incorrect.alpha = 0;
			if (currentCommand)
			{
				currentCommand.alpha = 0;
				currentCommand = null;
			}
		}
	}

}