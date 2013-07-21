package com.starz.view.components
{

	import flash.display.MovieClip;
	import com.greensock.TweenLite;
	import com.starz.constants.ApplicationSettings;
	import com.greensock.easing.Linear;

	public class TitleAnimation extends MovieClip
	{

		private static const STARTING_Y:Number = 400;
		private static const TWEEN_SPEED:Number = 20;
		private static const DELAY:Number = 20;
		private var animationCount:Number;
		public var pauseAnimation:Boolean = false;

		public function TitleAnimation()
		{
			init();
		}
		private function init():void
		{
			startAnimationSequence();
		}
		public function startAnimationSequence():void
		{
			pauseAnimation = false;
			animationCount = 0;
			for (var i:Number = 0; i< this.numChildren; i++)
			{
				var image:MovieClip = MovieClip(this.getChildAt(i));
				image.alpha = .3;
				animateImage(image);
			}
		}
		public function stopAnimationSequence():void {
			pauseAnimation = true;
		}
		private function animateImage(image:MovieClip):void
		{
			image.y = STARTING_Y;
			image.x = Math.round(Math.random() * ApplicationSettings.STAGE_WIDTH);
			var ending_y:Number =  -  image.height;
			new TweenLite(image,Math.round(Math.random() * TWEEN_SPEED) + 5,{ease:Linear.easeNone,y:ending_y,onComplete:repeatAnimation,onCompleteParams:new Array(image),delay:Math.random() * DELAY});
		}
		private function repeatAnimation(image:MovieClip):void
		{
			if (! pauseAnimation)
			{
				animateImage(image);
			}
		}
	}
}