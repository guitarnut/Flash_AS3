package com.starz.view
{
	import com.starz.view.components.GameScreen;
	import com.starz.events.GameEvent;
	import flash.events.Event;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import com.starz.events.AnalyticsEvent;
	import com.starz.constants.Achievements;
	import com.starz.core.media.video.VideoPlayerLite;

	public class VideoScreen extends GameScreen
	{
		private var _gawainTween:TweenLite;
		private var _textTween:TweenLite;
		private var _nextTween:TweenLite;
		private var _charactersTween:TweenLite;
		private var _vid:VideoPlayerLite;

		public function VideoScreen():void
		{
			init();
		}
		private function init():void
		{
			_vid = new VideoPlayerLite();
			addChild(_vid);
			_vid.sizeVideo(600,400);
			_vid.x = 212;
			_vid.y = 120;
			_vid.addEventListener(GameEvent.VIDEO_COMPLETE, videoComplete);
			skipVideo.visible = false;
			skipVideo.addEventListener(MouseEvent.CLICK, skipTheVideo);
		}
		public function playVideo():void
		{
			skipVideo.visible = true;
			_vid.play('http://www.starz.com/videos/camelot_teaser_short.flv');
		}
		private function skipTheVideo(e:MouseEvent):void {
			skipVideo.visible = false;
			_vid.stopVideo();
			videoComplete();
		}
		private function videoComplete(e:GameEvent = null):void {
			dispatchEvent(new GameEvent(GameEvent.VIDEO_COMPLETE));
		}
	}

}