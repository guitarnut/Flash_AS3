package com.starz.view
{
	import com.starz.view.components.GameScreen;
	import com.starz.events.GameEvent;
	import com.starz.constants.Achievements;
	import flash.events.Event;
	import com.greensock.TweenLite;

	public class TriviaFail extends GameScreen
	{

		public function TriviaFail():void
		{
		}
		override public function showMe():void
		{
			playMusic(new Morgan(), true);
			alpha = 0;
			visible = true;
			_showTween = new TweenLite(this,TWEEN_SPEED,{alpha:1, onComplete: E_Achievement});
		}
		private function E_Achievement():void
		{
			analytics("Failed trivia.");
			var gameData:Object = new Object();
			gameData.achievement = Achievements.EVIL_LITTLE_SISTER;
			dispatchEvent(new GameEvent(GameEvent.ACHIEVEMENT, gameData));
		}

	}

}