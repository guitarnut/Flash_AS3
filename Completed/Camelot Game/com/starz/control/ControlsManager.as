package com.starz.control
{
	import flash.display.Sprite;
	import com.starz.events.GameEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.Stage;

	public class ControlsManager extends Sprite
	{
		private var _controlsActive:Boolean = false;
		private var _stage:Stage;

		public function ControlsManager(s$:Stage):void
		{
			_stage = s$;
			init();
		}
		private function init():void
		{
			addListeners();
		}
		private function addListeners():void
		{
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, checkKeyPress);
		}
		private function removeListeners():void
		{

		}
		private function checkKeyPress(e:KeyboardEvent):void
		{
			if (_controlsActive)
			{
				if (e.keyCode == Keyboard.UP)
				{
					dispatchEvent(new GameEvent(GameEvent.UP_KEY));
				}
				if (e.keyCode == Keyboard.DOWN)
				{
					dispatchEvent(new GameEvent(GameEvent.DOWN_KEY));
				}
				if (e.keyCode == Keyboard.LEFT)
				{
					dispatchEvent(new GameEvent(GameEvent.LEFT_KEY));
				}
				if (e.keyCode == Keyboard.RIGHT)
				{
					dispatchEvent(new GameEvent(GameEvent.RIGHT_KEY));
				}
				if (e.keyCode == Keyboard.SPACE)
				{
					dispatchEvent(new GameEvent(GameEvent.PRIMARY_KEY));
				}
				if (e.keyCode == Keyboard.SHIFT)
				{
					dispatchEvent(new GameEvent(GameEvent.SECONDARY_KEY));
				}
			}
		}
		public function controlsActive(b$:Boolean):void
		{
			_controlsActive = b$;
		}
	}
}