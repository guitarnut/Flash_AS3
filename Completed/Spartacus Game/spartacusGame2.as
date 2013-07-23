package {

	import com.screens.*;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.net.*;

	public class spartacusGame extends MovieClip {
		/* Audio */
		private var audioCount:Number=0;
		private var audioTotal:Number=9;
		private var audioVolume:Number = .6;
		private var FXaudioVolume:Number = .4;
		private var volumeAdjust:SoundTransform;
		private var FXvolumeAdjust:SoundTransform;
		private var musicChannel:SoundChannel;
		private var fxChannel:SoundChannel;
		private var swordFX:Sound = new Sound();
		private var shieldFX:Sound = new Sound();
		private var sledgehammerFX:Sound = new Sound();
		private var titleMusic:Sound = new Sound();
		private var characterMusic:Sound = new Sound();
		private var battleMusic:Sound = new Sound();
		private var goodEndingMusic:Sound = new Sound();
		private var badEndingMusic:Sound = new Sound();
		private var triviaMusic:Sound = new Sound();
		/* Game Screens */
		public var myTitleScreen:gameScreen = new gameScreen();
		public var myInstructionsScreen:gameScreen = new gameScreen();
		public var myCharacterScreen:gameScreen = new gameScreen();
		public var myTriviaScreen:gameScreen = new gameScreen();
		public var myBattleScreen:gameScreen = new gameScreen();
		private var currentScreen:Object;
		/* Variables */
		public var playerCharacter:String;

		public function spartacusGame():void {
			init();
		}
		private function init():void {
			buildGameScreens();
			setupAudio();
		}
		/* ------------------------------------------------------------------------- Game Screens and Screen Transitions ------------------------------------------------------------ */
		/* Create the instance for each game screen */
		private function buildGameScreens():void {
			currentScreen = new Object();
			myTitleScreen.addChild(new titleScreen);
			myInstructionsScreen.addChild(new instructionsScreen);
			myCharacterScreen.addChild(new characterScreen);
			myBattleScreen.addChild(new battleScreen);
			myTriviaScreen.addChild(new triviaScreen);
		}
		public function changeScreens(thisScreen:gameScreen):void {
			try {
				currentScreen.screen.removeMe();
			} catch (e:Error) {
			}
			addChildAt(thisScreen, 0);
			currentScreen.screen=thisScreen;
		}
		/* ------------------------------------------------------------------------- Game Audio ------------------------------------------------------------ */
		private function setupAudio():void {
			musicChannel = new SoundChannel();
			fxChannel = new SoundChannel();
			volumeAdjust = new SoundTransform(audioVolume);
			FXvolumeAdjust = new SoundTransform(FXaudioVolume);
			/* Music */
			titleMusic.load(new URLRequest("audio/Intro.mp3"));
			audioLoadProgress(titleMusic);
			characterMusic.load(new URLRequest("audio/Characters.mp3"));
			audioLoadProgress(characterMusic);
			battleMusic.load(new URLRequest("audio/Combat.mp3"));
			audioLoadProgress(battleMusic);
			triviaMusic.load(new URLRequest("audio/Trivia.mp3"));
			audioLoadProgress(triviaMusic);
			goodEndingMusic.load(new URLRequest("audio/Ending.mp3"));
			audioLoadProgress(goodEndingMusic);
			badEndingMusic.load(new URLRequest("audio/EndingBad.mp3"));
			audioLoadProgress(badEndingMusic);
			/* Sound FX */
			swordFX.load(new URLRequest("audio/WeaponFX1.mp3"));
			audioLoadProgress(swordFX);
			shieldFX.load(new URLRequest("audio/WeaponFX2.mp3"));
			audioLoadProgress(shieldFX);
			sledgehammerFX.load(new URLRequest("audio/WeaponFX3.mp3"));
			audioLoadProgress(sledgehammerFX);
			/* Check the files as they load */
			addEventListener(Event.ENTER_FRAME, checkAudioProgress);
		}
		private function audioLoadProgress(audioName):void {
			audioName.addEventListener(ProgressEvent.PROGRESS, checkLoadStatus);
			function checkLoadStatus(event:Event):void {
				if (event.target.bytesLoaded==event.target.bytesTotal) {
					event.target.removeEventListener(ProgressEvent.PROGRESS, checkLoadStatus);
					audioCount++;
					preloader.audioStatus.text = String(audioCount) + " OF " + String(audioTotal) + " FILES READY";
				}
			}
		}
		private function checkAudioProgress(event:Event):void {
			if (audioCount==audioTotal) {
				removePreloader();
				removeEventListener(Event.ENTER_FRAME, checkAudioProgress);
				addChildAt(myTitleScreen, 0);
				currentScreen.screen=myTitleScreen;
			}
		}
		public function playMusic(musicName:String):void {
			stopMusic();
			switch (musicName) {
				case "Title" :
					musicChannel=titleMusic.play();
					break;
				case "Characters" :
					musicChannel=characterMusic.play();
					break;
				case "Battle" :
					musicChannel=battleMusic.play();
					break;
				case "Trivia" :
					musicChannel=triviaMusic.play();
					break;
				case "Victory" :
					musicChannel=goodEndingMusic.play();
					break;
				case "Defeat" :
					musicChannel=badEndingMusic.play();
					break;
				default :
					break;
			}
			musicChannel.soundTransform = volumeAdjust;
		}
		public function playFX(FXName:String):void {
			switch (FXName) {
				case "Sword" :
					fxChannel=swordFX.play();
					break;
				case "Shield" :
					fxChannel=shieldFX.play();
					break;
				case "Sledgehammer" :
					fxChannel=sledgehammerFX.play();
					break;
				default :
					break;
			}
			fxChannel.soundTransform = FXvolumeAdjust;
		}
		public function stopMusic():void {
			SoundMixer.stopAll();
		}
	}
}