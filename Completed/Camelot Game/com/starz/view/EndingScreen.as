package com.starz.view
{
	import com.starz.view.components.GameScreen;
	import com.starz.events.GameEvent;
	import com.starz.constants.Achievements;
	import flash.events.Event;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;

	public class EndingScreen extends GameScreen
	{

		public function EndingScreen():void
		{
		}
		override public function showMe():void
		{
			playMusic(new Dance(), true);
			replayButton.addEventListener(MouseEvent.CLICK, replayGame);
			alpha = 0;
			visible = true;
			_showTween = new TweenLite(this,TWEEN_SPEED,{alpha:1,onComplete:C_Achievement});
		}
		public function finalScores(playerScore:Number, playerTrivia:Number, playerCombos:Number, playerAchievements:Array):void
		{
			score.text = String(playerScore);
			trivia.text = String(playerTrivia) + " of 6 (" + calculatePercent(playerTrivia,6) + "%)";
			combinations.text = String(playerCombos) + " of 9 ("+calculatePercent(playerCombos,9)+"%)";
			achievements.text = String(playerAchievements.length+1) + " of 8 ("+calculatePercent(playerAchievements.length+1,8)+"%)";
		}
		private function calculatePercent(valueOne:Number, valueTwo:Number):Number
		{
			var percent:Number = Math.round((valueOne / valueTwo) * 100);
			return percent;
		}
		private function C_Achievement():void
		{
			var gameData:Object = new Object();
			gameData.achievement = Achievements.CAMELOT_GAMER;
			dispatchEvent(new GameEvent(GameEvent.ACHIEVEMENT, gameData));
		}
		private function replayGame(e:MouseEvent):void {
			replayButton.removeEventListener(MouseEvent.CLICK, replayGame);
			dispatchEvent(new GameEvent(GameEvent.REPLAY));
		}
		public function reset():void {
			score.text = "";
			trivia.text = "";
			combinations.text = "";
			achievements.text = "";
		}

	}

}