package com.starz.view
{
	import com.starz.view.components.GameScreen;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import com.starz.events.GameEvent;

	public class TitleScreen extends GameScreen
	{

		private var _gawainTween:TweenLite;
		private var _titleTween:TweenLite;
		private var _subtitleTween:TweenLite;
		private var _starzTween:TweenLite;
		private var _bgTween:TweenLite;
		private var _startTween:TweenLite;
		private var _buttonTween:TweenLite;
		private var _buttonTween2:TweenLite;

		public function TitleScreen()
		{
			init();
		}
		private function init():void
		{
			for (var i:Number = 0; i< this.numChildren; i++)
			{
				getChildAt(i).alpha = 0;
			}
			playGame.addEventListener(MouseEvent.CLICK, startGame);
			meetCast.addEventListener(MouseEvent.CLICK, meetTheCast);
		}
		public function firstRun():void
		{
			_gawainTween = new TweenLite(gawain, 3, {delay: 1, alpha: 1});
			_titleTween = new TweenLite(title, 2, {delay: 1, alpha: 1});
			_subtitleTween = new TweenLite(subtitle, 3, {delay: 3, alpha: 1});
			_starzTween = new TweenLite(starzLogo, 4, {alpha: 1});
			_bgTween = new TweenLite(bg,2,{alpha:1});
			_buttonTween = new TweenLite(playGame, 1, {delay: 3, alpha: 1});
			_buttonTween = new TweenLite(meetCast, 1, {delay: 3, alpha: 1});
			
			showTitle();
		}
		public function showTitle():void {
			playMusic(new TitleMusic(), true);
		}
		private function startGame(e:MouseEvent):void {
			playGame.removeEventListener(MouseEvent.CLICK, startGame);
			dispatchEvent(new GameEvent(GameEvent.LEVEL_COMPLETE));
		}
		private function meetTheCast(e:MouseEvent):void {
			dispatchEvent(new GameEvent(GameEvent.CAST_SCREEN));
		}
	}

}