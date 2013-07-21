package {
	import com.greensock.TweenLite;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author rhenley
	 */
	public class ScoreFeedback extends MovieClip {
		private static const TWEEN_SPEED : Number = 1;

		private var _fxTween : TweenLite;

		public function ScoreFeedback() {
			addEventListener(Event.ADDED_TO_STAGE, animateMe);
		}

		private function animateMe(event:Event) : void {
			_fxTween = new TweenLite(this, TWEEN_SPEED, {alpha: 0, scaleX: 1.5, scaleY: 1.5, onComplete: destroy});
		}

		private function destroy() : void {
			this.visible = false;
		}
	}
}
