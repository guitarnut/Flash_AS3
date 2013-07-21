﻿package com.starz.view.screens{	import com.starz.view.GameScreen;	import com.starz.events.GameEvent;	import flash.events.Event;	import com.greensock.TweenLite;	import flash.events.MouseEvent;	import com.starz.events.AnalyticsEvent;	import com.starz.constants.Achievements;	public class InstructionsScreen extends GameScreen	{		private static const X_OFFSET:Number = 1000;		private var _buttonTween2:TweenLite;		//private var _buttonTween3:TweenLite;		private var _titleTween:TweenLite;		private var _textTween1:TweenLite;		private var _textTween2:TweenLite;		private var _bgTween:TweenLite;		public function InstructionsScreen():void		{			init();		}		private function init():void		{			reset();			moveStageObjects();			text1.nextButton.addEventListener(MouseEvent.CLICK, advanceInstructions);			playGame.addEventListener(MouseEvent.CLICK, videoScreen);			//back.addEventListener(MouseEvent.CLICK, titleScreen);		}		private function moveStageObjects():void		{			playGame.x = playGame.x - X_OFFSET;			//back.x = back.x - X_OFFSET;			title.x = title.x - X_OFFSET;			text1.x = text1.x - X_OFFSET;			textBG.x = textBG.x - X_OFFSET;		}		public function animate():void		{			analytics("Instructions Read");			_buttonTween2 = new TweenLite(playGame,.5,{alpha:1,x:playGame.x + X_OFFSET});			//_buttonTween3 = new TweenLite(back,.5,{alpha:1,x:back.x + X_OFFSET});			_titleTween = new TweenLite(title,.5,{alpha:1,x:title.x + X_OFFSET});			_textTween1 = new TweenLite(text1,.5,{alpha:1,x:text1.x + X_OFFSET});			_bgTween = new TweenLite(textBG,.5,{alpha:1,x:textBG.x + X_OFFSET});		}		private function checkTime():void		{			var date:Date = new Date();			if ((date.hours>=11)&&(date.hours<=13))			{				//achievement(Achievements.LUNCH_BREAK);			}		}		private function advanceInstructions(e:MouseEvent):void		{			new TweenLite(text1, .25, {alpha: 0});			new TweenLite(text2, .25, {alpha: 1});//			if (text1.alpha == 1)//			{//				new TweenLite(text1, .25, {alpha: 0});//				new TweenLite(text2, .25, {alpha: 1});//			}//			if (text2.alpha == 1)//			{//				new TweenLite(text1, .25, {alpha: 1});//				new TweenLite(text2, .25, {alpha: 0});//			}		}		private function titleScreen(e:MouseEvent):void		{			dispatchEvent(new GameEvent(GameEvent.SHOW_TITLE));		}		private function videoScreen(e:MouseEvent):void		{			dispatchEvent(new GameEvent(GameEvent.SHOW_VIDEO));		}		public function hide():void		{			_buttonTween2.reverse();			//_buttonTween3.reverse();			_titleTween.reverse();			_textTween1.reverse();			_bgTween.reverse();			hideMe();		}		override public function hideMe():void		{			new TweenLite(this,TWEEN_SPEED,{alpha:0,onComplete:destroy});		}	}}