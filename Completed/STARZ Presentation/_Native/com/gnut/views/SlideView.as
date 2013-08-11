package com.gnut.views {
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import com.gnut.events.PresentationEvent;
	import com.gnut.Application;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	import flash.errors.IOError;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import fl.video.FLVPlayback;
	
	public class SlideView extends Sprite {
		private static const TRANSITION_SPEED:Number = .5;
		private var _ready:Boolean = false;
		private var _type:String;
		private var _asset:*;
		private var _videosettings:Object;
		private var _flv:FLVPlayback

		public function SlideView($t:String, $a:*, $v:Object) {
			_type = $t;
			_asset = $a;
			_videosettings = $v;
			
			init();
		}
		private function init():void {
			visible = false;
			alpha = 0;
			buildSlide();
		}
		private function buildSlide():void {
			switch (_type) {
				case Application.IMAGE_SLIDE:
					loadImage();
					break;
				case Application.VIDEO_SLIDE:
					loadVideo();
					break;
				default:
					break;
			}
			
		}
		private function loadImage():void {
			var loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, assetLoaded);
			loader.load(new URLRequest(_asset));
		}
		private function loadVideo():void {
			_flv = new FLVPlayback();
			_flv.fullScreenTakeOver = false;
			_flv.autoPlay = false;
			_flv.source = _asset;
			_flv.pause();
			_flv.width = _videosettings.width;
			_flv.height = _videosettings.height;
			_flv.x = (Application.STAGE_WIDTH-_flv.width)/2;
			_flv.y = (Application.STAGE_HEIGHT-_flv.height)/2;
			
			addChild(_flv);
			
			slideReady();
		}
		private function playVideo():void {
			_flv.play();
		}
		private function stopVideo():void {
			if(_flv) {
				_flv.stop();
				_flv.seek(0);

			}
		}
		private function assetLoaded(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, assetLoaded);
			var $b:Bitmap = e.target.content as Bitmap;
			$b.smoothing = true;
			addChild($b);
			
			slideReady();
		}
		private function slideReady():void {
			_ready = true;
	
			dispatchEvent(new PresentationEvent(PresentationEvent.SLIDE_READY));
		}
		private function playSlide():void {			
			if(_type == Application.VIDEO_SLIDE) {
				playVideo();
			}
		}
		public function show():void {
			visible = true;
			new TweenLite(this, TRANSITION_SPEED, {alpha: 1, onComplete: playSlide});		
		}
		public function hide():void {
			stopVideo();
			new TweenLite(this, TRANSITION_SPEED, {alpha: 0, onComplete: destroy});		
		}
		private function destroy():void {
			visible = false;
			dispatchEvent(new PresentationEvent(PresentationEvent.SLIDE_COMPLETE));
		}
		public function get ready():Boolean {
			return _ready;
		}

	}
	
}
