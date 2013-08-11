package com.gnut.events {
	import flash.events.Event;
	
	public class PresentationEvent extends Event {
		
		public static const PRESENTATION_LOADED:String = 'PRESENTATION_LOADED';
		public static const SLIDE_READY:String = 'SLIDE_READY';
		public static const SLIDE_COMPLETE:String = 'SLIDE_COMPLETE';
		public static const ADVANCE:String = 'ADVANCE';
		public static const GO_BACK:String = 'GO_BACK';
		public static const GOTO_SLIDE:String = 'GOTO_SLIDE';
		public static const TOGGLE_FULLSCREEN:String = 'TOGGLE_FULLSCREEN';

		public function PresentationEvent($t:String="", $b:Boolean=false, $c:Boolean=false) {
			super($t, $b, $c);
		}

	}
	
}
