package com.starz.view
{
	import com.starz.view.components.GameScreen;
	import com.starz.events.GameEvent;
	import com.starz.constants.Achievements;
	import flash.events.Event;
	import com.greensock.TweenLite;

	public class TriviaWin extends GameScreen
	{

		public function TriviaWin():void
		{
		}
		override public function showMe():void
		{
			playMusic(new Merlin(), true);
			alpha = 0;
			visible = true;
			_showTween = new TweenLite(this,TWEEN_SPEED,{alpha:1, onComplete: M_Achievement});
		}
		private function M_Achievement():void
		{
			analytics("Passed trivia.");
			var gameData:Object = new Object();
			gameData.achievement = Achievements.MERLINS_REWARD;
			dispatchEvent(new GameEvent(GameEvent.ACHIEVEMENT, gameData));
		}

	}

}