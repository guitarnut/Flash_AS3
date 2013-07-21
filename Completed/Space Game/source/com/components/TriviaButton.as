package com.components {
	import com.events.SpaceEvent;

	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author rhenley
	 */
	public class TriviaButton extends MovieClip {
		private var _incorrectIcon : DisplayObjectContainer;
		private var _correctIcon : DisplayObjectContainer;
		private var _correctAnswer : Boolean = false;
		private var _timer : Timer;

		public function TriviaButton() {
			this.buttonMode = true;
			this.mouseChildren = false;
			this.alpha = .8;
			
			addEventListener(MouseEvent.MOUSE_DOWN, checkAnswer);
			addEventListener(MouseEvent.MOUSE_OVER, highlight);
			addEventListener(MouseEvent.MOUSE_OUT, unHighlight);
			
			this.parent.addEventListener(Event.REMOVED_FROM_STAGE, resetMe);
			
			_incorrectIcon = MovieClip(this.getChildAt(this.numChildren - 2));
			_incorrectIcon.visible = false;
			
			_correctIcon = MovieClip(this.getChildAt(this.numChildren - 1));
			_correctIcon.visible = false;
		}

		private function checkAnswer(event : MouseEvent) : void {
			if(this.name != 'correct') {
				if((!_incorrectIcon.visible) && (!_correctAnswer))dispatchEvent(new SpaceEvent(SpaceEvent.WRONG_ANSWER, true, true));
				_incorrectIcon.visible = true;
			}
			if(this.name != 'correct') {
				_incorrectIcon.visible = true;
			}
			if(this.name == 'correct') {
				if(!_correctAnswer)screenDelay();
				_correctAnswer = true;
				_correctIcon.visible = true;
			}
		}

		private function screenDelay() : void {
			_timer = new Timer(1000, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, sendEvent);
			_timer.start();
		}

		private function sendEvent(event : TimerEvent) : void {
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, sendEvent);
			
			if(GameScreen(this.parent).currentFrame == 2)GameScreen(this.parent).startDelay(1);
			if(GameScreen(this.parent).currentFrame == 1)GameScreen(this.parent).nextFrame();

			dispatchEvent(new SpaceEvent(SpaceEvent.RIGHT_ANSWER, true, true));
		}

		private function highlight(event : MouseEvent) : void {
			this.alpha = 1;		
		}

		private function unHighlight(event : MouseEvent) : void {
			this.alpha = .8;		
		}

		private function resetMe(event : Event) : void {
			_incorrectIcon.visible = false;
			_correctAnswer = false;
			_correctIcon.visible = false;
		}
	}
}
