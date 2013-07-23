package com.screens{

	import flash.display.MovieClip;
	import flash.events.*;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.utils.Timer;

	public class triviaScreen extends MovieClip {

		private var delayBetweenQuestions:Number = 3;
		private var questionCounter:Number;
		private var questionAnswered:Boolean = false;
		private var myTimer:Timer;
		private var correctAnswerText:Array = new Array();
		private var triviaTween:Tween;
		private var totalQuestions:Number = 3;

		public function triviaScreen():void {
			/* These are the responses to the questions when you answer correctly */
			correctAnswerText.push("Perfect!");
			correctAnswerText.push("Way to go!");
			correctAnswerText.push("Your quick wits may save you yet!");
			correctAnswerText.push("Looks like you have brains to match your brawn!");
			correctAnswerText.push("Keep it up!");
			correctAnswerText.push("Your skills extend far beyond the walls of the arena!");
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(event:Event):void {
			triviaTween = new Tween(this, "alpha", None.easeNone, 0, 1, 1, true);
			questionCounter=1;
			questionCount.text = "Question " + questionCounter + " of 3";
			playMusic();
		}
		/* ------------------------------------------------------------------------- Trivia Functionality ------------------------------------------------------------ */
		public function makeButton(buttonName):void {
			buttonName.alpha=1;
			buttonName.buttonMode = true;
			buttonName.addEventListener(MouseEvent.MOUSE_DOWN, checkAnswer);
		}
		public function checkAnswer(event:MouseEvent):void {
			if (questionAnswered==false) {
				if (event.target.name=="correct") {
					questionAnswered=true;
					correctAnswer();
				} else {
					event.target.removeEventListener(MouseEvent.MOUSE_DOWN, checkAnswer);
					wrongAnswer(event.target);
				}
			}
		}
		private function correctAnswer():void {
			feedback.text=correctAnswerText[this.currentFrame-1];
			myTimer=new Timer(delayBetweenQuestions*1000,1);
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, nextQuestion);
			myTimer.start();
		}
		private function nextQuestion(event:TimerEvent):void {
			myTimer.stop();
			myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, nextQuestion);
			feedback.text = "";
			questionCounter++;
			questionAnswered = false;
			if (questionCounter<4) {
				this.nextFrame();
				questionCount.text = "Question " + questionCounter + " of " + totalQuestions;
			} else {
				/* Change the background to the next setting */
				MovieClip(this.parent.parent).battleBackground.x-=800;
				triviaTween.yoyo();
				triviaTween.addEventListener(TweenEvent.MOTION_FINISH, returnToBattle);
			}
		}
		private function wrongAnswer(buttonName):void {
			feedback.text="Incorrect.";
			buttonName.alpha=.3;
		}
		private function returnToBattle(event:TweenEvent):void {
			triviaTween.removeEventListener(TweenEvent.MOTION_FINISH, returnToBattle);
			if (this.currentFrame != 6) {
					this.nextFrame();
				}
			MovieClip(this.parent.parent).triviaComplete();
			
		}
		/* ------------------------------------------------------------------------- Audio ------------------------------------------------------------ */
		private function playMusic():void {
			MovieClip(this.parent.parent.parent.parent).playMusic("Trivia");
		}
	}
}