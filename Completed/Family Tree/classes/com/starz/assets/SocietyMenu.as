package com.starz.assets {
	import com.greensock.TweenLite;

	/**
	 * @author rhenley
	 */
	public class SocietyMenu extends SocietyRankings {

		private var _transition : TweenLite;

		public function SocietyMenu() {
			this.alpha = 0;
			_transition = new TweenLite(this, .25, {paused: true, alpha: 1, onReverseComplete: visibility});
		}

		public function hideMe() : void {
			_transition.reverse();
		}

		public function showMe() : void {
			this.visible = true;
			_transition.play();
		}

		private function visibility(isVisible : Boolean = false) : void {
			this.visible = isVisible;
		}
	}
}
