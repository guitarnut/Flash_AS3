package com.starz.view
{
	import com.starz.view.components.GameScreen;
	import com.starz.events.GameEvent;
	import flash.events.Event;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import com.starz.events.AnalyticsEvent;
	import com.starz.constants.Achievements;

	public class InstructionsScreen extends GameScreen
	{
		private var _gawainTween:TweenLite;
		private var _textTween:TweenLite;
		private var _nextTween:TweenLite;
		private var _charactersTween:TweenLite;

		public function InstructionsScreen():void
		{
			init();
		}
		private function init():void
		{
			for (var i:Number = 1; i < this.numChildren; i++)
			{
				getChildAt(i).alpha = 0;
			}
			nextButton.addEventListener(MouseEvent.CLICK, showCharacters);
			characters.addEventListener(GameEvent.CHARACTER_SELECTED, setCharacter);
			characters.addEventListener(AnalyticsEvent.EVENT_TRACKING, characterAnalytics);
		}
		public function showInstructions():void
		{
			playMusic(new Dance(), true);

			gawain.y = gawain.y + 100;
			_gawainTween = new TweenLite(gawain,1.5,{y:gawain.y - 100,alpha:1});

			instructions.x = instructions.x - 300;
			_textTween = new TweenLite(instructions,1,{x:instructions.x + 300,alpha:1});

			nextButton.x = nextButton.x - 300;
			_nextTween = new TweenLite(nextButton,1,{x:nextButton.x + 300,alpha:1});

			checkTime();
		}
		private function showCharacters(e:MouseEvent):void
		{
			_gawainTween = new TweenLite(gawain,.5,{alpha:0});
			_textTween = new TweenLite(instructions,.5,{alpha:0});
			_nextTween = new TweenLite(nextButton,.5,{alpha:0});

			characters.x = characters.x - 300;
			_charactersTween = new TweenLite(characters,1,{x:characters.x + 300,alpha:1});
		}
		private function setCharacter(e:GameEvent):void
		{
			var gameData:Object = new Object();
			gameData.character = e.gameData.character;
			dispatchEvent(new GameEvent(GameEvent.CHARACTER_SELECTED, gameData));
		}
		private function checkTime():void
		{
			var date:Date = new Date();
			if ((date.hours>=11)&&(date.hours<=13))
			{
				L_Achievement();
			}
		}
		private function L_Achievement():void
		{
			var gameData:Object = new Object();
			gameData.achievement = Achievements.LUNCH_BREAK;
			dispatchEvent(new GameEvent(GameEvent.ACHIEVEMENT, gameData));
		}
		private function characterAnalytics(e:AnalyticsEvent):void
		{
			analytics(e.analyticsData.data);
		}
		public function reset():void {
			for (var i:Number = 1; i < this.numChildren; i++)
			{
				getChildAt(i).alpha = 0;
			}
		}
	}

}