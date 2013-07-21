package com.starz.view.components
{
	import flash.display.MovieClip;
	import com.starz.events.GameEvent;
	import com.starz.constants.Achievements;
	import com.starz.view.GameScreen;

	public class TVWall extends MovieClip
	{

		private static const TOTAL_TVS:Number = 16;
		public var difficulty:Number;
		public var previewPlayed:Boolean = false;
		private var _lockedTVs:Number;
		private var _tvSets:Array;

		public function TVWall()
		{
			init();
		}
		private function init():void
		{
			_tvSets = new Array(tv1,tv2,tv3,tv4,tv5,tv6,tv7,tv8,tv9,tv10,tv11,tv12,tv13,tv14,tv15,tv16);

			for (var i:Number = 0; i< _tvSets.length; i++)
			{
				addListeners(_tvSets[i]);
			}
		}
		public function setDifficulty(timerSpeed:Number) {
			difficulty = timerSpeed;
		}
		public function startRound():void
		{
			previewPlayed = false;
			_lockedTVs = 0;

			for (var i:Number = 0; i< _tvSets.length; i++)
			{
				_tvSets[i].startup();
			}
		}
		public function pauseRound():void
		{
			for (var i:Number = 0; i< _tvSets.length; i++)
			{
				_tvSets[i].pause();
			}
		}
		public function resumeRound():void
		{
			for (var i:Number = 0; i< _tvSets.length; i++)
			{
				_tvSets[i].resume();
			}
		}
		private function addListeners(tv:Television):void
		{
			tv.addEventListener(GameEvent.GOOD_CLICK, lockTV);
			tv.addEventListener(GameEvent.BAD_CLICK, lockTV);
			tv.addEventListener(GameEvent.BAD_CLICK, recordBrokenTV);
			tv.addEventListener(GameEvent.BONUS_CLICK, recordBonus);
			tv.addEventListener(GameEvent.PREVIEW_CLICK, playPreview);
		}
		private function lockTV(e:GameEvent):void
		{
			_lockedTVs++;
			dispatchEvent(new GameEvent(GameEvent.GOOD_CLICK));
			
			if (_lockedTVs == TOTAL_TVS)
			{
				roundComplete();
			}
		}
		private function recordBrokenTV(e:GameEvent):void
		{
			dispatchEvent(new GameEvent(GameEvent.BAD_CLICK));
		}
		private function recordBonus(e:GameEvent):void
		{
			dispatchEvent(new GameEvent(GameEvent.BONUS_CLICK));
		}
		private function playPreview(e:GameEvent):void
		{
			dispatchEvent(new GameEvent(GameEvent.PREVIEW_CLICK));
		}
		private function roundComplete():void
		{
			dispatchEvent(new GameEvent(GameEvent.ROUND_COMPLETE));
		}
	}

}