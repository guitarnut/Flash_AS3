package com.starz.view.components
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import com.starz.events.GameEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.starz.constants.ApplicationSettings;
	import com.starz.view.GameScreen;
	import com.starz.constants.Achievements;
	import com.starz.core.media.audio.AudioPlayer;
	import com.starz.constants.GameScores;

	public class Television extends MovieClip
	{
		private static const BONUS_IMAGE_FRAME:Number = 18;
		private static const PREVIEW_IMAGE_FRAME:Number = 19;
		private static const GOOD_IMAGE_FRAME:Number = 20;
		private static const IMAGE_MAX:Number = 3;
		private static const SWITCH_IMAGE_DELAY:Number = 500;

		public var difficulty:Number;
		private var _gameData:Object = new Object();
		private var _timer:Timer;
		private var _startupTimer:Timer;
		private var _goodImage:Boolean;
		private var _badImage:Boolean;
		private var _previewImage:Boolean;
		private var _bonusImage:Boolean;
		private var _paused:Boolean = false;
		private var _imageCount:Number = 1;
		private var _frame:Number;
		private var _crackTween:TweenLite;
		private var _panicTween:TweenLite;
		private var _soundFX:AudioPlayer;

		public function Television()
		{
			init();
		}
		private function init():void
		{
			_startupTimer = new Timer(Math.random() * 5000,1);
			_startupTimer.addEventListener(TimerEvent.TIMER, selectImage);
			_soundFX = new AudioPlayer();
			reset();
			stop();
		}
		public function startup():void
		{
			reset();
			difficulty = MovieClip(this.parent).difficulty;
			_startupTimer.start();
		}
		public function reset():void
		{
			timer.visible = true;
			mouseChildren = false;
			content.crack.visible = false;
			content.visible = false;
			finalImage.visible = false;
			staticFX.visible = true;
			rotation = 0;
			scaleX = 1;
			scaleY = 1;
			_imageCount = 1;
			addListeners();
		}
		private function addListeners():void
		{
			timer.addEventListener(GameEvent.TIMES_UP, breakTV);
			timer.addEventListener(GameEvent.PANIC, panic);
		}
		private function removeListeners():void
		{
			if (timer.hasEventListener(GameEvent.TIMES_UP))
			{
				timer.removeEventListener(GameEvent.TIMES_UP, breakTV);
			}
			if (timer.hasEventListener(GameEvent.PANIC))
			{
				timer.removeEventListener(GameEvent.PANIC, panic);
			}
			if (hasEventListener(MouseEvent.CLICK))
			{
				removeEventListener(MouseEvent.CLICK, clickHandler);
			}
		}
		private function clickHandler(e:MouseEvent):void
		{
			if (! _paused)
			{
				removeEventListener(MouseEvent.CLICK, clickHandler);

				resetTimer();

				staticFX.visible = true;
				_imageCount++;

				if (_goodImage)
				{
					addChild(new Great());
					adjustScore(GameScores.POINTS_TV_COMPLETE);
					lockGoodImage();
				}
				if (_bonusImage)
				{
					addChild(new Bonus());
					adjustScore(GameScores.POINTS_BONUS);
					bonusImage();
				}
				if (_previewImage)
				{
					previewImage();
				}
				if (_badImage)
				{
					adjustScore(GameScores.POINTS_TV_CLICK);
					if (_imageCount > IMAGE_MAX)
					{
						showImage(GOOD_IMAGE_FRAME);
					}
					else
					{
						selectImage();
					}
				}
			}
		}
		private function selectImage(e:TimerEvent=null):void
		{
			_frame = Math.round(Math.random() * content.totalFrames);

			if (_frame == PREVIEW_IMAGE_FRAME)
			{
				if (MovieClip(this.parent).previewPlayed)
				{
					selectImage();
				}
				else
				{
					MovieClip(this.parent).previewPlayed = true;
					showImage(_frame);
				}
			}
			else
			{
				showImage(_frame);
			}
		}
		private function showImage(frame:Number):void
		{
			_frame = frame;

			_goodImage = false;
			_badImage = false;
			_bonusImage = false;
			_previewImage = false;

			if (_frame == BONUS_IMAGE_FRAME)
			{
				timer.rushTimer = true;
				_bonusImage = true;
			}
			else if (_frame == PREVIEW_IMAGE_FRAME)
			{
				_previewImage = true;
			}
			else if (_frame == GOOD_IMAGE_FRAME)
			{
				timer.rushTimer = true;
				_goodImage = true;
			}
			else
			{
				playStaticFX();
				_badImage = true;
			}

			_timer = new Timer(SWITCH_IMAGE_DELAY,1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, displayNextImage);
			_timer.start();
		}
		private function playStaticFX():void {
			//_soundFX.playLocalFX(new StaticFX());
		}
		private function playHurryFX():void {
			_soundFX.playLocalFX(new HurryFX());
		}
		private function displayNextImage(e:TimerEvent):void
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, displayNextImage);

			staticFX.visible = false;
			content.visible = true;
			content.gotoAndStop(_frame);

			addEventListener(MouseEvent.CLICK, clickHandler);
			startTimer();
		}
		public function startTimer():void
		{
			if (! _paused)
			{
				timer.startTimer(1);
			}
			else
			{
				timer.setTimer(0);
			}
		}
		public function pause():void
		{
			_paused = true;
			timer.pauseTimer();
		}
		public function resume():void
		{
			_paused = false;

			if (! _previewImage)
			{
				timer.resumeTimer();
			}
			else
			{
				selectImage();
			}
		}
		private function resetTimer():void
		{
			timer.reset();
		}
		private function panic(e:GameEvent = null):void
		{
			if (e)
			{
				addChild(new Hurry());
				playHurryFX();
				_panicTween = new TweenLite(this,.25,{scaleX:1.08,scaleY:1.08,onComplete:panic});
			}
			else
			{
				_panicTween = new TweenLite(this,.25,{scaleX:1,scaleY:1});
			}
		}
		private function breakTV(e:GameEvent = null):void
		{
			if (_bonusImage)
			{
				selectImage();
			}
			else if (_previewImage)
			{
				selectImage();
			}
			else if (_goodImage)
			{
				_imageCount = 2;
				selectImage();
			}
			else
			{
				removeListeners();
				adjustScore(GameScores.POINTS_TV_BREAK);
				GameScreen(this.parent.parent).achievement(Achievements.BAD_RECEPTION);
				content.crack.visible = true;
				_crackTween = new TweenLite(this,1,{scaleX:1.05,scaleY:1.05,rotation:determineBrokenSettings(),ease:Bounce.easeOut});
				dispatchEvent(new GameEvent(GameEvent.BAD_CLICK, true));
			}
		}
		private function adjustScore(score:Number):void
		{
			_gameData.points = score;
			dispatchEvent(new GameEvent(GameEvent.UPDATE_SCORE, _gameData, true, false));
		}
		private function determineBrokenSettings():Number
		{
			var rotate:Number;
			rotate = Math.random() * 20;
			if (Math.random() * 10 > 5)
			{
				rotate *=  -1;
			}
			return rotate;
		}
		private function lockGoodImage(e:GameEvent = null):void
		{
			timer.visible = false;
			dispatchEvent(new GameEvent(GameEvent.GOOD_CLICK, true));
			showFinalImage();
		}
		private function bonusImage():void
		{
			dispatchEvent(new GameEvent(GameEvent.BONUS_CLICK));
			selectImage();
		}
		private function previewImage():void
		{
			dispatchEvent(new GameEvent(GameEvent.PREVIEW_CLICK));
		}
		public function showFinalImage():void
		{
			removeListeners();

			var tv:String = String(this.name);
			tv = tv.replace("tv","");
			var endFrame:Number = Number(tv);

			content.visible = false;
			staticFX.visible = false;

			finalImage.gotoAndStop(endFrame);
			finalImage.visible = true;
		}
	}
}