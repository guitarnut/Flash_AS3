package com.gnut.views {
	import flash.display.Sprite;
	import com.gnut.events.PresentationEvent;
	import com.gnut.utils.UIKeyboardCommands;
	import flash.display.StageDisplayState;
	import com.greensock.TweenLite;
	
	public class PresentationView extends Sprite {
		private var _slides:Array;
		private var _slideCount:Number = 0;
		private var _slideTotal:Number;
		private var _menu:MenuView;
		private var _preloader:Preloader;
		private var _currentSlide:SlideView;
		private var _keyboard:UIKeyboardCommands;

		public function PresentationView() {
			
		}
		private function addPreloader():void {
			_preloader = new Preloader();
			_preloader.alpha = 0;
			_preloader.x = stage.stageWidth/2 - (_preloader.width/2);
			_preloader.y = stage.stageHeight/2 - (_preloader.height/2);
			_preloader.t_loading.text = '';
			addChild(_preloader);
			new TweenLite(_preloader, .5, {alpha: 1});
		}
		private function updatePreloader():void {
			_slideCount++;
			_preloader.t_loading.text = 'Loading slide '+_slideCount+' of '+_slideTotal;
			checkStatus();
		}
		private function removePreloader():void {
			new TweenLite(_preloader, .5, {alpha: 0, onComplete:destroyPreloader});
		}
		private function destroyPreloader():void {
			_preloader.visible = false;
		}
		private function buildView():void {
			_slideTotal = _slides.length;
			
			for each(var slide:SlideView in _slides) {				
				if(slide.ready) {
					addSlide(slide);
					updatePreloader();
				} else {
					slide.addEventListener(PresentationEvent.SLIDE_READY, slideReady);
				}
			}
		}
		private function slideReady(e:PresentationEvent):void {
			if(e) {
				e.target.removeEventListener(PresentationEvent.SLIDE_READY, slideReady);
				updatePreloader();
			}
			
			addSlide(SlideView(e.target));
		}
		private function addSlide($s:SlideView):void {
			addChildAt($s,0);
		}
		private function checkStatus():void {
			if(_slideCount==_slideTotal) {
				start();
			}
		}
		private function buildUI() {
			_menu = new MenuView(new Menu());
			_menu.x=0;
			_menu.y=0;
			_menu.addEventListener(PresentationEvent.ADVANCE, nextSlide);
			_menu.addEventListener(PresentationEvent.GO_BACK, previousSlide);
			_menu.addEventListener(PresentationEvent.TOGGLE_FULLSCREEN, toggleFullscreen);
			
			addChild(_menu);
			
			_keyboard = new UIKeyboardCommands(this.stage);
			_keyboard.addEventListener(PresentationEvent.ADVANCE, nextSlide);
			_keyboard.addEventListener(PresentationEvent.GO_BACK, previousSlide);
		}
		private function start():void {
			removePreloader();
			buildUI();
			_slideCount = 0;
			_currentSlide = _slides[_slideCount];
			_currentSlide.show();
		}
		private function previousSlide(e:PresentationEvent):void {
			_slideCount--;
			checkSlideCount();
			transitionSlides();
		}
		private function nextSlide(e:PresentationEvent):void {
			_slideCount++;
			checkSlideCount();
			transitionSlides();
		}
		private function checkSlideCount():void {
			if(_slideCount < 0) {
				_slideCount = _slides.length-1;
			};
			if(_slideCount == _slides.length) {
				_slideCount = 0;
			};
		}
		private function transitionSlides():void {
			_currentSlide.hide();
			_currentSlide = _slides[_slideCount];
			_currentSlide.show();
		}
		private function toggleFullscreen(e:PresentationEvent):void {
			if(stage.displayState == StageDisplayState.FULL_SCREEN) {
				stage.displayState = StageDisplayState.NORMAL;
			} else {
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}
		}
		public function set data($s:Array):void {
			_slides = $s;
			
			addPreloader();
			buildView();
		}

	}
	
}
