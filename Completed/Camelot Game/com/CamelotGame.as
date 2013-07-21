package com
{
	import flash.display.MovieClip;
	import com.starz.events.GameEvent;
	import com.starz.control.UserDataManager;
	import com.starz.view.GameHUD;
	import com.starz.view.TitleScreen;
	import com.starz.view.CombatScreen;
	import com.starz.view.TriviaScreenOne;
	import com.starz.view.TriviaScreenTwo;
	import com.starz.view.InstructionsScreen;
	import com.starz.view.components.GameScreen;
	import com.starz.control.AnalyticsManager;
	import com.starz.events.AnalyticsEvent;
	import com.starz.view.EndingScreen;
	import com.starz.core.media.video.VideoPlayerLite;
	import com.starz.view.VideoScreen;
	import com.starz.view.CastScreen;

	public class CamelotGame extends MovieClip
	{

		/* User Data */
		public var dataManager:UserDataManager;
		public var analyticsManager:AnalyticsManager;
		/* Game Screens */
		private var _hud:GameHUD;
		private var _titleScreen:TitleScreen;
		private var _castScreen:CastScreen;
		private var _instructionsScreen:InstructionsScreen;
		private var _videoScreen:VideoScreen;
		private var _combatScreen:CombatScreen;
		private var _triviaScreenOne:TriviaScreenOne;
		private var _triviaScreenTwo:TriviaScreenTwo;
		private var _endingScreen:EndingScreen;
		private var _currentScreen:GameScreen;
		/* Misc items */
		private var _round:Number = 1;
		
		private var vid:VideoPlayerLite = new VideoPlayerLite();

		public function CamelotGame():void
		{
			init();
		}
		private function init():void
		{
			/* Resizes game to 960x720 for use on Starz.com */
			this.scaleX = .9375;
			this.scaleY = .9375;
			
			initializeDataManager();
			initializeAnalyticsManager();
			createScreens();
			addListeners();
		}
		private function initializeDataManager():void
		{
			dataManager = new UserDataManager();
			dataManager.clearData();
		}
		private function initializeAnalyticsManager():void
		{
			analyticsManager = new AnalyticsManager();
		}
		private function createScreens():void
		{
			_titleScreen = new TitleScreen();
			addChild(_titleScreen);
			
			_castScreen = new CastScreen();
			addChild(_castScreen);

			_instructionsScreen = new InstructionsScreen();
			addChild(_instructionsScreen);
			
			_videoScreen = new VideoScreen();
			addChild(_videoScreen);

			_combatScreen = new CombatScreen();
			addChild(_combatScreen);

			_triviaScreenOne = new TriviaScreenOne();
			addChild(_triviaScreenOne);

			_triviaScreenTwo = new TriviaScreenTwo();
			addChild(_triviaScreenTwo);
			
			_endingScreen = new EndingScreen();
			addChild(_endingScreen);

			_hud = new GameHUD();
			addChild(_hud);

			startGame();
		}
		private function addListeners():void
		{
			_hud.addEventListener(AnalyticsEvent.EVENT_TRACKING, trackAnalytics);
			
			_titleScreen.addEventListener(GameEvent.LEVEL_COMPLETE, instructionsScreen);
			_titleScreen.addEventListener(GameEvent.CAST_SCREEN, castScreen);
			_titleScreen.addEventListener(AnalyticsEvent.EVENT_TRACKING, trackAnalytics);
			
			_castScreen.addEventListener(GameEvent.LEVEL_COMPLETE, titleScreen);

			_instructionsScreen.addEventListener(GameEvent.CHARACTER_SELECTED, setCharacter);
			_instructionsScreen.addEventListener(GameEvent.ACHIEVEMENT, showAchievement);
			_instructionsScreen.addEventListener(AnalyticsEvent.EVENT_TRACKING, trackAnalytics);
			
			_videoScreen.addEventListener(GameEvent.VIDEO_COMPLETE, startLevel);

			_combatScreen.addEventListener(GameEvent.UPDATE_SCORE, updateScore);
			_combatScreen.addEventListener(GameEvent.LEVEL_COMPLETE, levelComplete);
			_combatScreen.addEventListener(GameEvent.ACHIEVEMENT, showAchievement);
			_combatScreen.addEventListener(GameEvent.COMBO_ACED, comboAced);
			_combatScreen.addEventListener(AnalyticsEvent.EVENT_TRACKING, trackAnalytics);

			_triviaScreenOne.addEventListener(GameEvent.UPDATE_SCORE, updateScore);
			_triviaScreenOne.addEventListener(GameEvent.LEVEL_COMPLETE, triviaComplete);
			_triviaScreenOne.addEventListener(GameEvent.ACHIEVEMENT, showAchievement);
			_triviaScreenOne.addEventListener(GameEvent.TRIVIA_ACED, triviaAced);
			_triviaScreenOne.addEventListener(AnalyticsEvent.EVENT_TRACKING, trackAnalytics);

			_triviaScreenTwo.addEventListener(GameEvent.UPDATE_SCORE, updateScore);
			_triviaScreenTwo.addEventListener(GameEvent.LEVEL_COMPLETE, triviaComplete);
			_triviaScreenTwo.addEventListener(GameEvent.ACHIEVEMENT, showAchievement);
			_triviaScreenTwo.addEventListener(GameEvent.TRIVIA_ACED, triviaAced);
			_triviaScreenTwo.addEventListener(AnalyticsEvent.EVENT_TRACKING, trackAnalytics);
			
			_endingScreen.addEventListener(GameEvent.ACHIEVEMENT, showAchievement);
			_endingScreen.addEventListener(GameEvent.REPLAY, replayGame);
		}
		private function startGame():void
		{
			showScreen(_titleScreen);
			_titleScreen.firstRun();
			_currentScreen = _titleScreen;
		}
		private function titleScreen(e:GameEvent = null):void
		{
			showScreen(_titleScreen);
			_titleScreen.showTitle();
		}
		private function castScreen(e:GameEvent = null):void
		{
			showScreen(_castScreen);
			_castScreen.showCast();
		}
		private function instructionsScreen(e:GameEvent = null):void
		{
			_hud.showMe();
			showScreen(_instructionsScreen);
			_instructionsScreen.showInstructions();
		}
		private function showVideo(e:GameEvent = null):void {
			showScreen(_videoScreen);
			_videoScreen.playVideo();
		}
		private function startLevel(e:GameEvent = null):void
		{
			setDifficulty();
			showScreen(_combatScreen);
			_combatScreen.startRound();
		}
		private function startTrivia():void
		{
			switch (_round)
			{
				case 1 :
					showScreen(_triviaScreenOne);
					_triviaScreenOne.startRound();
					break;
				case 2 :
					showScreen(_triviaScreenTwo);
					_triviaScreenTwo.startRound();
					break;
				case 3 :
					endGame();
					break;
			}
		}
		private function levelComplete(e:GameEvent):void
		{
			startTrivia();
		}
		private function triviaComplete(e:GameEvent):void
		{
			advanceRound();
		}
		private function advanceRound():void
		{
			_round++;
			startLevel();
		}
		private function showScreen(screen:GameScreen):void
		{
			if (_currentScreen)
			{
				_currentScreen.hideMe();
			}
			screen.showMe();
			_currentScreen = screen;
		}
		private function endGame():void
		{
			_hud.gameOver();
			_endingScreen.finalScores(_hud.currentScore, _hud.triviaAces, _hud.combinationAces, _hud.achievements);
			showScreen(_endingScreen);
		}
		private function setDifficulty():void
		{
			switch (_round)
			{
				case 1 :
					_combatScreen.setDifficulty("Easy");
					break;
				case 2 :
					_combatScreen.setDifficulty("Medium");
					break;
				case 3 :
					_combatScreen.setDifficulty("Hard");
					break;
			}
		}
		private function comboAced(e:GameEvent):void
		{
			_hud.combinationAces++;
			trace("Combo aced");
		}
		private function triviaAced(e:GameEvent):void
		{
			_hud.triviaAces++;
			trace("Trivia aced");
		}
		private function setCharacter(e:GameEvent):void
		{
			_combatScreen.setCharacter(e.gameData.character.name);
			showVideo();
		}
		private function updateScore(e:GameEvent):void
		{
			_hud.updateScore(e.gameData.points);
		}
		private function showAchievement(e:GameEvent):void
		{
			//dataManager.storeData("Achievement", e.gameData.achievement);
			_hud.showAchievement(e.gameData.achievement);
		}
		private function trackAnalytics(e:AnalyticsEvent):void
		{
			analyticsManager.track(e);
		}
		private function replayGame(e:GameEvent):void {
			_hud.reset();
			_instructionsScreen.reset();
			_combatScreen.reset();
			_triviaScreenOne.reset();
			_triviaScreenTwo.reset();
			_endingScreen.reset();
			_round = 1;
			instructionsScreen();
		}
	}
}