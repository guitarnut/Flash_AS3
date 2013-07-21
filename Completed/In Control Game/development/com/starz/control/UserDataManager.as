package com.starz.control
{
	import flash.display.Sprite;
	import com.starz.events.GameEvent;
	import com.starz.events.AnalyticsEvent;
	import flash.net.SharedObject;
	import com.starz.constants.Achievements;
	import flash.events.NetStatusEvent;

	public class UserDataManager extends Sprite
	{
		public static const COOKIE_NAME:String = "starzcamelotgamedata";
		var userData:SharedObject;

		public function UserDataManager():void
		{
			init();
		}
		private function init():void
		{
			userData = SharedObject.getLocal(COOKIE_NAME);
		}
		public function storeData(gameDataType, gameData):void
		{
			
			if (gameDataType == "User Name")
			{
				userData.data.userName = gameData;
			}
			if (gameDataType == "High Score")
			{
				userData.data.highScore = gameData;
			}
			if (gameDataType == "Achievement")
			{
				if (gameData == "CAMELOT_GAMER")
				{
					userData.data.cAchievement = Achievements.CAMELOT_GAMER;
				}
				if (gameData == "ARE_YOU_PAYING_ATTENTION")
				{
					userData.data.aAchievement = Achievements.ARE_YOU_PAYING_ATTENTION;
				}
				if (gameData == "MERLINS_REWARD")
				{
					userData.data.mAchievement = Achievements.MERLINS_REWARD;
				}
				if (gameData == "EVIL_LITTLE_SISTER")
				{
					userData.data.eAchievement = Achievements.EVIL_LITTLE_SISTER;
				}
				if (gameData == "LUNCH_BREAK")
				{
					userData.data.lAchievement = Achievements.LUNCH_BREAK;
				}
				if (gameData == "OVERACHIEVER")
				{
					userData.data.oAchievement = Achievements.OVERACHIEVER;
				}
				if (gameData == "TOP_STUDENT")
				{
					userData.data.tAchievement = Achievements.TOP_STUDENT;
				}
			}
			userData.flush();
		}
		public function clearData():void
		{
			userData.clear();
		}
		public function getUserName():String
		{
			var userName:String = "Player";
			if (userData.data.userName)
			{
				userName = userData.data.userName;
			}
			return userName;
		}
		public function getHighScore():Number
		{
			var highScore:Number = 0;
			if (userData.data.highScore)
			{
				highScore = userData.data.highScore;
			}
			return highScore;
		}
		public function getAchievements():Object
		{
			var achievements:Object = new Object();
			achievements.cAchievement = userData.data.cAchievement;
			achievements.aAchievement = userData.data.aAchievement;
			achievements.mAchievement = userData.data.mAchievement;
			achievements.eAchievement = userData.data.eAchievement;
			achievements.lAchievement = userData.data.lAchievement;
			achievements.oAchievement = userData.data.oAchievement;
			achievements.tAchievement = userData.data.tAchievement;
			
			//trace(userData.data.tAchievement);

			return achievements;
		}
	}
}