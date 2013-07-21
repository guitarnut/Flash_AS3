﻿package com.starz.view.screens{	import com.starz.view.GameScreen;	import com.greensock.TweenLite;	import flash.events.MouseEvent;	import com.starz.events.GameEvent;	import com.starz.constants.ApplicationSettings;	public class IntroScreenContainer extends GameScreen	{		private var _currentScreen:*;		private var _titleScreen:TitleScreen;		private var _instructionsScreen:InstructionsScreen;		private var _videoScreen:VideoScreen;		private var _animationTween:TweenLite;		private var _bubbleTween:TweenLite;		private var _bubbleTween2:TweenLite;		public function IntroScreenContainer()		{			init();		}		private function init():void		{			for (var i:Number = 0; i< this.numChildren; i++)			{				getChildAt(i).alpha = 0;			}		}		public function animate():void {			playMusic(new IntroMusic(), true);			_bubbleTween = new TweenLite(bubblesBG, .5, {alpha: 1});			_animationTween = new TweenLite(titleAnimation, .5, {alpha: 1});			titleAnimation.startAnimationSequence();		}		public function setScreens(titleScreen:TitleScreen, instructionsScreen:InstructionsScreen, videoScreen:VideoScreen):void {			_titleScreen = titleScreen;			_instructionsScreen = instructionsScreen;			_videoScreen = videoScreen;		}		public function showTitle():void {			showScreen(_titleScreen);			_titleScreen.animate();			if(bubblesBG.alpha==1)bounceFooter();		}		public function showInstructions():void {			showScreen(_instructionsScreen);			_instructionsScreen.animate();			bounceFooter();		}		public function showVideo():void {			if (_music)			{				_music.fadeOut();			}			showScreen(_videoScreen);			_videoScreen.animate();			_videoScreen.playVideo();			bounceFooter();		}		public function playGame():void {					}		private function bounceFooter(b$:Boolean = false):void {			if(!b$) {				_bubbleTween2 = new TweenLite(bubblesBG, .25, {y: bubblesBG.y + 100, onComplete: bounceFooter, onCompleteParams: [true]});			}			if(b$) {				_bubbleTween2 = new TweenLite(bubblesBG, .25, {y: bubblesBG.y - 100});			}		}		private function showScreen(screen:*):void		{			if (_currentScreen)			{				_currentScreen.hide();			}			screen.showMe();			_currentScreen = screen;		}		override public function destroy():void		{			titleAnimation.stopAnimationSequence();			visible = false;			reset();		}	}}