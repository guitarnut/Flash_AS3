package com {
	import com.components.GameScreen;
	import com.constants.Scores;
	import com.events.SpaceEvent;
	import com.starz.core.media.audio.AudioPlayer;
	import com.starz.core.utils.Debug;
	import com.starz.core.utils.XMLLoader;
	import com.starz.core.utils.events.XMLEvent;
	import com.view.SpaceScene;
	import com.view.components.SpaceObject;
	import com.vo.SpaceObjectVO;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.media.SoundMixer;

	/**
	 * @author rhenley
	 */
	public class SpaceGame extends Sprite {
		public static const LEVEL_SCREEN_DELAY : Number = 8;
		public static const SCREEN_DELAY : Number = 3;
		public static const SCREEN_DELAY_LONG : Number = 7;
		public static const LEVEL_LENGTH : Number = 15;

		private var _spaceScene : SpaceScene;
		private var _audio : AudioPlayer;
		private var _xmlLoader : XMLLoader;
		private var _spaceObjects : Array;
		private var _movieList : String;
		public var totalScore : Number = 0;
		private var _currentLevel : Number = 1;
		private var _incorrectAnswers : Number = 0;
		private var _correctAnswers : Number = 0;
		private var _moviesFound : Number = 0;
		private var _bonusFound : Number = 0;
		private var _goodIconsFound : Number = 0;
		private var _badIconsFound : Number = 0;
		private var _timeRemaining : Number = 0;
		/* Screens */
		private var _titleScreen : TitleScreen;
		private var _instructionsScreen : InstructionsScreen;
		private var _triviaOne : TriviaOne;
		private var _triviaTwo : TriviaTwo;
		private var _levelScreen : LevelScreen;
		private var _endingScreen : EndingScreen;
		private var _currentScreen : GameScreen;
		private var _timesUpScreen : TimesUpScreen;
		private var _levelCompleteScreen : LevelCompleteScreen;

		private var _objectGallery : Sprite;
		private var _hasGallery : Boolean = false;
		private var _secondPlay : Boolean = false;

		public function SpaceGame() {
			Debug.password = 'Starz';
			Debug.clear();
			Debug.log('Initialized');
			startup();
		}

		private function startup() : void {
			buildScreens();
			addGameListeners();
			startGame();
		}

		/* Create an instance of each game screen */
		private function buildScreens() : void {
			_spaceScene = new SpaceScene(800, 600, this.stage, 1);
			
			_audio = new AudioPlayer();
			
			_triviaOne = new TriviaOne();
			_triviaTwo = new  TriviaTwo();
			
			_levelScreen = new  LevelScreen();
						
			_endingScreen = new  EndingScreen();
			_endingScreen.playAgain.buttonMode = true;
			_endingScreen.playAgain.addEventListener(MouseEvent.MOUSE_DOWN, replayGame);
			
			_timesUpScreen = new TimesUpScreen();
			_levelCompleteScreen = new LevelCompleteScreen();
			
			_titleScreen = new TitleScreen();
			_titleScreen.addEventListener(SpaceEvent.PLAY, playVideo);
			_titleScreen.addEventListener(SpaceEvent.INSTRUCTIONS, showInstructions);
			
			_instructionsScreen = new  InstructionsScreen();
			_instructionsScreen.addEventListener(SpaceEvent.PLAY, playVideo);
		}

		/* Track user clicks throughout gameplay */
		private function addGameListeners() : void {
			addEventListener(SpaceEvent.GOOD_ITEM_CLICKED, adjustScore);
			addEventListener(SpaceEvent.BAD_ITEM_CLICKED, adjustScore);
			addEventListener(SpaceEvent.BONUS_ITEM_CLICKED, adjustScore);
			addEventListener(SpaceEvent.MOVIE_ITEM_CLICKED, adjustScore);
			addEventListener(SpaceEvent.BENEFIT_ITEM_CLICKED, adjustScore);
			addEventListener(SpaceEvent.ORIGINALS_ITEM_CLICKED, adjustScore);
			_triviaOne.addEventListener(SpaceEvent.RIGHT_ANSWER, adjustScore);
			_triviaOne.addEventListener(SpaceEvent.WRONG_ANSWER, adjustScore);
			_triviaTwo.addEventListener(SpaceEvent.RIGHT_ANSWER, adjustScore);
			_triviaTwo.addEventListener(SpaceEvent.WRONG_ANSWER, adjustScore);
			_endingScreen.playAgain.addEventListener(MouseEvent.MOUSE_DOWN, replayGame);
		}

		/* Removes the current screen and advances to whatever screen you request */
		private function advanceScreen(newScreen : GameScreen = null) : void {
			if(_currentScreen != null)_currentScreen.hideMe();
			if(newScreen != null) {
				_currentScreen = newScreen;
				if(this.numChildren > 0)addChildAt(newScreen, this.numChildren - 1);
				if(this.numChildren == 0)addChild(newScreen);
				Debug.log('Adding ' + newScreen);
			}
		}

		/* Gameplay screen functions */
		private function startGame() : void {
			_audio.playLocal(new TitleMusic());
			advanceScreen(_titleScreen);
		}

		private function endGame() : void {
			updateLevelText();
			advanceScreen(_levelScreen);
			_levelScreen.startDelay(LEVEL_SCREEN_DELAY);
			_levelScreen.addEventListener(SpaceEvent.NEXT_SCREEN, endingScreen);
		}

		private function endingScreen(event : SpaceEvent) : void {
			_audio.playLocal(new EndMusic());
			_levelScreen.removeEventListener(SpaceEvent.NEXT_SCREEN, endingScreen);
			_endingScreen.scoreText.text = "Final score: " + totalScore;
			advanceScreen(_endingScreen);
		}

		private function timesUpScreen() : void {
			_audio.playLocal(new LevelMusic());
			advanceScreen(_timesUpScreen);
			_levelScreen.startDelay(SCREEN_DELAY);
			_levelScreen.addEventListener(SpaceEvent.NEXT_SCREEN, triviaScreen);
		}

		private function levelCompleteScreen() : void {
			_audio.playLocal(new LevelMusic());
			advanceScreen(_levelCompleteScreen);
			_levelScreen.startDelay(SCREEN_DELAY_LONG);
			_levelScreen.addEventListener(SpaceEvent.NEXT_SCREEN, triviaScreen);
		}

		private function triviaScreen(event : SpaceEvent) : void {
			event.target.removeEventListener(SpaceEvent.NEXT_SCREEN, triviaScreen);
			
			_currentLevel++;
			
			if(_currentLevel == 2)showTrivia();
			if(_currentLevel == 3)showTrivia();
			if(_currentLevel == 4)endGame();
		}

		private function showInstructions(event : SpaceEvent) : void {
			advanceScreen(_instructionsScreen);
		}

		private function showTrivia() : void {
			_audio.playLocal(new TriviaMusic());
			if(_currentLevel == 2) {
				_triviaOne.addEventListener(SpaceEvent.NEXT_SCREEN, playGame);
				advanceScreen(_triviaOne);
			}
			if(_currentLevel == 3) {
				_triviaTwo.addEventListener(SpaceEvent.NEXT_SCREEN, playGame);
				advanceScreen(_triviaTwo);
			}
		}

		/* Listens for events from within the game and adjusts the score */
		private function adjustScore(event : SpaceEvent) : void {
			Debug.log('Scoring ' + event.type);
			if(event.type == SpaceEvent.GOOD_ITEM_CLICKED) {
				_goodIconsFound++;
				totalScore += Scores.GOOD_ICON_POINTS;
			}
			if(event.type == SpaceEvent.BAD_ITEM_CLICKED) {
				_badIconsFound++;
				totalScore += Scores.BAD_ICON_POINTS;
			}
			if(event.type == SpaceEvent.BONUS_ITEM_CLICKED) {
				_bonusFound++;
				totalScore += Scores.BONUS_ICON_POINTS;
			}
			if(event.type == SpaceEvent.MOVIE_ITEM_CLICKED) {
				_moviesFound++;
				totalScore += Scores.MOVIE_POINTS;
			}
			if(event.type == SpaceEvent.BENEFIT_ITEM_CLICKED) {
				_moviesFound++;
				totalScore += Scores.MOVIE_POINTS;
			}
			if(event.type == SpaceEvent.ORIGINALS_ITEM_CLICKED) {
				_moviesFound++;
				totalScore += Scores.MOVIE_POINTS;
			}
			if(event.type == SpaceEvent.RIGHT_ANSWER) {
				_correctAnswers++;
				Debug.log('Correct: ' + _correctAnswers);
				totalScore += Scores.RIGHT_ANSWER_POINTS;
			}
			if(event.type == SpaceEvent.WRONG_ANSWER) {
				_incorrectAnswers++;
				totalScore += Scores.WRONG_ANSWER_POINTS;
			}
		}

		private function playVideo(event : SpaceEvent) : void {
			_audio.stopSound();
			event.target.removeEventListener(SpaceEvent.PLAY, playVideo);
			if(!_secondPlay) {
				event.target.addEventListener(SpaceEvent.PLAY, playGame);
				event.target.playVideo();
			} else {
				playGame();
			}
		}

		/* Creates the image gallery on the level complete screen */
		private function createObjectGallery(galleryData : Array) : void {
			Debug.log("Creating object gallery");
			_objectGallery = new Sprite();

			var movieImages : Sprite = findMovieObjects(galleryData);
			var originalsImages : Sprite = findOriginalsObjects(galleryData);
			var benefitsImages : Sprite = findBenefitObjects(galleryData);
			
			movieImages.x = 0;
			originalsImages.x = movieImages.width + 30;	
			benefitsImages.x = ((movieImages.width + 30 + originalsImages.width) - benefitsImages.width) / 2;
			benefitsImages.y = movieImages.height + 10;

			_objectGallery.addChild(movieImages);
			_objectGallery.addChild(originalsImages);
			_objectGallery.addChild(benefitsImages);

			placeGallery();
		}

		private function findMovieObjects(galleryData : Array) : Sprite {
			var xPos : Number = 0;
			var movies : Sprite = new Sprite();
			for(var i : Number = 0;i < galleryData.length;i++) {
				if(SpaceObject(galleryData[i]).isMovie) {
					Debug.log("Found movie");
					SpaceObject(galleryData[i]).resetMe();
					galleryData[i].x = xPos + (galleryData[i].width) / 2;
					movies.addChild(galleryData[i]);
					xPos += galleryData[i].width + 10;
				}
			}
			return movies;
		}

		private function findOriginalsObjects(galleryData : Array) : Sprite {
			var xPos : Number = 0;
			var originals : Sprite = new Sprite();
			for(var i : Number = 0;i < galleryData.length;i++) {
				if(SpaceObject(galleryData[i]).isOriginal) {
					Debug.log("Found original");
					SpaceObject(galleryData[i]).resetMe();
					galleryData[i].x = xPos + (galleryData[i].width) / 2;
					originals.addChild(galleryData[i]);
					xPos += galleryData[i].width + 10;
				}
			}
			return originals;
		}

		private function findBenefitObjects(galleryData : Array) : Sprite {
			var xPos : Number = 0;
			var benefits : Sprite = new Sprite();
			for(var i : Number = 0;i < galleryData.length;i++) {
				if(SpaceObject(galleryData[i]).isBenefit) {
					Debug.log("Found benefit");
					SpaceObject(galleryData[i]).resetMe();
					galleryData[i].x = xPos + (galleryData[i].width) / 2;
					benefits.addChild(galleryData[i]);
					xPos += galleryData[i].width + 10;
				}
			}
			return benefits;
		}

		private function placeGallery() : void {
			var scale : Number = 1;
			_objectGallery.scaleX = 1.5;
			_objectGallery.scaleY = 1.5;

			_objectGallery.x = ((800 - _objectGallery.width) / 2);
			_objectGallery.y = 285;
			
			_hasGallery = true;
			
			_levelCompleteScreen.addChild(_objectGallery);
		}

		private function removeOldGallery() : void {
			try {
				_levelCompleteScreen.removeChild(_objectGallery);
			} catch (e : Error) {
			}
			_hasGallery = false;
		}

		/* Starts the game */
		private function playGame(event : * = null) : void {
			if(_currentLevel == 2) {
				_triviaOne.removeEventListener(SpaceEvent.NEXT_SCREEN, playGame);
			}
			if(_currentLevel == 3) {
				_triviaTwo.removeEventListener(SpaceEvent.NEXT_SCREEN, playGame);
			}
			
			updateLevelText();
			advanceScreen(_levelScreen);
			
			if(_currentLevel == 1)_levelScreen.startDelay(SCREEN_DELAY);
			if(_currentLevel > 1)_levelScreen.startDelay(LEVEL_SCREEN_DELAY);
			_levelScreen.addEventListener(SpaceEvent.NEXT_SCREEN, advanceGame);
		}

		/* Updates the text on the level complete screen and ending screen */
		private function updateLevelText() : void {
			_levelScreen.completeText.visible = false;
			_levelScreen.levelText.text = _currentLevel;
			
			if(_currentLevel == 1) {
				_levelScreen.scoreBox.visible = false;
			}
			if(_currentLevel > 1) {
				_levelScreen.scoreBox.visible = true;
				_levelScreen.scoreBox.correctText.text = _correctAnswers;
				_levelScreen.scoreBox.incorrectText.text = _incorrectAnswers;
				_levelScreen.scoreBox.movieText.text = _moviesFound;
				_levelScreen.scoreBox.bonusText.text = _bonusFound;
				_levelScreen.scoreBox.goodText.text = _goodIconsFound;
				_levelScreen.scoreBox.badText.text = _badIconsFound;
				_levelScreen.scoreBox.timeText.text = String(_timeRemaining * 100);
				_levelScreen.totalScore.text = "Score: " + totalScore;
			}
			
			if(_currentLevel == 4) {
				_levelScreen.levelText.visible = false;
				_levelScreen.sectorText.visible = false;
				_levelScreen.completeText.visible = true;
			}
			
			resetValues();
		}

		/* Loads XML config files for each level */
		private function levelOne() : void {
			Debug.log('Level 1 Prepping');
			_xmlLoader = new XMLLoader();
			_xmlLoader.loadXML("xml/level1.xml");
			_xmlLoader.addEventListener(XMLEvent.XML_LOADED, parseXML);
		}

		private function levelTwo() : void {
			Debug.log('Level 2 Prepping');
			_xmlLoader = new XMLLoader();
			_xmlLoader.loadXML("xml/level2.xml");
			_xmlLoader.addEventListener(XMLEvent.XML_LOADED, parseXML);
		}

		private function levelThree() : void {
			Debug.log('Level 3 Prepping');
			_xmlLoader = new XMLLoader();
			_xmlLoader.loadXML("xml/level3.xml");
			_xmlLoader.addEventListener(XMLEvent.XML_LOADED, parseXML);
		}

		private function parseXML(event : XMLEvent) : void {
			_xmlLoader.removeEventListener(XMLEvent.XML_LOADED, parseXML);
			
			_spaceObjects = new Array();
			_movieList = "";
			for each(var node:XML in event.xmlData.children()) {
				if(node.name() == "required") {
					for each(var movie:XML in node.children()) {
						var spaceObjectVO : SpaceObjectVO = new SpaceObjectVO();
						spaceObjectVO.name = movie.@name.toString();
						_movieList += spaceObjectVO.name + "  |  ";
						
						spaceObjectVO.source = movie.@source.toString();
						spaceObjectVO.type = movie.@type.toString();
						
						if(movie.@moviePath.toString()) {
							spaceObjectVO.moviePath = movie.@moviePath.toString();
						}
						
						_spaceObjects.push(spaceObjectVO);
					}
				}
				if(node.name() == "items") {
					for each(var item:XML in node.children()) {
						var itemObjectVO : SpaceObjectVO = new SpaceObjectVO();
						itemObjectVO.name = item.@name.toString();
						itemObjectVO.source = item.@source.toString();
						itemObjectVO.type = item.@type.toString();
						_spaceObjects.push(itemObjectVO);
					}
				}
			}
			_movieList = _movieList.slice(0, _movieList.length - 4);
			buildLevel();
		}

		/* Creates an instance of the space game */
		private function buildLevel() : void {
			_spaceScene = new SpaceScene(800, 600, this.stage, LEVEL_LENGTH);
			_spaceScene.setDepth(10000);
			_spaceScene.movieList = _movieList;
			
			var background : Bitmap = new Bitmap();
			background.bitmapData = new BackgroundStars1(100, 100);
			
			_spaceScene.createScene(_spaceObjects, background);
			_spaceScene.activateControls();
			_spaceScene.addEventListener(SpaceEvent.LEVEL_COMPLETE, levelComplete);
			
			_audio.playLocal(new SpaceMusic());
			
			addChildAt(_spaceScene, 0);
			
			stage.focus = stage;
		}

		private function levelComplete(event : SpaceEvent) : void {
			_spaceScene.removeEventListener(SpaceEvent.LEVEL_COMPLETE, levelComplete);
			removeChild(_spaceScene);
			if(_hasGallery)removeOldGallery();
			if(event.data) {
				if(event.data.timeRemaining) {
					_timeRemaining = event.data.timeRemaining;
					totalScore += _timeRemaining * 100;
					levelCompleteScreen();
				}
				if(event.data.collectedObjects) {
					createObjectGallery(event.data.collectedObjects);
				}
			}
			if(!event.data) {
				Debug.log("Out of time");
				timesUpScreen();
			}
		}

		private function advanceGame(event : SpaceEvent) : void {
			_levelScreen.removeEventListener(SpaceEvent.NEXT_SCREEN, advanceGame);
			
			if(_currentLevel == 1)levelOne();
			if(_currentLevel == 2)levelTwo();
			if(_currentLevel == 3)levelThree();
			
		}

		private function resetValues(resetAll : Boolean = false) : void {
			_timeRemaining = 0;
			_goodIconsFound = 0;
			_badIconsFound = 0;
			_bonusFound = 0;
			_moviesFound = 0;
			_correctAnswers = 0;
			_incorrectAnswers = 0;
			
			if(resetAll) {
				totalScore = 0;
				_currentLevel = 1;
			}
		}

		private function cleanupListeners() : void {
			removeEventListener(SpaceEvent.GOOD_ITEM_CLICKED, adjustScore);
			removeEventListener(SpaceEvent.BAD_ITEM_CLICKED, adjustScore);
			removeEventListener(SpaceEvent.BONUS_ITEM_CLICKED, adjustScore);
			removeEventListener(SpaceEvent.MOVIE_ITEM_CLICKED, adjustScore);
			removeEventListener(SpaceEvent.BENEFIT_ITEM_CLICKED, adjustScore);
			removeEventListener(SpaceEvent.ORIGINALS_ITEM_CLICKED, adjustScore);
			_triviaOne.removeEventListener(SpaceEvent.RIGHT_ANSWER, adjustScore);
			_triviaOne.removeEventListener(SpaceEvent.WRONG_ANSWER, adjustScore);
			_triviaTwo.removeEventListener(SpaceEvent.RIGHT_ANSWER, adjustScore);
			_triviaTwo.removeEventListener(SpaceEvent.WRONG_ANSWER, adjustScore);
			_endingScreen.playAgain.removeEventListener(MouseEvent.MOUSE_DOWN, replayGame);
		}

		private function cleanupStage() : void {
			this.removeChildAt(0);
		}

		private function replayGame(event : MouseEvent) : void {
			Debug.log("Resetting game");
			
			_secondPlay = true;
			_currentScreen = null;
			
			SoundMixer.stopAll();
			
			resetValues(true);
			cleanupListeners();
			cleanupStage();
			startup();
		}
	}
}
