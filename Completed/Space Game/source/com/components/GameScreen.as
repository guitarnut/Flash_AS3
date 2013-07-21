package com.components {
	import fl.video.VideoEvent;

	import com.events.SpaceEvent;
	import com.greensock.TweenLite;
	import com.starz.core.utils.Debug;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author rhenley
	 */
	public class GameScreen extends MovieClip {
		private static const SCREEN_DELAY : Number = 3;
		private var _timer : Timer;

		public function GameScreen() {
			this.stop();
			this.alpha = 0;
			addEventListener(Event.ADDED_TO_STAGE, showMe);
			configureMenu();
			configureVideo();
		}

		public function showMe(event : Event = null) : void {
			this.visible = true;
			new TweenLite(this, .5, {alpha: 1});
			startFX();
		}

		public function startDelay(delay : Number = SCREEN_DELAY) : void {
			_timer = new Timer(delay * 1000, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, hideMe);
			_timer.start();
		}

		public function hideMe(event : TimerEvent = null) : void {
			if(event != null) {
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, hideMe);
			}
			new TweenLite(this, .5, {alpha: 0, onComplete: removeMe});
			dispatchEvent(new SpaceEvent(SpaceEvent.NEXT_SCREEN, false, false));
		}

		private function removeMe() : void {
			stopFX();
			this.visible = false;
			try {
				Debug.log("Removed " + this.name);
				Sprite(this.parent).removeChild(this);
			} catch (e : Error) {
				Debug.log("Unable to remove " + this.name);
			}
		}

		private function configureMenu() : void {
			for(var i : Number = 0;i < this.numChildren;i++) {
				if(getChildAt(i).name == "menu") {
					MovieClip(getChildAt(i)).playGame.buttonMode = true;
					MovieClip(getChildAt(i)).playGame.addEventListener(MouseEvent.MOUSE_DOWN, startGame);
					MovieClip(getChildAt(i)).instructions.buttonMode = true;
					MovieClip(getChildAt(i)).instructions.addEventListener(MouseEvent.MOUSE_DOWN, showInstructions);
				}
			}
		}

		private function configureVideo() : void {
			for(var i : Number = 0;i < this.numChildren;i++) {
				if(getChildAt(i).name == "videoPlayer") {
					MovieClip(getChildAt(i)).visible = false;
				}
			}
		}

		public function playVideo() : void {
			for(var i : Number = 0;i < this.numChildren;i++) {
				if(getChildAt(i).name == "videoPlayer") {
					MovieClip(getChildAt(i)).visible = true;
					MovieClip(getChildAt(i)).myFLV.seek(0);
					MovieClip(getChildAt(i)).myFLV.play();
					MovieClip(getChildAt(i)).myFLV.addEventListener(VideoEvent.COMPLETE, startGame);
					MovieClip(getChildAt(i)).closeVideo.buttonMode = true;
					MovieClip(getChildAt(i)).closeVideo.mouseChildren = false;
					MovieClip(getChildAt(i)).closeVideo.addEventListener(MouseEvent.MOUSE_DOWN, startGame);
				}
			}
		}

		private function startFX() : void {
			for(var i : Number = 0;i < this.numChildren;i++) {
				if(getChildAt(i).name == "backgroundFX") {
					try {
						MovieClip(getChildAt(i)).startFX();
					} catch(e : Error) {
					}
				}
			}
		}

		private function stopFX() : void {
			for(var i : Number = 0;i < this.numChildren;i++) {
				if(getChildAt(i).name == "backgroundFX") {
					try {
						MovieClip(getChildAt(i)).stopFX();
					} catch(e : Error) {
					}
				}
			}
		}

		private function startGame(event : *) : void {
			for(var i : Number = 0;i < this.numChildren;i++) {
				if(getChildAt(i).name == "videoPlayer") {
					MovieClip(getChildAt(i)).myFLV.stop();
					MovieClip(getChildAt(i)).visible = false;
				}
			}
			dispatchEvent(new SpaceEvent(SpaceEvent.PLAY, true, true));
		}

		private function showInstructions(event : MouseEvent) : void {
			dispatchEvent(new SpaceEvent(SpaceEvent.INSTRUCTIONS, true, true));
		}
	}
}
