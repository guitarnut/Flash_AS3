package com.starz.view.components
{
	import flash.display.MovieClip;

	public class FinalImage extends MovieClip
	{
		public function FinalImage()
		{
			stop();
			init();
		}
		private function init():void
		{
			var image:Number = Math.round(Math.random() * this.totalFrames);
			gotoAndStop(image);
		}
	}
}