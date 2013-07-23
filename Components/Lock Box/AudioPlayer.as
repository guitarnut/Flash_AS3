package com.starz.core.media.audio {
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;

	/**
	 * @author rhenley
	 */
	public class AudioPlayer extends Sprite {
		private var _soundChannel : SoundChannel;
		private var _sound : Sound;

		public function AudioPlayer() {
			_soundChannel = new SoundChannel();
		}

		/* Set playWhenLoaded to true if you want to autoplay the loaded sound */
		public function loadSound(filePath : String, playWhenLoaded : Boolean = false, loop : Boolean = false) : void {
			_sound = new Sound();
			_sound.load(new URLRequest(filePath));
			if((playWhenLoaded) && (!loop))_sound.addEventListener(Event.COMPLETE, playLoaded);
			if((playWhenLoaded) && (loop))_sound.addEventListener(Event.COMPLETE, loopLoaded);
		}

		/* Use this method to play an MP3 in the library or SWC */
		public function playLocal(mp3 : *) : void {
			var mySound : Sound = new mp3();
			_soundChannel = mySound.play();
		}

		public function loopLocal(mp3 : *) : void {
			var mySound : Sound = new mp3();
			_soundChannel = mySound.play(0, 1000);
		}

		/* Use this method to play a loaded MP3 */
		public function playLoaded(event : Event = null) : void {
			_soundChannel = _sound.play();
		}

		public function loopLoaded(event : Event = null) : void {
			_soundChannel = _sound.play(0, 1000);
		}

		public function stopSound() : void {
			_soundChannel.stop();
		}

		/* This method will silence all sounds */
		public function stopAllSound() : void {
			SoundMixer.stopAll();
		}
	}
}
