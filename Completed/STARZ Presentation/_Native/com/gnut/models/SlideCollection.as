package com.gnut.models {
	import com.gnut.utils.XMLLoader;
	import flash.events.Event;
	import com.gnut.Application;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	
	public class SlideCollection extends Sprite {
		private var _xmlLoader:XMLLoader;
		private var _xmlParser:SlideXMLParser;
		private var _slides:Array;

		public function SlideCollection() {
			
		}
		public function getData():void {
			_xmlLoader = new XMLLoader();
			_xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			_xmlLoader.file = Application.XML_PATH;
		}
		private function xmlLoaded(e:Event):void {
			_xmlLoader.removeEventListener(Event.COMPLETE, xmlLoaded);
			
			_xmlParser = new SlideXMLParser();
			_xmlParser.addEventListener(Event.COMPLETE, buildCollection);
			_xmlParser.xml = _xmlLoader.data;
		}
		private function buildCollection(e:Event):void {
			_xmlParser.removeEventListener(Event.COMPLETE, buildCollection);
			_slides = _xmlParser.slides;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		public function get slides():Array {
			return _slides;
		}

	}
	
}
