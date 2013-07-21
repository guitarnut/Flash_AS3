package com.starz.view.components
{
	import flash.display.Sprite;
	import fl.transitions.Tween;
	import com.greensock.TweenLite;

	public class MoveDisplay extends Sprite
	{
		private var _sequence:Array;
		private var _tween:TweenLite;
		public var isUser:Boolean = false;

		public function MoveDisplay()
		{
			init();
		}
		private function init():void
		{
		}
		public function storeSequence(combatSequence:Array):void {
			_sequence = combatSequence;
		}
		public function showSequence(sequenceCount:Number):void
		{
			switch (sequenceCount)
			{
				case 0 :
					slotOne.setCommand(_sequence[sequenceCount]);
					break;
				case 1 :
					slotTwo.setCommand(_sequence[sequenceCount]);
					break;
				case 2 :
					slotThree.setCommand(_sequence[sequenceCount]);
					break;
				case 3 :
					slotFour.setCommand(_sequence[sequenceCount]);
					break;
			}
		}
		public function showUserSequence(userMove:String, sequenceCount:Number):void
		{
			switch (sequenceCount)
			{
				case 0 :
					slotOne.setCommand(userMove);
					break;
				case 1 :
					slotTwo.setCommand(userMove);
					break;
				case 2 :
					slotThree.setCommand(userMove);
					break;
				case 3 :
					slotFour.setCommand(userMove);
					break;
			}
		}
		public function reset():void
		{
			slotOne.reset();
			slotTwo.reset();
			slotThree.reset();
			slotFour.reset();
		}
		public function show():void
		{
			_tween = new TweenLite(this,.25,{alpha:1});
		}
		public function hide():void
		{
			_tween = new TweenLite(this,.25,{alpha:1});
		}
	}

}