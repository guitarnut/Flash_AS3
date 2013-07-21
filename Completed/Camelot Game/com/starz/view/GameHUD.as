package com.starz.view
{
	import com.starz.view.components.GameScreen;
	import com.starz.constants.Achievements;
	import com.greensock.TweenLite;
	import flash.events.Event;

	public class GameHUD extends GameScreen
	{
		private static const SCORE_INCREMENT:Number = 50;
		public var achievements:Array;
		public var triviaAces:Number = 0;
		public var combinationAces:Number = 0;
		public var currentScore:Number;
		public var newScore:Number;
		private var _achievementTween:TweenLite;

		public function GameHUD():void
		{
			addEventListener(Event.ADDED_TO_STAGE, loadAchievements);
			init();
		}
		private function init():void
		{
			scoreText.text = "0";
		}
		public function updateScore(score:Number):void
		{
			newScore = Number(scoreText.text) + score;
			currentScore = Number(scoreText.text);
			if (score > 0)
			{
				playSoundFX("Points up");
				addEventListener(Event.ENTER_FRAME, increaseScore);
			}
			else
			{
				playSoundFX("Points down");
				addEventListener(Event.ENTER_FRAME, decreaseScore);
			}

		}
		private function increaseScore(e:Event):void
		{
			if (currentScore < newScore - SCORE_INCREMENT)
			{
				currentScore +=  SCORE_INCREMENT;
				scoreText.text = String(currentScore);
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME, increaseScore);
				scoreText.text = String(newScore);
			}
		}
		private function decreaseScore(e:Event):void
		{
			if (currentScore > newScore + SCORE_INCREMENT)
			{
				currentScore -=  SCORE_INCREMENT;
				scoreText.text = String(currentScore);
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME, decreaseScore);
				scoreText.text = String(newScore);
			}
		}
		private function loadAchievements(e:Event):void
		{
			var achievements:Object = MovieClip(this.parent).dataManager.getAchievements();

			if (achievements.cAchievement)
			{
				_achievementTween = new TweenLite(c,1,{alpha:1});
			}
			if (achievements.aAchievement)
			{
				_achievementTween = new TweenLite(a,1,{alpha:1});
			}
			if (achievements.mAchievement)
			{
				_achievementTween = new TweenLite(m,1,{alpha:1});
			}
			if (achievements.eAchievement)
			{
				_achievementTween = new TweenLite(e,1,{alpha:1});
			}
			if (achievements.lAchievement)
			{
				_achievementTween = new TweenLite(l,1,{alpha:1});
			}
			if (achievements.oAchievement)
			{
				_achievementTween = new TweenLite(o,1,{alpha:1});
			}
			if (achievements.tAchievement)
			{
				_achievementTween = new TweenLite(t,1,{alpha:1});
			}
		}
		public function showAchievement(achievement:String):void
		{
			if (checkAchievements(achievement))
			{
				switch (achievement)
				{
					case Achievements.CAMELOT_GAMER :
						addChild(new C_Achievement);
						_achievementTween = new TweenLite(c,1,{alpha:1});
						break;
					case Achievements.ARE_YOU_PAYING_ATTENTION :
						addChild(new A_Achievement);
						_achievementTween = new TweenLite(a,1,{alpha:1});
						break;
					case Achievements.MERLINS_REWARD :
						addChild(new M_Achievement);
						_achievementTween = new TweenLite(m,1,{alpha:1});
						break;
					case Achievements.EVIL_LITTLE_SISTER :
						addChild(new E_Achievement);
						_achievementTween = new TweenLite(e,1,{alpha:1});
						break;
					case Achievements.LUNCH_BREAK :
						addChild(new L_Achievement);
						_achievementTween = new TweenLite(l,1,{alpha:1});
						break;
					case Achievements.OVERACHIEVER :
						addChild(new O_Achievement);
						_achievementTween = new TweenLite(o,1,{alpha:1});
						break;
					case Achievements.TOP_STUDENT :
						addChild(new T_Achievement);
						_achievementTween = new TweenLite(t,1,{alpha:1});
						break;
				}
				analytics("Achievement: "+achievement);
				playSoundFX(new Bonus(), true);
			}
		}
		private function checkAchievements(achievement:String):Boolean
		{
			var newAchievement:Boolean = true;
			if (achievements)
			{
				var duplicate:Boolean = false;
				for (var i:Number = 0; i< achievements.length; i++)
				{
					if (achievements[i] == achievement)
					{
						duplicate = true;
						newAchievement = false;
					}
				}
				if (! duplicate)
				{
					achievements.push(achievement);
				}
			}
			else
			{
				achievements = new Array();
				achievements.push(achievement);
			}
			return newAchievement;
		}
		public function gameOver():void
		{
			analytics("Game completed");
		}
		public function reset():void {
			analytics("Replay Game");
			scoreText.text = "0";
			triviaAces = 0;
			combinationAces = 0;
		}
	}

}