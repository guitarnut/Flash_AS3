package com.starz.view.components
{
	import flash.display.MovieClip;
	import com.starz.events.GameEvent;
	import com.starz.control.ControlsManager;
	import flash.events.Event;
	import com.starz.core.media.audio.AudioPlayer;

	public class AnimatedCharacter extends MovieClip
	{
		public var animating:Boolean = false;
		private var _controls:ControlsManager;
		private var _combatSequence:Array;
		public var requiredSequence:Array;
		private var _userSequence:Array;
		private var _sequenceCount:Number;
		protected var _soundFX:AudioPlayer;

		public function AnimatedCharacter():void
		{

		}
		private function init(e:Event):void
		{
			addListeners();
		}
		private function addListeners():void
		{

		}
		private function removeListeners():void
		{

		}
		public function bindControls(controls:ControlsManager):void
		{
			_controls = controls;
			_controls.addEventListener(GameEvent.UP_KEY, playAnimation);
			_controls.addEventListener(GameEvent.DOWN_KEY, playAnimation);
			_controls.addEventListener(GameEvent.LEFT_KEY, playAnimation);
			_controls.addEventListener(GameEvent.RIGHT_KEY, playAnimation);
		}
		public function playAnimation(e:GameEvent):void
		{
			if (! animating)
			{
				switch (e.type)
				{
					case GameEvent.RIGHT_KEY :
						gotoAndPlay("Chop");
						playSoundFX(new sword(), true);
						break;
					case GameEvent.LEFT_KEY :
						gotoAndPlay("Block");
						playSoundFX(new grunt1(), true);
						break;
					case GameEvent.UP_KEY :
						gotoAndPlay("Jump");
						playSoundFX(new grunt2(), true);
						break;
					case GameEvent.DOWN_KEY :
						gotoAndPlay("Kneel");
						playSoundFX(new grunt1(), true);
						break;
				}
				advanceUserMoveDisplay(e.type);
				animating = true;
			}
		}
		public function playSequence(combatSequence:Array = null):void
		{
			if (combatSequence)
			{
				_combatSequence = new Array();
				_combatSequence = combatSequence;
				_sequenceCount = 0;
			}
			if ((!animating)&&(_combatSequence.length>=1))
			{
				if (! hasEventListener(Event.ENTER_FRAME))
				{
					addEventListener(Event.ENTER_FRAME, continueSequence);
				}
				switch (_combatSequence[0])
				{
					case GameEvent.RIGHT_KEY :
						gotoAndPlay("Chop");
						break;
					case GameEvent.LEFT_KEY :
						gotoAndPlay("Block");
						break;
					case GameEvent.UP_KEY :
						gotoAndPlay("Jump");
						break;
					case GameEvent.DOWN_KEY :
						gotoAndPlay("Kneel");
						break;
				}
				animating = true;
				advanceMoveDisplay();
				_combatSequence = _combatSequence.slice(1);
			}
			if (_combatSequence.length == 0)
			{
				dispatchEvent(new GameEvent(GameEvent.DEMONSTRATION_COMPLETE));

			}
		}
		private function playSoundFX(mp3:*, isFX:Boolean = false):void
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
		private function advanceMoveDisplay():void
		{
			var gameData:Object = new Object();
			gameData.sequenceCount = _sequenceCount;

			dispatchEvent(new GameEvent(GameEvent.MOVEMENT_COMPLETE, gameData));

			_sequenceCount++;
		}
		private function advanceUserMoveDisplay(userMove:String):void
		{
			var gameData:Object = new Object();
			gameData.userMove = userMove;

			dispatchEvent(new GameEvent(GameEvent.MOVEMENT_COMPLETE, gameData));
		}
		private function continueSequence(e:Event = null):void
		{
			if (! animating)
			{
				if (_combatSequence.length != 0)
				{
					playSequence();
				}
				else
				{
					removeEventListener(Event.ENTER_FRAME, continueSequence);
				}
			}
		}
		public function reset():void {
			_controls.removeEventListener(GameEvent.UP_KEY, playAnimation);
			_controls.removeEventListener(GameEvent.DOWN_KEY, playAnimation);
			_controls.removeEventListener(GameEvent.LEFT_KEY, playAnimation);
			_controls.removeEventListener(GameEvent.RIGHT_KEY, playAnimation);
			_controls = null;
		}
	}
}