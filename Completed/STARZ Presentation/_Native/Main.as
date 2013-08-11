package  {
	import com.gnut.controllers.PresentationController;
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.gnut.views.PresentationView;
	
	public class Main extends MovieClip {
		private var _c_Presentation:PresentationController;
		private var _v_Presentation:PresentationView;

		public function Main() {
			init();
		}
		private function init():void {
			_v_Presentation = new PresentationView();
			_c_Presentation = new PresentationController(_v_Presentation);
			addChild(_v_Presentation);
		}

	}
	
}
