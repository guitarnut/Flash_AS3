package com.gnut.utils {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.IOErrorEvent;
	import com.gnut.Application;
	
	public class XMLLoader extends Sprite {
		private var _filePath:String;
		private var _xml:XML;
		private var _loader:URLLoader;

		public function XMLLoader() {
			init();
		}
		private function init():void {
			_loader = new URLLoader();
		}
		private function addListeners():void {
			_loader.addEventListener(Event.COMPLETE, setData);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, handleError);
		}
		private function removeListeners():void {
			_loader.removeEventListener(Event.COMPLETE, setData);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, handleError);
		}
		private function loadXML():void {
			addListeners();
			
			_loader.load(new URLRequest(_filePath));
		}
		private function setData(e:Event):void {
			removeListeners();
			
			_xml = new XML(e.target.data);
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		private function handleError(e:IOErrorEvent):void {
			trace(e);
		}
		public function set file($f):void {
			_filePath = Application.BASE_PATH+$f;
			loadXML();
		}
		public function get data():XML {
			return _xml;
		}

	}
	
}
