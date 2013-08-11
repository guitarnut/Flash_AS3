package com.gnut.utils {
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.ui.Keyboard;
	
	public class UIKeyboardCommands {
		
		private var _stage:Stage;
		private var _keycode:uint;

		public function UIKeyboardCommands(_stage) {
			init(_stage);
		}
		private function init($s:Stage):void {
			_stage = $s;
		}
		private function addListeners():void {
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeypress);		
		}
		private function removeListeners():void {
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeypress);			
		}
		private function handleKeypress(e:KeyboardEvent):void {
			_keycode = e.keyCode;
			EventDispatcher.dispatchEvent(new Event(Event.CHANGE));
		}
		public function set listening($b:Boolean):void {
			if($b) {
				addListeners();
			} else {
				removeListeners();
			}
		}
		public function get keycode():uint {
			return _keycode;
		}

	}
	
}
