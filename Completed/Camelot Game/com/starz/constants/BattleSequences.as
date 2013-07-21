package com.starz.constants {
	import com.starz.events.GameEvent;
	
	public class BattleSequences {
		
		public static const EASY:Array = new Array(new Array(GameEvent.RIGHT_KEY, GameEvent.RIGHT_KEY),new Array(GameEvent.RIGHT_KEY, GameEvent.DOWN_KEY),new Array(GameEvent.UP_KEY, GameEvent.DOWN_KEY),new Array(GameEvent.LEFT_KEY, GameEvent.RIGHT_KEY), new Array(GameEvent.RIGHT_KEY, GameEvent.UP_KEY),new Array(GameEvent.DOWN_KEY, GameEvent.DOWN_KEY),new Array(GameEvent.DOWN_KEY, GameEvent.UP_KEY));
		public static const MEDUIM:Array = new Array(new Array(GameEvent.RIGHT_KEY, GameEvent.UP_KEY, GameEvent.DOWN_KEY), new Array(GameEvent.DOWN_KEY, GameEvent.UP_KEY, GameEvent.DOWN_KEY), new Array(GameEvent.RIGHT_KEY, GameEvent.RIGHT_KEY, GameEvent.LEFT_KEY), new Array(GameEvent.LEFT_KEY, GameEvent.RIGHT_KEY, GameEvent.DOWN_KEY), new Array(GameEvent.RIGHT_KEY, GameEvent.UP_KEY, GameEvent.RIGHT_KEY));
		public static const HARD:Array = new Array(new Array(GameEvent.RIGHT_KEY, GameEvent.UP_KEY, GameEvent.LEFT_KEY, GameEvent.DOWN_KEY), new Array(GameEvent.UP_KEY, GameEvent.DOWN_KEY, GameEvent.RIGHT_KEY, GameEvent.RIGHT_KEY), new Array(GameEvent.RIGHT_KEY, GameEvent.RIGHT_KEY, GameEvent.LEFT_KEY, GameEvent.DOWN_KEY), new Array(GameEvent.RIGHT_KEY, GameEvent.DOWN_KEY, GameEvent.RIGHT_KEY, GameEvent.UP_KEY));

	}
	
}
