package com.gnut.views {
	import flash.display.Sprite;
	import com.gnut.events.PresentationEvent;
	
	public class PresentationView extends Sprite {
		private var _slides:Array;
		private var _slideTotal:Number;

		public function PresentationView() {
			
		}
		private function buildView():void {
			_slideTotal = _slides.length;
			
			for each(var slide:SlideView in _slides) {				
				if(slide.ready) {
					addSlide(slide);
				} else {
					slide.addEventListener(PresentationEvent.SLIDE_READY, slideReady);
				}
			}
		}
		private function slideReady(e:PresentationEvent):void {
			if(e) {
				e.target.removeEventListener(PresentationEvent.SLIDE_READY, slideReady);
			}
			
			addSlide(SlideView(e.target));
		}
		private function addSlide($s:SlideView):void {
			addChild($s);
			$s.show();
			_slideTotal--;
		}
		public function set data($s:Array):void {
			_slides = $s;
			buildView();
		}

	}
	
}
