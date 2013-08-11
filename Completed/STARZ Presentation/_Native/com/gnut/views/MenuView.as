package com.gnut.views {
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import com.greensock.easing.Quad;
	import flash.sampler.Sample;
	import com.gnut.events.PresentationEvent;
	import flash.events.FullScreenEvent;
	import flash.events.Event;
	
	public class MenuView extends Sprite {
		private static const ANIMATION_SPEED:Number = .5;
		private static const BUTTON_PADDING:Number = 5;
		private var _view:*;
		private var _fsToggle:Boolean = true;

		public function MenuView($v:*) {
			_view = $v;
			init();
		}
		private function init():void {
			_view.icon_left.alpha=0;
			_view.icon_right.alpha=0;
			_view.b_left.buttonMode=true;
			_view.b_right.buttonMode=true;
			_view.b_fullscreen.buttonMode=true;
			_view.b_fullscreen.mouseChildren = false;
						
			addChild(_view);
			addListeners();
		}
		private function addListeners():void {
			addEventListener(Event.ADDED_TO_STAGE, addFullscreenListener);
			
			_view.b_left.addEventListener(MouseEvent.MOUSE_OVER, handleUIMouseOver);
			_view.b_left.addEventListener(MouseEvent.MOUSE_OUT, handleUIMouseOut);
			_view.b_left.addEventListener(MouseEvent.CLICK, handleUIMouseClick);
			
			_view.b_right.addEventListener(MouseEvent.MOUSE_OVER, handleUIMouseOver);
			_view.b_right.addEventListener(MouseEvent.MOUSE_OUT, handleUIMouseOut);
			_view.b_right.addEventListener(MouseEvent.CLICK, handleUIMouseClick);
			
			_view.b_fullscreen.addEventListener(MouseEvent.CLICK, handleUIMouseClick);
		}
		private function addFullscreenListener(e:Event):void {
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, toggleFullscreenIcon);
		}
		private function handleUIMouseOver(e:MouseEvent):void {
			switch (e.target.name) {
				case 'b_left':
					new TweenLite(_view.icon_left, ANIMATION_SPEED, {alpha: .7});
					break;
				case 'b_right':
					new TweenLite(_view.icon_right, ANIMATION_SPEED, {alpha: .7});
					break;
			}
		}
		private function handleUIMouseOut(e:MouseEvent):void {
			switch (e.target.name) {
				case 'b_left':
					new TweenLite(_view.icon_left, ANIMATION_SPEED, {alpha: 0});
					break;
				case 'b_right':
					new TweenLite(_view.icon_right, ANIMATION_SPEED, {alpha: 0});
					break;
			}
		}
		private function handleUIMouseClick(e:MouseEvent):void {
			switch (e.target.name) {
				case 'b_left':
					dispatchEvent(new PresentationEvent(PresentationEvent.GO_BACK, true, true));
					break;
				case 'b_right':
					dispatchEvent(new PresentationEvent(PresentationEvent.ADVANCE, true, true));
					break;
				case 'b_fullscreen':
						dispatchEvent(new PresentationEvent(PresentationEvent.TOGGLE_FULLSCREEN, true, true));
						break;
			}
		}
		private function toggleFullscreenIcon(e:FullScreenEvent):void {
			if(!_fsToggle) {
				_fsToggle = true;
			} else {
				_fsToggle = false;
			}
			_view.b_fullscreen.visible = _fsToggle;
		}
	}
	
}
