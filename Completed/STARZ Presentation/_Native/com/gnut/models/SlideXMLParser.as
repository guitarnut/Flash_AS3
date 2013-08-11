package com.gnut.models {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.Sprite;
	import com.gnut.Application;
	
	public class SlideXMLParser extends Sprite {
		private var _xml:XML;
		private var _slides:Array;

		public function SlideXMLParser() {
			
		}
		private function parseXML():void {
			var xmlData = _xml;
			
			_slides = new Array();
			
			for each(var $x:XML in xmlData.slide) {
				var slide = new SlideVO();
				var $t:String;
				var $v_settings:Object;
				
				switch(String($x.type).toLowerCase()) {
					case 'image':
						$t = Application.BASE_PATH+Application.IMAGE_SLIDE;
						break;
					case 'video':
						$t = Application.BASE_PATH+Application.VIDEO_SLIDE;
						$v_settings = new Object();
						$v_settings.height = $x.assets.video.@height;
						$v_settings.width = $x.assets.video.@width;
						break
					default:
						break;
				}
				var $a = String($x.assets.children()[0]);
				
				slide.type = $t;
				slide.asset = $a;
				slide.videosettings = $v_settings;
				
				_slides.push(slide);
			}
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}

		public function set xml($x):void {
			_xml = $x;
			parseXML();
		}
		public function get slides():Array {
			return _slides;
		}

	}
	
}
