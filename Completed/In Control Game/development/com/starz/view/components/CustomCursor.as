package com.starz.view.components {
	import com.starz.view.behaviors.RotateToMouse;
	import flash.ui.Mouse;
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class CustomCursor extends MovieClip {

		public function CustomCursor() {
			this.visible = false;
			mouseEnabled = false;
			mouseChildren = false;
		}
		public function show():void {
			Mouse.hide();
			this.visible = true;
			addEventListener(Event.ENTER_FRAME, followMouse);
			addEventListener(Event.MOUSE_LEAVE, hideCursor);
		}
		public function hide():void {
			Mouse.show();
			this.visible = false;
			removeEventListener(Event.ENTER_FRAME, followMouse);
			removeEventListener(Event.MOUSE_LEAVE, hideCursor);
		}
		private function followMouse(e:Event):void {
			this.visible = true;
			this.x = stage.mouseX;
			this.y = stage.mouseY;
		}
		private function hideCursor(e:Event):void {
			this.visible = false;
		}

	}
	
}
