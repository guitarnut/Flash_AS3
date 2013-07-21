package com.starz.events {
	import flash.events.Event;

	/**
	 * @author rhenley
	 */
	public class PillarsEvent extends Event {
		public static const CHARACTER_CENTERED : String = 'CHARACTER_CENTERED';
		public static const CHARACTER_CLICKED : String = 'CHARACTER_CLICKED';
		public static const INFO_CLICKED : String = 'INFO_CLICKED';
		public static const FLIP_CLICKED : String = 'FLIP_CLICKED';
		public static const FLIP_CARDS_BACK : String = 'FLIP_CARDS_BACK';

		public function PillarsEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
