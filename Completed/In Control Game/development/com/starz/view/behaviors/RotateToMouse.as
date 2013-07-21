package com.starz.view.behaviors
{
	import flash.events.Event;
	import flash.display.MovieClip;

	public class RotateToMouse extends MovieClip
	{

		public function RotateToMouse():void
		{
			init();
		}
		private function init():void
		{
			this.addEventListener(Event.ENTER_FRAME, rotateObject);
		}
		private function rotateObject(event:Event):void
		{
			var dx:Number = stage.mouseX - this.x;
			var dy:Number = stage.mouseY - this.y;
			var theAngle:Number = Math.atan2(dy,dx);
			theAngle = theAngle * 180 / Math.PI;
			this.rotation = theAngle;
		}
	}
}