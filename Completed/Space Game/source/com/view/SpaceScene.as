package com.view {
	import com.constants.Scores;
	import com.events.SpaceEvent;
	import com.greensock.TweenLite;
	import com.starz.core.games.backgrounds.TiledBackground;
	import com.starz.core.games.objects.Sprite3D;
	import com.starz.core.games.timers.CountdownTimer;
	import com.starz.core.media.video.VideoPlayerLite;
	import com.starz.core.utils.Debug;
	import com.starz.core.utils.DrawRectangle;
	import com.starz.core.utils.RandomNumber;
	import com.view.components.MovementFX;
	import com.view.components.SpaceObject;
	import com.view.components.SpaceRadar;

	import mx.events.VideoEvent;

	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	/**
	 * @author rhenley
	 */

	public class SpaceScene extends Sprite {
		private static const WIDTH_PADDING : Number = 600;
		private static const HEIGHT_PADDING : Number = 100;

		private var _background : TiledBackground;
		private var _movementFX : MovementFX;
		private var _stars : Sprite3D;
		private var _radar : SpaceRadar;
		private var _console : Console;
		private var _loadScreen : LoadingScreen = new LoadingScreen();
		private var _objectVO : Array;
		private var _objectImages : Array;
		private var _spaceObjects : Array;
		private var _animatedObjects : Array;
		private var _totalObjects : Number = 0;
		public var collectedObjects : Array = new Array();
		private var _moviesFound : Number = 0;
		private var _totalMovies : Number = 0;
		private var _zDepth : Number;
		private var _width : Number;
		private var _height : Number;
		private var _stage : Stage;
		private var _levelLength : Number;
		private var _leftArrow : Boolean = false;
		private var _rightArrow : Boolean = false;
		private var _upArrow : Boolean = false;
		private var _downArrow : Boolean = false;
		private var _shift : Boolean = false;
		private var _enter : Boolean = false;
		private var _videoPlayer : VideoPlayerLite;
		private var _timer : CountdownTimer;
		public var movieList : String;

		public function SpaceScene(width : Number, height : Number, stage : Stage, levelLength : Number) : void {
			addEventListener(Event.ADDED_TO_STAGE, showMe);
			_stage = stage;
			_width = width;
			_height = height;
			_levelLength = levelLength;
			_spaceObjects = new Array();
			_animatedObjects = new Array();
			_objectImages = new Array();
		}

		/* Adds the background texture and layer of stars */
		public function createScene(objectVO : Array, background : Bitmap) : void {
			addLoadScreen();
			
			_background = new TiledBackground(background, _width, _height);
			_stars = new Sprite3D();
			
			_objectVO = objectVO;
			loadObjects();
		}

		/* Stores the Z-Depth of the space scene */
		public function setDepth(zDepth : Number) : void {
			_zDepth = zDepth;
		}

		/* Grabs the image path, object name, and type of object */
		private function loadObjects() : void {
			Debug.log('Loading movie and icon images.');
			Debug.log(_objectVO.length + ' images found.');
			for(var i : Number = 0;i < _objectVO.length;i++) {
				var loader : Loader = new Loader();
				loader.load(new URLRequest(_objectVO[i].source));
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
				_objectImages.push([loader, _objectVO[i].name, _objectVO[i].type, _objectVO[i].moviePath]);
			}
		}

		private function imageLoaded(event : Event) : void {
			event.target.removeEventListener(Event.COMPLETE, imageLoaded);
			_totalObjects++;
			if(_totalObjects == _objectImages.length) {
				Debug.log(_totalObjects + ' images loaded.');
				placeObjects();
			}
		}

		private function loadError(event : IOErrorEvent) : void {
			Debug.log(event.text);
		}

		/* Places the objects in space */
		private function placeObjects() : void {			
			for(var i : Number = 0;i < _objectImages.length;i++) {
				/* Smoothing makes the object look cleaner as it scales and rotates */
				Bitmap(Loader(_objectImages[i][0]).content).smoothing = true;
				var spaceObject : SpaceObject = new SpaceObject(DisplayObjectContainer(_objectImages[i][0]), _objectImages[i][2]);

				spaceObject.objectName = _objectImages[i][1];
				spaceObject.setZDepth(RandomNumber(_zDepth));
				spaceObject.setRange(_zDepth);
				//Objects will expand past the left and right edge
				spaceObject.x = RandomNumber(_width + WIDTH_PADDING) - WIDTH_PADDING/2;
				//Objects will NOT expand below (behind) the control panel or the top of the screen
				spaceObject.y = RandomNumber(_height - HEIGHT_PADDING * 2) + HEIGHT_PADDING;
				
				/* Check to see if there's a video trailer for the object */
				if(_objectImages[i][3] != "none") {
					spaceObject.moviePath = _objectImages[i][3];
					Debug.log('Found movie preview: ' + _objectImages[i][3]);
				}
				
				/* We keep track of all the movies that are clicked */
				if(_objectImages[i][2] == "movie") {
					spaceObject.addEventListener(SpaceEvent.MOVIE_ITEM_CLICKED, objectClicked);
					_totalMovies++;
				}
				
				/* We keep track of all the originals that are clicked */
				if(_objectImages[i][2] == "original") {
					spaceObject.addEventListener(SpaceEvent.ORIGINALS_ITEM_CLICKED, objectClicked);
					_totalMovies++;
				}
				
				/* We keep track of all the benefits that are clicked */
				if(_objectImages[i][2] == "benefit") {
					spaceObject.addEventListener(SpaceEvent.BENEFIT_ITEM_CLICKED, objectClicked);
					_totalMovies++;
				}
				
				/* This handles bonus icons, bad icons, and good icons */
				if(_objectImages[i][2] == "good")spaceObject.addEventListener(SpaceEvent.GOOD_ITEM_CLICKED, objectClicked);
				if(_objectImages[i][2] == "bad")spaceObject.addEventListener(SpaceEvent.BAD_ITEM_CLICKED, objectClicked);
				if(_objectImages[i][2] == "bonus")spaceObject.addEventListener(SpaceEvent.BONUS_ITEM_CLICKED, objectClicked);
				
				spaceObject.addEventListener(SpaceEvent.REMOVE_ITEM, removeObject);
				
				_spaceObjects.push(spaceObject);
				_animatedObjects.push(spaceObject);
				
				/* We'll arrange the objects once they've all be processed */
				if(_spaceObjects.length == _objectImages.length)setObjectDepth();
			}
		}

		private function setObjectDepth() : void {
			var lowestDepth : Number = _zDepth;
			var lowestObject : Number;
			
			/* The objects are placed from farthest to closest */
			for(var i : Number = 0;i < _spaceObjects.length;i++) {
				if(_spaceObjects[i].zDepth < lowestDepth) {
					lowestDepth = _spaceObjects[i].zDepth;
					lowestObject = i;
				}
			}
			addChildAt(_spaceObjects[lowestObject], 0);
			_spaceObjects[lowestObject].startRotation();
			_spaceObjects.splice(lowestObject, 1);
			
			if(_spaceObjects.length > 0) {
				setObjectDepth();
			} else {
				createRadar();
				createConsole();
				createBackground();
				createTimer();
				removeLoadScreen();
			}
		}

		private function addLoadScreen() : void {
			addChild(_loadScreen);
			Debug.log("Adding load screen");
		}

		private function removeLoadScreen() : void {
			removeChild(_loadScreen);
			Debug.log("Removing load screen");
		}

		public function activateControls() : void {
			_stage.addEventListener(Event.ENTER_FRAME, selectMovement);
			_stage.addEventListener(KeyboardEvent.KEY_UP, nokeyHit);
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHit);
		}

		/* Game objects on the stage */
		private function createRadar() : void {
			_radar = new SpaceRadar(_width, _height);
			_radar.x = 10;
			_radar.y = 10;
			addChild(_radar);
		}

		private function createConsole() : void {
			_console = new Console();
			_console.x = 0;
			_console.y = 537;
			
			_console.movieList.text = movieList;
			_console.movieCount.text = "FOUND " + _moviesFound + " OF " + _totalMovies;
			addChild(_console);
		}

		private function updateConsole() : void {
			_console.movieCount.text = "FOUND " + _moviesFound + " OF " + _totalMovies;
		}

		/* This allows the background stars to move slowly as the user moves around space */
		private function createBackground() : void {
			_stars.addTexture(new StarsBackground());
			_stars.x = 0;
			_stars.y = 0;
			_stars.zDepth = _zDepth - _zDepth / 30;
			_stars.range = _zDepth;
			
			_movementFX = new MovementFX();
			_movementFX.x = _width / 2;
			_movementFX.y = _height / 2;
			_movementFX.stopScrolling();
			
			addChildAt(_movementFX, 0);
			addChildAt(_stars, 0);
			addChildAt(_background, 0);
		}

		/* Game timer */
		private function createTimer() : void {
			_timer = new CountdownTimer();
			_timer.setTimer(_levelLength);
			_timer.x = 725;
			_timer.y = 537;
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timesUp);
			
			addChild(_timer);
		}

		private function timesUp(event : TimerEvent) : void {
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timesUp);
			dispatchEvent(new SpaceEvent(SpaceEvent.LEVEL_COMPLETE, false, false));
		}

		/* Handle the clicking of movies and bonus/penalty icons */
		private function objectClicked(event : SpaceEvent) : void {
			if(event.target.isMovie) {
				dispatchEvent(new SpaceEvent(SpaceEvent.MOVIE_ITEM_CLICKED, false, true));
				_moviesFound++;
				updateConsole();
			}
			if(event.target.isOriginal) {
				dispatchEvent(new SpaceEvent(SpaceEvent.ORIGINALS_ITEM_CLICKED, false, true));
				_moviesFound++;
				updateConsole();
			}
			if(event.target.isBenefit) {
				dispatchEvent(new SpaceEvent(SpaceEvent.BENEFIT_ITEM_CLICKED, false, true));
				_moviesFound++;
				updateConsole();
			}
			if(event.target.isGood) {
				dispatchEvent(new SpaceEvent(SpaceEvent.GOOD_ITEM_CLICKED, false, true));
				var myTimeBonus : timeBonus = new timeBonus();
				myTimeBonus.x = mouseX;
				myTimeBonus.y = mouseY;
				addChild(myTimeBonus);
				_timer.addTime(Scores.TIME_BONUS);
			}
			if(event.target.isBad) {
				dispatchEvent(new SpaceEvent(SpaceEvent.BAD_ITEM_CLICKED, false, true));
				var myTimePenalty : timePenalty = new timePenalty();
				myTimePenalty.x = mouseX;
				myTimePenalty.y = mouseY;
				addChild(myTimePenalty);
				_timer.removeTime(Scores.TIME_PENALTY);
			}
			if(event.target.isBonus) {
				dispatchEvent(new SpaceEvent(SpaceEvent.BONUS_ITEM_CLICKED, false, true));
				var myBonus : bonus = new bonus()
				myBonus.x = mouseX;
				myBonus.y = mouseY;
				addChild(myBonus);
				_timer.addTime(Scores.BIG_TIME_BONUS);
			}
			
			if((_moviesFound == _totalMovies) && (event.target.moviePath == "none")) {
				SpaceObject(event.target).killTweens();
				
				var data : Object = new Object();
				data.timeRemaining = _timer.seconds;
				data.collectedObjects = collectedObjects;
				
				levelComplete(data);
			}
		}

		/* This pauses the game and allows the last animation on your final clicked object to complete */
		private function levelComplete(data : Object) : void {
			/* Stop the game timer */
			_timer.pauseTime();
			
			var timer : Timer = new Timer(2000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, endLevel);
			timer.start();
			function endLevel(event : TimerEvent) : void {
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, endLevel);
				dispatchEvent(new SpaceEvent(SpaceEvent.LEVEL_COMPLETE, data, false, true));
			}
		}

		/* Removes clicked objects */
		private function removeObject(event : SpaceEvent) : void {
			/* Play the video trailer if it's present */
			if(event.target.moviePath != "none")playVideo(event.target.moviePath);
			event.target.isVisible = false;
		}

		private function playVideo(videoPath : String) : void {
			_timer.pauseTime();
			
			var bg : Sprite = DrawRectangle(_stage.stageWidth, _stage.stageHeight, 0x000000, .9);
			addChild(bg);
			
			_videoPlayer = new VideoPlayerLite();
			_videoPlayer.sizeVideo(400, 300);
			_videoPlayer.play(videoPath);
			_videoPlayer.x = _stage.stageWidth / 2 - _videoPlayer.width / 2;
			_videoPlayer.y = (_stage.stageHeight / 2 - _videoPlayer.height / 2) - 20;
			_videoPlayer.addEventListener(VideoEvent.COMPLETE, removeVideo);
			addChild(_videoPlayer);

			function removeVideo(event : VideoEvent) : void {
				if(_moviesFound == _totalMovies)dispatchEvent(new SpaceEvent(SpaceEvent.LEVEL_COMPLETE, true, true));
				
				_videoPlayer.removeEventListener(VideoEvent.COMPLETE, removeVideo);
				
				removeChild(bg);
				removeChild(_videoPlayer);
				
				_timer.resumeTime();
			}
		}

		/* Game movement */
		public function selectMovement(event : Event) : void {
			if (_leftArrow) {
				_stars.moveRight();
			}
			if (_rightArrow) {
				_stars.moveLeft();
			}
			if (_upArrow) {
				//_stars.moveDown();
			}
			if (_downArrow) {
				//_stars.moveUp();
			}
			for(var i : Number = 0;i < _animatedObjects.length;i++) {
				if (_leftArrow) {
					_animatedObjects[i].moveRight();
				}
				if (_rightArrow) {
					_animatedObjects[i].moveLeft();
				}
				if (_upArrow) {
					//_animatedObjects[i].moveDown();
					_animatedObjects[i].moveForward();
					_movementFX.moveForwards();
				}
				if (_downArrow) {
					//_animatedObjects[i].moveUp();
					_animatedObjects[i].moveBack();
					_movementFX.moveBackwards();
				}
				if (_shift) {
					//_animatedObjects[i].moveBack();
					//_movementFX.moveBackwards();
				}
				if (_enter) {
					//_animatedObjects[i].moveForward();
					//_movementFX.moveForwards();
				}
			}
			try {
				_radar.updateRadar(_animatedObjects);
			} catch (e : Error) {
			}
		}

		private function keyHit(event : KeyboardEvent) : void {
			switch (event.keyCode) {
				case Keyboard.RIGHT :
					_rightArrow = true;
					break;
				case Keyboard.LEFT :
					_leftArrow = true;
					break;
				case Keyboard.UP :
					_upArrow = true;
					break;
				case Keyboard.DOWN :
					_downArrow = true;
					break;
				case Keyboard.SHIFT :
					//_shift = true;
					break;
				case Keyboard.ENTER :
					//_enter = true;
					break;
			}
		}

		private function nokeyHit(event : KeyboardEvent) : void {
			_movementFX.stopScrolling();
			switch (event.keyCode) {
				case Keyboard.RIGHT :
					_rightArrow = false;
					break;
				case Keyboard.LEFT :
					_leftArrow = false;
					break;
				case Keyboard.UP :
					_upArrow = false;
					break;
				case Keyboard.DOWN :
					_downArrow = false;
					break;
				case Keyboard.SHIFT :
					//_shift = false;
					break;
				case Keyboard.ENTER :
					//_enter = false;
					break;
			}
		}

		private function showMe(event : Event) : void {
			new TweenLite(this, .5, {alpha: 1});
		}

		public function hideMe() : void {
			new TweenLite(this, .5, {alpha: 0});
		}

		private function removeMe() : void {
			//Sprite(this.parent).removeChild(this);
			//this.visible = false;
		}
	}
}
