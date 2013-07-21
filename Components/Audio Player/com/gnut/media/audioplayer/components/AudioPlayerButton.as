﻿package com.gnut.media.audioplayer.components{	import flash.display.MovieClip;	import flash.events.MouseEvent;	import com.gnut.media.audioplayer.events.AudioPlayerEvent;	import com.greensock.TweenLite;	public class AudioPlayerButton extends MovieClip	{		protected var _v:MovieClip;		protected var _active:Boolean;		protected var _startingAlpha:Number = .7;		public function AudioPlayerButton($mc:MovieClip)		{			_v = $mc;			init();		}		private function init():void		{			_v.alpha = _startingAlpha;			_v.mouseChildren = false;			_v.buttonMode = true;			_active = true;			addListeners();		}		private function addListeners():void		{			_v.addEventListener(MouseEvent.CLICK, handleClick);			_v.addEventListener(MouseEvent.MOUSE_OVER, mouseFX);			_v.addEventListener(MouseEvent.MOUSE_OUT, mouseFX);		}		private function removeListeners():void		{			_v.removeEventListener(MouseEvent.CLICK, handleClick);		}		private function mouseFX(e:MouseEvent):void		{			switch (e.type)			{				case MouseEvent.MOUSE_OVER :					MouseOverFX();					break;				case MouseEvent.MOUSE_OUT :					MouseOutFX();					break;			}		}		private function MouseOverFX():void		{			new TweenLite(_v, .5, {alpha: 1});		}		private function MouseOutFX():void		{			new TweenLite(_v, .5, {alpha: _startingAlpha});		}		private function handleClick(e:MouseEvent):void		{			_v.dispatchEvent(new AudioPlayerEvent(AudioPlayerEvent.BUTTON_CLICKED, true, false));		}		private function updateButtonState():void		{			buttonMode = _active;			if (_active)			{				addListeners();			}			else			{				removeListeners();			}		}		public function set toggle($b:Boolean):void		{			_active = $b;			updateButtonState();		}	}}