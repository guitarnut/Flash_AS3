package com.gnut.controllers {
	import com.gnut.Application;
	import com.gnut.models.SlideCollection;
	import flash.events.Event;
	import com.gnut.models.SlideVO;
	import com.gnut.views.SlideView;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import com.gnut.views.PresentationView;
	
	public class PresentationController extends Sprite {
		private var _slides:SlideCollection;
		private var _slideViews:Array;
		private var _view:PresentationView;

		public function PresentationController($v:PresentationView) {
			_view = $v;
			init();
		}
		private function init():void {
			_slideViews = new Array();
			_slides = new SlideCollection();
			_slides.addEventListener(Event.COMPLETE, buildSlides);
			_slides.getData();
		}
		private function buildSlides(e:Event):void {
			_slides.removeEventListener(Event.COMPLETE, buildSlides);
			
			for each(var slideData:SlideVO in _slides.slides) {
				var $t = slideData.type;
				var $a = slideData.asset;
				var $v = slideData.videosettings;
				var slide = new SlideView($t, $a, $v);
				
				_slideViews.push(slide);
			}
			
			_view.data = _slideViews;
		}
	}
}
