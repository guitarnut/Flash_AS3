package com.gnut.utils {
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.Sprite;
	import com.gnut.events.PresentationEvent;
	
	public class UIKeyboardCommands extends Sprite {
		
		private var _stage:Stage;
		private var _keycode:uint;

		public function UIKeyboardCommands(_stage) {
			init(_stage);
		}
		private function init($s:Stage):void {
			_stage = $s;
			addListeners();
		}
		private function addListeners():void {
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeypress);		
		}
		private function removeListeners():void {
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeypress);			
		}
		private function handleKeypress(e:KeyboardEvent):void {
			_keycode = e.keyCode;
			
			if(_keycode == 37) {
				dispatchEvent(new PresentationEvent(PresentationEvent.GO_BACK));
			}
			
			if(_keycode == 39) {
				dispatchEvent(new PresentationEvent(PresentationEvent.ADVANCE));
			}
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
