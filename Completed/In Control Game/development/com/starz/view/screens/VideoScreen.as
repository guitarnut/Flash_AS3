package com.starz.view.screens
{
	import com.starz.view.GameScreen;
	import com.starz.events.GameEvent;
	import flash.events.Event;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import com.starz.events.AnalyticsEvent;
	import com.starz.constants.Achievements;
	import com.starz.core.media.video.VideoPlayerLite;

	public class VideoScreen extends GameScreen
	{
		private var _vid:VideoPlayerLite;
		private var _bgTween:TweenLite;
		private var _buttonTween:TweenLite;
		private var _textTween:TweenLite;

		public function VideoScreen():void
		{
			init();
		}
		private function init():void
		{
			skipVideo.visible = false;
			skipVideo.addEventListener(MouseEvent.CLICK, skipTheVideo);
		}
		public function animate():void {
			_textTween = new TweenLite(text, .5, {alpha: 1});
			_buttonTween = new TweenLite(skipVideo, .5, {alpha: 1});
			_bgTween = new TweenLite(bg, .5, {alpha: 1});
		}
		public function playVideo():void
		{
			_vid = new VideoPlayerLite();
			_vid.sizeVideo(600,400);
			_vid.x = 180;
			_vid.y = 70;
			_vid.addEventListener(GameEvent.VIDEO_COMPLETE, videoComplete);
			addChild(_vid);
			skipVideo.visible = true;
			_vid.play('http://www.starz.com/videos/3qtrainingvideos_trn4072a_starz.flv');
		}
		private function skipTheVideo(e:MouseEvent):void {
			skipVideo.visible = false;
			_vid.stopVideo();
			videoComplete();
		}
		private function videoComplete(e:GameEvent = null):void {
			dispatchEvent(new GameEvent(GameEvent.START_GAME));
		}
		public function hide():void {
			hideMe();
			_vid.removeEventListener(GameEvent.VIDEO_COMPLETE, videoComplete);
			removeChild(_vid);
		}
	}

}