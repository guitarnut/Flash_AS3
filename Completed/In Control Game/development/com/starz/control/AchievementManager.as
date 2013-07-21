package com.starz.control
{
	import flash.display.Sprite;
	import com.starz.events.GameEvent;
	import com.starz.events.AnalyticsEvent;

	public class AchievementManager extends Sprite
	{

		public function AchievementManager():void
		{
			init();
		}
		private function init():void
		{
			addListeners();
		}
		private function addListeners():void
		{
			addEventListener(GameEvent.ACHIEVEMENT_CAMELOT_GAMER, achievementUnlocked);
			addEventListener(GameEvent.ACHIEVEMENT_ANGER_MANAGEMENT, achievementUnlocked);
			addEventListener(GameEvent.ACHIEVEMENT_MERLINS_REWARD, achievementUnlocked);
			addEventListener(GameEvent.ACHIEVEMENT_EVIL_LITTLE_SISTER, achievementUnlocked);
			addEventListener(GameEvent.ACHIEVEMENT_LUNCH_BREAK, achievementUnlocked);
			addEventListener(GameEvent.ACHIEVEMENT_OVERACHIEVER, achievementUnlocked);
			addEventListener(GameEvent.ACHIEVEMENT_TOP_STUDENT, achievementUnlocked);
		}
		private function removeListeners():void
		{

		}
		private function achievementUnlocked(e:GameEvent):void
		{
			if (!isUnlocked(e.type))
			{
				switch (e.type)
				{
					case 'ACHIEVEMENT_ANGER_MANAGEMENT' :
						break;
					case 'ACHIEVEMENT_CAMELOT_GAMER' :
						break;
					case 'ACHIEVEMENT_EVIL_LITTLE_SISTER' :
						break;
					case 'ACHIEVEMENT_LUNCH_BREAK' :
						break;
					case 'ACHIEVEMENT_MERLINS_REWARD' :
						break;
					case 'ACHIEVEMENT_OVERACHIEVER' :
						break;
					case 'ACHIEVEMENT_TOP_STUDENT' :
						break;
				}
				var achievement:Object = new Object;
				achievement.name = e.type;
				dispatchEvent(new AnalyticsEvent(AnalyticsEvent.EVENT_TRACKING, achievement, false, false);
			}
		}
		private function isUnlocked(eventType:String):Boolean {
			var unlocked:Boolean = false;
			return unlocked;
		}
	}

}