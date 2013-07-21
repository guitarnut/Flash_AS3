package com.starz.view.components {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.starz.view.GameScreen;
	import com.starz.events.GameEvent;
	import com.greensock.TweenLite;
	import com.starz.events.AnalyticsEvent;
	import com.starz.constants.Achievements;
	import com.starz.core.media.video.VideoPlayerLite;
	
	public class VideoPreview extends MovieClip {
		
		private var _vid:VideoPlayerLite;
		private var _bgTween:TweenLite;
		private var _buttonTween:TweenLite;
		private var _textTween:TweenLite;

		public function VideoPreview() {
			init();
		}
		private function init():void {
			_vid = new VideoPlayerLite();
			addChild(_vid);
			_vid.sizeVideo(400,300);
			_vid.x = 270;
			_vid.y = 108;
			_vid.addEventListener(GameEvent.VIDEO_COMPLETE, videoComplete);
			this.visible = false;
			this.alpha = 0;
		}
		public function playPreview(videoPath:String):void {
			this.visible = true;
			new TweenLite(this, .25, {alpha: 1});
			_vid.play(videoPath);
			closePreview.addEventListener(MouseEvent.CLICK, hidePreview);
		}
		private function hidePreview(e:MouseEvent):void {
			closePreview.removeEventListener(MouseEvent.CLICK, hidePreview);
			_vid.stopVideo();
			new TweenLite(this, .25, {alpha: 0, onComplete: videoComplete});
		}
		private function videoComplete(e:GameEvent = null):void {
			this.visible = false;
			dispatchEvent(new GameEvent(GameEvent.START_GAME));
		}
	}
	
}
