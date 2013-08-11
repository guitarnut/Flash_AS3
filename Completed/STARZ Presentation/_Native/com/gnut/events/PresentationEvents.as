package com.gnut.events {
	import flash.events.Event;
	
	public class PresentationEvents extends Event {
		
		public var PRESENTATION_LOADED:String = 'PRESENTATION_LOADED';
		public var SLIDE_READY:String = 'SLIDE_READY';
		public var ADVANCE:String = 'ADVANCE';
		public var GO_BACK:String = 'GO_BACK';

		public function PresentationEvents($t:String, $b:Boolean, $c:boolean) {
			super($t, $b, $c);
		}

	}
	
}
