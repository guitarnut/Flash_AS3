package com.starz.view.components {
	import flash.display.MovieClip;
	
	public class MovieclipButton extends MovieClip{
		
		public var bind:Object = new Object();

		public function MovieclipButton() {
			init();
		}
		private function init():void {
			this.buttonMode = true;
			this.mouseChildren = false;
		}

	}
	
}
