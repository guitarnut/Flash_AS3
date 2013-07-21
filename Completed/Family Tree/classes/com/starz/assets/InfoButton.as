package com.starz.assets {
	import com.starz.events.PillarsEvent;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @author rhenley
	 */
	public class InfoButton extends MovieClip {

		public function InfoButton() {
			addEventListener(MouseEvent.MOUSE_DOWN, handleMouseClick);
		}

		public function handleMouseClick(event : MouseEvent) : void {
			dispatchEvent(new PillarsEvent(PillarsEvent.INFO_CLICKED, true, false));
		}

		public function showMe() : void {
			this.visible = true;
		}

		public function hideMe() : void {
			this.visible = false;
		}
	}
}
