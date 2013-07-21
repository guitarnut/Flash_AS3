package com.starz.events {
	import flash.events.Event;
	
	public class GameEvent extends Event {
		/* Global */
		public static const STORE_DATA:String = 'STORE_DATA';
		public static const CLEAR_DATA:String = 'CLEAR_DATA';
		public static const GAME_READY:String = 'GAME_READY';
		public static const LEVEL_COMPLETE:String = 'LEVEL_COMPLETE';
		public static const GAME_COMPLETE:String = 'GAME_COMPLETE';
		public static const REPLAY_GAME:String = 'REPLAY_GAME';
		public static const CAST_SCREEN:String = 'CAST_SCREEN';
		public static const MUSIC:String = 'MUSIC';
		public static const SOUND_FX:String = 'SOUND_FX';
		public static const VIDEO_COMPLETE:String = 'VIDEO_COMPLETE';
		public static const REPLAY:String = 'REPLAY';
		/* Gameplay */
		public static const CHARACTER_SELECTED:String = 'CHARACTER_SELECTED';
		public static const COMBO_CORRECT:String = 'COMBO_CORRECT';
		public static const COMBO_ACED:String = 'COMBO_ACED';
		public static const COMBO_INCORRECT:String = 'COMBO_INCORRECT';
		public static const COMBO_FAILED:String = 'COMBO_FAILED';
		public static const NEXT_QUESTION:String = 'NEXT_QUESTION';
		public static const CORRECT_ANSWER:String = 'CORRECT_ANSWER';
		public static const TRIVIA_ACED:String = 'TRIVIA_ACED';
		public static const INCORRECT_ANSWER:String = 'INCORRECT_ANSWER';
		public static const UPDATE_SCORE:String = 'UPDATE_SCORE';
		public static const TIMES_UP:String = 'TIMES_UP';
		/* Controls */
		public static const DOWN_KEY:String = 'DOWN_KEY';
		public static const UP_KEY:String = 'UP_KEY';
		public static const LEFT_KEY:String = 'LEFT_KEY';
		public static const RIGHT_KEY:String = 'RIGHT_KEY';
		public static const PRIMARY_KEY:String = 'PRIMARY_KEY';
		public static const SECONDARY_KEY:String = 'SECONDARY_KEY';
		public static const MOVEMENT_COMPLETE:String = 'MOVEMENT_COMPLETE';
		public static const DEMONSTRATION_COMPLETE:String = 'DEMONSTRATION_COMPLETE';
		/* Achievements */
		public static const ACHIEVEMENT:String = 'ACHIEVEMENT';
		
		public var gameData:Object = new Object();

		public function GameEvent(type:String, theGameData:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			gameData = theGameData;
			super(type, bubbles, cancelable);
		}

	}
	
}
