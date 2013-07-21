package com.starz.assets {

	import flash.display.MovieClip;

	/**
	 * @author rhenley
	 */
	public class SocietyButton extends MovieClip {
		
		public function SocietyButton():void {
			this.buttonMode = true;
		}

		public function showMe() : void {
			this.visible = true;
		}

		public function hideMe() : void {
			this.visible = false;
		}
	}
}
