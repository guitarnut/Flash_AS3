package com.starz.core.media.audio {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	/**
	 * @author rhenley
	 */
	public class AudioPlayer extends Sprite {
		private var _soundChannel : SoundChannel;
		private var _soundFXChannel : SoundChannel;
		private var _loadedSound : Sound;
		private var _localMusic : Sound;
		private var _localFX : Sound;
		private var _fadingOut:Boolean = false;
		private var timer : Timer;

		public function AudioPlayer() {
			_soundChannel = new SoundChannel();
			_soundFXChannel = new SoundChannel();
		}

		/* Set playWhenLoaded to true if you want to autoplay the loaded sound */
		public function loadSound(filePath : String, playWhenLoaded : Boolean = false, loop : Boolean = false) : void {
			_loadedSound = new Sound();
			_loadedSound.load(new URLRequest(filePath));
			if((playWhenLoaded) && (!loop))_loadedSound.addEventListener(Event.COMPLETE, playLoaded);
			if((playWhenLoaded) && (loop))_loadedSound.addEventListener(Event.COMPLETE, loopLoaded);
		}

		/* Use this method to play an MP3 in the library or SWC */
		public function playLocal(mp3 : *) : void {
			//stopAllSound();
			_localMusic = mp3;
			_soundChannel = _localMusic.play();
		}
		
		/* Use this method to play an MP3 in the library or SWC */
		public function playLocalFX(mp3 : *) : void {
			_localFX = mp3;
			_soundFXChannel = _localFX.play();
		}

		public function loopLocal(mp3 : *) : void {
			_localMusic = mp3;
			_soundChannel = _localMusic.play(0, 1000);
		}

		/* Use this method to play a loaded MP3 */
		public function playLoaded(event : Event = null) : void {
			_soundChannel = _loadedSound.play();
		}

		public function loopLoaded(event : Event = null) : void {
			_soundChannel = _loadedSound.play(0, 1000);
		}

		public function stopSound() : void {
			_soundChannel.stop();
			if(_fadingOut)cleanUp();
		}

		/* Use this method to fade out an MP3 */
		public function fadeOut() : void {
			_fadingOut = true;
			timer = new Timer(20, 0);
			timer.addEventListener(TimerEvent.TIMER, reduceVolume);
			timer.start();
		}

		private function reduceVolume(event : TimerEvent) : void {
			var newVolume : Number = 1 - (Timer(event.target).currentCount * .05);
			var volume : SoundTransform = new SoundTransform();
			volume.volume = newVolume;
			_soundChannel.soundTransform = volume;
			/* Stop the sound when the volume becomes inaudible */
			if(newVolume < .01)cleanUp();
		}
		
		private function cleanUp():void {
			_soundChannel.stop();
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, reduceVolume);
			_fadingOut = false;
		}

		/* This method will silence all sounds */
		public function stopAllSound() : void {
			SoundMixer.stopAll();
		}
	}
}
