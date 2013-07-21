package com.starz.view.components
{
	import com.starz.view.components.GameScreen;
	import com.starz.events.GameEvent;
	import com.starz.constants.GameScores;
	import com.starz.constants.Achievements;
	import com.starz.view.TriviaWin;
	import com.starz.view.TriviaFail;
	import com.greensock.TweenLite;

	public class TriviaScreen extends GameScreen
	{
		protected static const PAUSE:Number = 2.5;
		protected var _perfectRound:Boolean = true;
		protected var _triviaWin:TriviaWin;
		protected var _triviaFail:TriviaFail;
		protected var _triviaAced:Boolean = true;

		public function TriviaScreen():void
		{
			createEndingScreens();
		}
		private function createEndingScreens():void
		{
			_triviaWin = new TriviaWin();
			_triviaWin.addEventListener(GameEvent.ACHIEVEMENT, endingAchievement);
			addChild(_triviaWin);
			_triviaFail = new TriviaFail();
			_triviaFail.addEventListener(GameEvent.ACHIEVEMENT, endingAchievement);
			addChild(_triviaFail);
		}
		protected function rightAnswer(e:GameEvent):void
		{
			playSoundFX("Correct answer");
			var bonus:Number = 0;
			if (e.gameData.timeRemaining)
			{
				bonus = e.gameData.timeRemaining;
			}
			if (_triviaAced)
			{
				dispatchEvent(new GameEvent(GameEvent.TRIVIA_ACED));
			}
			updateScore(true, bonus);
			_triviaAced = true;
		}
		protected function wrongAnswer(e:GameEvent):void
		{
			playSoundFX("Wrong answer");
			updateScore(false);
		}
		private function updateScore(b$:Boolean, bonus:Number = 0):void
		{
			var gameData:Object= new Object();
			if (b$)
			{
				gameData.points = GameScores.CORRECT_ANSWER + bonus;
				dispatchEvent(new GameEvent(GameEvent.UPDATE_SCORE, gameData));
			}
			else
			{
				gameData.points = GameScores.INCORRECT_ANSWER;
				_perfectRound = false;
				_triviaAced = false;
				dispatchEvent(new GameEvent(GameEvent.UPDATE_SCORE, gameData));
			}
		}
		private function endingAchievement(e:GameEvent):void
		{
			var gameData:Object = new Object();
			gameData.achievement = e.gameData.achievement;
			dispatchEvent(new GameEvent(GameEvent.ACHIEVEMENT, gameData));
		}
		private function O_Achievement():void
		{
			var gameData:Object = new Object();
			gameData.achievement = Achievements.OVERACHIEVER;
			dispatchEvent(new GameEvent(GameEvent.ACHIEVEMENT, gameData));
			pauseGame(PAUSE, new Array(endingScreen), new Array(null));
		}
		protected function triviaComplete():void
		{
			if (_perfectRound)
			{
				O_Achievement();
			}
			else
			{
				endingScreen();
			}
		}
		private function endingScreen():void
		{
			if (_music)
			{
				_music.fadeOut();
			}
			var gameData:Object= new Object();
			if (_perfectRound)
			{
				_triviaWin.showMe();
				gameData.points = GameScores.TRIVIA_WIN;
				_perfectRound = false;
				dispatchEvent(new GameEvent(GameEvent.UPDATE_SCORE, gameData));
			}
			else
			{
				_triviaFail.showMe();
				gameData.points = GameScores.TRIVIA_LOSE;
				_perfectRound = false;
				dispatchEvent(new GameEvent(GameEvent.UPDATE_SCORE, gameData));
			}
			pauseGame(4.5, new Array(endTrivia), new Array(null));
		}
		private function endTrivia():void
		{
			dispatchEvent(new GameEvent(GameEvent.LEVEL_COMPLETE));
		}
		override public function hideMe():void
		{
			_hideTween = new TweenLite(this,TWEEN_SPEED,{alpha:0,onComplete:destroy});
		}
	}

}