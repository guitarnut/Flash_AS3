package com.components.assets {
	import com.events.LockEvent;
	import com.greensock.TweenLite;
	import com.starz.core.media.audio.AudioPlayer;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author rhenley
	 */
	public class ComboSlot extends CombinationBox {

		public var key : Number;
		public var unlocked : Boolean = false;

		private var _currentKey : Number = 1;
		private var _yTween : TweenLite;
		private var _animating : Boolean = false;
		private var _audio:AudioPlayer;

		public function ComboSlot() {
			upArrow.buttonMode = true;
			upArrow.mouseChildren = false;
			upArrow.addEventListener(MouseEvent.MOUSE_DOWN, scrollCombo);
			
			downArrow.buttonMode = true;
			downArrow.mouseChildren = false;
			downArrow.addEventListener(MouseEvent.MOUSE_DOWN, scrollCombo);
			
			addEventListener(Event.ADDED_TO_STAGE, resetAnimationStatus);
			
			_audio = new AudioPlayer();
		}

		private function scrollCombo(event : MouseEvent) : void {
			if(!_animating) {
				if((event.target.name == "upArrow") && (combinationStrip.y != -150)) {
					_animating = true;
					_currentKey++;
					_yTween = new TweenLite(combinationStrip, .8, {y: combinationStrip.y - 50, onComplete: resetAnimationStatus});
					playSlideFX();
				}
				if((event.target.name == "downArrow") && (combinationStrip.y != 0)) {
					_animating = true;
					_currentKey--;
					_yTween = new TweenLite(combinationStrip, .8, {y: combinationStrip.y + 50, onComplete: resetAnimationStatus});
					playSlideFX();
				}
			}
		}
		
		private function playSlideFX():void {
			_audio.playLocal(slide);
		}

		private function resetAnimationStatus(event : * = null) : void {
			if(_currentKey == key) {
				_audio.playLocal(click);
				unlocked = true;
				dispatchEvent(new LockEvent(LockEvent.KEY_ON, false, false));
			}
			if(_currentKey != key) {
				unlocked = false;
				dispatchEvent(new LockEvent(LockEvent.KEY_OFF, false, false));
			}
			
			_animating = false;
		}
	}
}
