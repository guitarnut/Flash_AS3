package com.starz.view.screens
{
	import com.starz.view.GameScreen;
	import com.starz.events.GameEvent;
	import com.starz.constants.Achievements;
	import flash.events.Event;
	import com.greensock.TweenLite;

	public class TriviaFail extends GameScreen
	{

		public function TriviaFail():void
		{
		}
		public function animate():void
		{
			this.visible = true;
			content.alpha = 0;
			new TweenLite(content, .25, {alpha: 1});
			analytics("Trivia Failed");
		}
	}

}