package com.starz.assets {
	import com.starz.events.PillarsEvent;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @author rhenley
	 */
	public class FlipButton extends MovieClip {

		public function FlipButton() : void {
			hideMe();
			addEventListener(MouseEvent.MOUSE_DOWN, handleMouseClick);
		}

		public function handleMouseClick(event : MouseEvent) : void {
			dispatchEvent(new PillarsEvent(PillarsEvent.FLIP_CLICKED, true, false));
		}

		public function showMe() : void {
			this.visible = true;
		}

		public function hideMe() : void {
			this.visible = false;
		}
	}
}
