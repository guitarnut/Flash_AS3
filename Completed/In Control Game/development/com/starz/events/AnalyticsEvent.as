package com.starz.events {
	import flash.events.Event;
	
	public class AnalyticsEvent extends Event {
		
		public static const PAGE_TRACKING:String = 'PAGE_TRACKING';
		public static const EVENT_TRACKING:String = 'EVENT_TRACKING';
		
		public var analyticsData:Object = new Object();

		public function AnalyticsEvent(type:String, theAnalyticsData:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			analyticsData = theAnalyticsData;
			super(type, bubbles, cancelable);
		}

	}
	
}
