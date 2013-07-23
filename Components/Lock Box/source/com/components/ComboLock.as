package com.components {
	import com.components.assets.ComboSlot;
	import com.events.LockEvent;
	import com.greensock.TweenLite;

	import flash.events.Event;

	/**
	 * @author rhenley
	 */
	public class ComboLock extends Lock {

		private var _combo1 : ComboSlot;
		private var _combo2 : ComboSlot;
		private var _combo3 : ComboSlot;
		private var _combo4 : ComboSlot;

		public function ComboLock(key1 : Number, key2 : Number, key3 : Number, key4 : Number) {
			alpha = 0;
			this.visible = false;
			
			_combo1 = new ComboSlot();
			_combo1.x = 185;
			_combo1.y = 175;
			addLockListeners(_combo1);
			
			_combo2 = new ComboSlot();
			_combo2.x = 245;
			_combo2.y = 175;
			addLockListeners(_combo2);
			
			_combo3 = new ComboSlot();
			_combo3.x = 305;
			_combo3.y = 175;
			addLockListeners(_combo3);
			
			_combo4 = new ComboSlot();
			_combo4.x = 365;
			_combo4.y = 175;
			addLockListeners(_combo4);
			
			addChild(_combo1);
			addChild(_combo2);
			addChild(_combo3);
			addChild(_combo4);
			
			setCombination(key1, key2, key3, key4);
		}

		public function showMe(event : Event = null) : void {
			this.visible = true;
			TweenLite.to(this, .5, {alpha: 1});
		}

		public function hideMe(event : Event = null) : void {
			TweenLite.to(this, .5, {alpha: 0, onComplete: destroy});
		}

		private function addLockListeners(lock : ComboSlot) : void {
			lock.addEventListener(LockEvent.KEY_ON, keyOn);
			lock.addEventListener(LockEvent.KEY_OFF, keyOff);
		}

		private function setCombination(key1 : Number, key2 : Number, key3 : Number, key4 : Number) : void {
			_combo1.key = key1;
			_combo2.key = key2;
			_combo3.key = key3;
			_combo4.key = key4;
		}

		private function keyOn(event : LockEvent) : void {
			checkLock();
		}

		private function keyOff(event : LockEvent) : void {
		}

		private function checkLock() : void {
			if((_combo1.unlocked) && (_combo2.unlocked) && (_combo3.unlocked) && (_combo4.unlocked))unlockBox();
		}

		private function unlockBox() : void {
			dispatchEvent(new LockEvent(LockEvent.UNLOCK, false, false));
		}

		private function destroy() : void {
			this.visible = false;
		}
	}
}
