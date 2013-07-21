package com.starz.view.components
{
	import com.starz.view.behaviors.RotateToMouse;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;

	public class RemoteControl extends RotateToMouse
	{

		private var _lightTween:TweenLite;

		public function RemoteControl()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void {
			lightBeam.alpha = 0;
			mouseEnabled = false;
			addEventListener(Event.ENTER_FRAME, adjustYPosition);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, showLightBeam);
		}
		private function adjustYPosition(e:Event):void
		{
			this.y = stage.mouseY + this.height;
		}
		private function showLightBeam(e:MouseEvent = null):void
		{
			if (e)
			{
				_lightTween = new TweenLite(lightBeam,.25,{alpha:1,onComplete:showLightBeam});
			}
			if (! e)
			{
				_lightTween = new TweenLite(lightBeam,.25,{alpha:0});
			}
		}

	}

}