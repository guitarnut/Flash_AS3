package com.starz.core.media.video.events {
	import flash.events.Event;

	/**
	 * @author rhenley
	 */
	public class VideoControlEvent extends Event {
		public static const PLAY_CLICKED : String = 'PLAY_CLICKED';
		public static const PAUSE_CLICKED : String = 'PAUSE_CLICKED';
		public static const STOP_CLICKED : String = 'STOP_CLICKED';
		public static const VOLUME_CLICKED : String = 'VOLUME_CLICKED';
		public static const SEEKBAR_CLICKED : String = 'SEEKBAR_CLICKED';
		public static const SEEK : String = 'SEEK';
		public static const SEEKBAR_RELEASED : String = 'SEEKBAR_RELEASED';
		public static const FULLSCREEN_CLICKED : String = 'FULLSCREEN_CLICKED';
		public static const NEXT_CLICKED : String = 'NEXT_CLICKED';
		public static const PREVIOUS_CLICKED : String = 'PREVIOUS_CLICKED';
		
		public var data : Object;
		
		public function VideoControlEvent(type : String, data : Object = null, bubbles : Boolean = false, cancelable : Boolean = false) {
			if(data)this.data = data;
			super(type, bubbles, cancelable);
		}
	}
}
