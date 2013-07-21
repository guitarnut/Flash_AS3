package com.events {

	import flash.events.Event;

	/**
	 * @author rhenley
	 */
	public class SpaceEvent extends Event {
		public static const GOOD_ITEM_CLICKED : String = 'GOOD_ITEM_CLICKED';
		public static const BAD_ITEM_CLICKED : String = 'BAD_ITEM_CLICKED';
		public static const BONUS_ITEM_CLICKED : String = 'BONUS_ITEM_CLICKED';
		public static const MOVIE_ITEM_CLICKED : String = 'MOVIE_ITEM_CLICKED';
		public static const BENEFIT_ITEM_CLICKED : String = 'BENEFIT_ITEM_CLICKED';
		public static const ORIGINALS_ITEM_CLICKED : String = 'ORIGINALS_ITEM_CLICKED';
		public static const REMOVE_ITEM : String = 'REMOVE_ITEM';
		public static const LEVEL_COMPLETE : String = 'LEVEL_COMPLETE';
		public static const NEXT_SCREEN : String = 'NEXT_SCREEN';
		public static const START_LEVEL : String = 'START_LEVEL';
		public static const LEVEL_LOADED : String = 'LEVEL_LOADED';
		public static const RIGHT_ANSWER : String = 'RIGHT_ANSWER';
		public static const WRONG_ANSWER : String = 'WRONG_ANSWER';
		public static const INSTRUCTIONS : String = 'INSTRUCTIONS';
		public static const PLAY : String = 'PLAY';

		public var data : Object;

		public function SpaceEvent(type : String, data : Object = null, bubbles : Boolean = false, cancelable : Boolean = false) {
			if(data)this.data = data;
			super(type, bubbles, cancelable);
		}
	}
}
