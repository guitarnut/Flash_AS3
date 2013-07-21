package com.starz {
	import com.starz.core.loaders.StarzPreloader;
	import com.starz.core.utils.Debug;

	import flash.display.MovieClip;

	/**
	 * @author rhenley
	 */
	public class ContentLoader extends MovieClip {
		private var _myLoader : StarzPreloader;

		public function ContentLoader() {
			Debug.password = "starz";
			Debug.clear();
			Debug.log("Initialized");
			
			_myLoader = new StarzPreloader();
			_myLoader.x = 960 / 2;
			_myLoader.y = 700 / 2;
			addChild(_myLoader);
			
			_myLoader.loadContent("http://www.starz.com/features/pillars/exploreconnections/FamilyTree.swf");
		}
	}
}
