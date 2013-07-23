package com.events {
	import flash.events.Event;

	/**
	 * @author rhenley
	 */
	public class LockEvent extends Event {
		public static const KEY_ON : String = 'KEY_ON';
		public static const KEY_OFF : String = 'KEY_OFF';
		public static const UNLOCK : String = 'UNLOCK';
		public static const SHOW_LOCK : String = 'SHOW_LOCK';

		public function LockEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
