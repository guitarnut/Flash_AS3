package com.starz.events {
	import flash.events.Event;
	
	public class GameEvent extends Event {
		/* Global */
		public static const GAME_READY:String = 'GAME_READY';
		public static const SHOW_TITLE:String = 'SHOW_TITLE';
		public static const SHOW_INSTRUCTIONS:String = 'SHOW_INSTRUCTIONS';
		public static const SHOW_VIDEO:String = 'SHOW_VIDEO';
		public static const START_GAME:String = 'START_GAME';
		public static const LEVEL_COMPLETE:String = 'LEVEL_COMPLETE';
		public static const GAME_COMPLETE:String = 'GAME_COMPLETE';
		public static const REPLAY_GAME:String = 'REPLAY_GAME';
		public static const MUSIC:String = 'MUSIC';
		public static const SOUND_FX:String = 'SOUND_FX';
		public static const VIDEO_COMPLETE:String = 'VIDEO_COMPLETE';
		/* Gameplay */
		public static const GOOD_CLICK:String = 'GOOD_CLICK';
		public static const BAD_CLICK:String = 'BAD_CLICK';
		public static const PREVIEW_CLICK:String = 'PREVIEW_CLICK';
		public static const BONUS_CLICK:String = 'BONUS_CLICK';
		public static const TV_CRACKED:String = 'TV_CRACKED';		
		public static const NEXT_QUESTION:String = 'NEXT_QUESTION';
		public static const CORRECT_ANSWER:String = 'CORRECT_ANSWER';
		public static const TRIVIA_ACED:String = 'TRIVIA_ACED';
		public static const INCORRECT_ANSWER:String = 'INCORRECT_ANSWER';
		public static const UPDATE_SCORE:String = 'UPDATE_SCORE';
		public static const PANIC:String = 'PANIC';
		public static const TIMES_UP:String = 'TIMES_UP';
		public static const ROUND_COMPLETE:String = 'ROUND_COMPLETE';
		/* Controls */
		public static const REMOTE_CLICKED:String = 'REMOTE_CLICKED';
		/* Achievements */
		public static const ACHIEVEMENT:String = 'ACHIEVEMENT';
		
		public var gameData:Object = new Object();

		public function GameEvent(type:String, theGameData:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			gameData = theGameData;
			super(type, bubbles, cancelable);
		}

	}
	
}
