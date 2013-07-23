package com {
	import com.components.Box;
	import com.components.ComboLock;
	import com.events.LockEvent;
	import com.starz.core.media.audio.AudioPlayer;
	import com.starz.core.utils.Debug;

	import flash.display.Sprite;

	/**
	 * @author rhenley
	 */
	public class LockBox extends Sprite {

		private var _lockBox : Box;
		private var _comboLock : ComboLock;
		private var _audio:AudioPlayer;

		public function LockBox() {
			Debug.password = "starz";
			Debug.clear();
			
			buildLock();
			buildLockbox();
			
			addChild(_lockBox);
			addChild(_comboLock);
			
			_audio = new AudioPlayer();
			_audio.loadSound("background.mp3", true, true);
		}

		private function buildLock() : void {
			_comboLock = new ComboLock(1, 2, 3, 4);
			_comboLock.x = 100;
			_comboLock.y = 100;
			_comboLock.addEventListener(LockEvent.UNLOCK, unlockBox);
		}

		private function buildLockbox() : void {
			_lockBox = new Box();
			_lockBox.addEventListener(LockEvent.SHOW_LOCK, showComboLock);
		}

		private function showComboLock(event : LockEvent) : void {
			_comboLock.showMe();
		}

		private function unlockBox(event : LockEvent = null) : void {
			_comboLock.hideMe();
			_lockBox.openMe();
		}
	}
}
