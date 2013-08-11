package com.gnut.models {
	
	public class SlideVO {
		
		private var _type:String;
		private var _asset:*;
		private var _videoSettings:Object;
		
		public function SlideVO() {
			
		}
		public function set videosettings($v):void {
			_videoSettings = $v;
		}
		public function get videosettings():Object {
			return _videoSettings;
		}
		public function set type($t):void {
			_type = $t;
		}
		public function get type():String {
			return _type;
		}
		public function set asset($a):void {
			_asset = $a;
		}
		public function get asset():* {
			return _asset;
		}

	}
	
}
