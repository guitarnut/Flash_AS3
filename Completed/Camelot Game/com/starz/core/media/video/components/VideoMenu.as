package com.starz.core.media.video.components {
	import flash.events.FullScreenEvent;
	import com.greensock.TweenLite;
	import com.starz.core.media.video.events.VideoControlEvent;
	import com.starz.core.utils.Debug;

	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	/**
	 * @author rhenley
	 */
	public class VideoMenu extends VideoControls {
		private static const TWEEN_SPEED : Number = .25;
		private static const VISIBLE_DELAY : Number = 3;

		private var _controlsTween : TweenLite;
		private var _visibleTimer : Timer;
		private var _seeking : Boolean = false;
		private var _volumeRange : Number;

		public function VideoMenu() {
			this.alpha = 0;
			this.visible = false;
			
			setupControls();
			createDelayTimer();
		}

		private function setupControls() : void {
			videoButtons.pauseVideo.visible = false;
			videoButtons.pauseVideo.buttonMode = true;
			videoButtons.pauseVideo.addEventListener(MouseEvent.MOUSE_DOWN, pauseClicked);
			
			videoButtons.playVideo.buttonMode = true;
			videoButtons.playVideo.addEventListener(MouseEvent.MOUSE_DOWN, playClicked);
			
			videoButtons.stopVideo.buttonMode = true;
			videoButtons.stopVideo.addEventListener(MouseEvent.MOUSE_DOWN, stopClicked);
			
			videoButtons.fullScreen.buttonMode = true;
			videoButtons.fullScreen.addEventListener(MouseEvent.MOUSE_DOWN, fullscreenClicked);
			
			videoButtons.prevVideo.buttonMode = true;
			videoButtons.prevVideo.addEventListener(MouseEvent.MOUSE_DOWN, prevClicked);
			videoButtons.prevVideo.visible = false;
			
			videoButtons.nextVideo.buttonMode = true;
			videoButtons.nextVideo.addEventListener(MouseEvent.MOUSE_DOWN, nextClicked);
			videoButtons.nextVideo.visible = false;
			
			videoButtons.volumeBar.buttonMode = true;
			videoButtons.volumeBar.addEventListener(MouseEvent.MOUSE_DOWN, volumeClicked);
			_volumeRange = videoButtons.volumeBar.width;
		}

		private function pauseClicked(event : MouseEvent) : void {
			togglePlayPause();
			dispatchEvent(new VideoControlEvent(VideoControlEvent.PAUSE_CLICKED));
		}

		private function playClicked(event : MouseEvent) : void {
			togglePlayPause();
			dispatchEvent(new VideoControlEvent(VideoControlEvent.PLAY_CLICKED));
		}

		private function stopClicked(event : MouseEvent) : void {
			dispatchEvent(new VideoControlEvent(VideoControlEvent.STOP_CLICKED));
			videoButtons.pauseVideo.visible = false;
			videoButtons.playVideo.visible = true;
		}

		private function fullscreenClicked(event : MouseEvent) : void {
			dispatchEvent(new VideoControlEvent(VideoControlEvent.FULLSCREEN_CLICKED));
		}

		private function prevClicked(event : MouseEvent) : void {
			dispatchEvent(new VideoControlEvent(VideoControlEvent.PREVIOUS_CLICKED));
		}

		private function nextClicked(event : MouseEvent) : void {
			dispatchEvent(new VideoControlEvent(VideoControlEvent.NEXT_CLICKED));
		}
		
		private function volumeClicked(event : MouseEvent) : void {
			videoButtons.volumeBar.volumeMask.width = event.target.mouseX;
			var volume : Object;
			volume = new Object();
			volume.newVolume = event.target.mouseX / _volumeRange;
			
			dispatchEvent(new VideoControlEvent(VideoControlEvent.VOLUME_CLICKED, volume));
		}

		private function togglePlayPause() : void {
			if(videoButtons.pauseVideo.visible) {
				videoButtons.pauseVideo.visible = false;
				videoButtons.playVideo.visible = true;
			} else {
				videoButtons.pauseVideo.visible = true;
				videoButtons.playVideo.visible = false;
			}
		}

		public function updateTime(time : Number) : void {
			var minutesPlayed : Number;
			minutesPlayed = Math.floor(time / 60);
			
			var secondsPlayed : Number;
			secondsPlayed = Math.round(time-(60*minutesPlayed));
						
			var minutesText : String = String(minutesPlayed);
			var secondsText : String = String(secondsPlayed);
			
			if(secondsText.length == 1)secondsText = "0" + secondsText;
			if(minutesText.length == 0)minutesText = "00";
			if(minutesText.length == 1)minutesText = "0" + minutesText;
			
			videoButtons.timeText.text = minutesText + ":" + secondsText;
		}

		public function activateSeekbar() : void {
			videoButtons.videoSeekbar.seekbarHandle.buttonMode = true;
			videoButtons.videoSeekbar.seekbarHandle.addEventListener(MouseEvent.MOUSE_DOWN, startSeek);
			videoButtons.videoSeekbar.seekbarHandle.addEventListener(MouseEvent.MOUSE_UP, stopSeek);
		}

		public function updateSeekbar(position : Number) : void {
			if(!_seeking)videoButtons.videoSeekbar.seekbarHandle.x = position * (videoButtons.videoSeekbar.seekbarBackground.width-videoButtons.videoSeekbar.seekbarHandle.width);
		}

		private function startSeek(event : MouseEvent) : void {
			_seeking = true;
			var dragRectangle : Rectangle = new Rectangle(videoButtons.videoSeekbar.seekbarBackground.x, -videoButtons.videoSeekbar.seekbarHandle.height / 2, videoButtons.videoSeekbar.seekbarBackground.width, -videoButtons.videoSeekbar.seekbarHandle.height / 2);
			videoButtons.videoSeekbar.seekbarHandle.startDrag(false, dragRectangle);
		}

		private function stopSeek(event : MouseEvent) : void {
			_seeking = false;
			videoButtons.videoSeekbar.seekbarHandle.stopDrag();
			var seekPosition : Object = new Object();
			seekPosition.position = videoButtons.videoSeekbar.seekbarHandle.x / videoButtons.videoSeekbar.seekbarBackground.width;
			dispatchEvent(new VideoControlEvent(VideoControlEvent.SEEK, seekPosition));
		}
		
		public function resetMenu() : void {
			videoButtons.videoSeekbar.seekbarHandle.x = 0;
			videoButtons.videoSeekbar.seekbarHandle.buttonMode = false;
			if(videoButtons.videoSeekbar.seekbarHandle.hasEventListener(MouseEvent.MOUSE_DOWN))videoButtons.videoSeekbar.seekbarHandle.removeEventListener(MouseEvent.MOUSE_DOWN, startSeek);
			if(videoButtons.videoSeekbar.seekbarHandle.hasEventListener(MouseEvent.MOUSE_DOWN))videoButtons.videoSeekbar.seekbarHandle.removeEventListener(MouseEvent.MOUSE_UP, stopSeek);
			togglePlayPause();
		}

		private function createDelayTimer() : void {
			_visibleTimer = new Timer(VISIBLE_DELAY * 1000, 0);
			_visibleTimer.addEventListener(TimerEvent.TIMER, hide);
		}

		public function show() : void {
			if(!this.visible)this.visible = true;
			if(this.alpha != 1)_controlsTween = new TweenLite(this, TWEEN_SPEED, {alpha : 1});
			_visibleTimer.reset();
			_visibleTimer.start();
		}

		public function hide(event : TimerEvent = null) : void {
			_controlsTween = new TweenLite(this, TWEEN_SPEED, {onComplete: destroy, alpha : 0});
		}

		private function destroy() : void {
			this.visible = false;
		}
	}
}
