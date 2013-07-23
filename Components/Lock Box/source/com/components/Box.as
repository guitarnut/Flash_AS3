package com.components {
	import com.events.LockEvent;
	import com.greensock.TweenLite;
	import com.starz.core.media.audio.AudioPlayer;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author rhenley
	 */
	public class Box extends LockBox {
		
		private var _audio:AudioPlayer;
		
		public function Box() {
			alpha = 0;
			note.visible = false;
			addEventListener(Event.ADDED_TO_STAGE, showMe);
			
			slot.buttonMode = true;
			slot.addEventListener(MouseEvent.CLICK, showComboLock);
			
			_audio = new AudioPlayer();
		}

		private function showComboLock(event : MouseEvent) : void {
			dispatchEvent(new LockEvent(LockEvent.SHOW_LOCK, false, false));
		}
		
		public function openMe():void {
			slot.buttonMode = false;
			slot.removeEventListener(MouseEvent.CLICK, showComboLock);
			
			note.visible = true;
			note.buttonMode = true;
			note.addEventListener(MouseEvent.CLICK, nukeEm);
			
			TweenLite.to(slot, 1.5, {y: 53});
			
			_audio.playLocal(open);
		}

		private function showMe(event : Event) : void {
			TweenLite.to(this, .5, {alpha: 1});
		}

		private function hideMe(event : Event) : void {
			TweenLite.to(this, .5, {alpha: 0});
		}
		
		private function nukeEm(event : MouseEvent) : void {
			
		}
	}
}
