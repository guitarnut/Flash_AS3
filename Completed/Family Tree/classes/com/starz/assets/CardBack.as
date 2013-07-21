package com.starz.assets {
	import flash.display.MovieClip;

	/**
	 * @author rhenley
	 */
	public class CardBack extends MovieClip {

		public function CardBack() {
			hideMe();
		}

		public function showMe() : void {
			this.visible = true;
		}

		public function hideMe() : void {
			this.visible = false;
		}
	}
}
