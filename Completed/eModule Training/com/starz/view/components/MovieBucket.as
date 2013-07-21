﻿package com.starz.view.components{	import com.starz.view.screens.base.TrainingScreen;	import com.greensock.TweenLite;	import com.greensock.TimelineLite;	import flash.events.Event;	public class MovieBucket extends DragDropTarget	{		private static const TWEEN_SPEED:Number = .25;		private var _droppedObject:DragDropMC;		public function MovieBucket()		{			init();		}		private function init():void		{		}		override public function receiveDrop(o$:DragDropMC):void		{			_droppedObject = o$;			openBucket();		}		private function openBucket():void		{			new TweenLite(leftHinge,TWEEN_SPEED,{x:leftHinge.x - leftHinge.width});			new TweenLite(rightHinge,TWEEN_SPEED,{x:rightHinge.x + rightHinge.width,onComplete:grabObject});		}		private function closeBucket():void		{			new TweenLite(leftHinge,TWEEN_SPEED,{x:leftHinge.x + leftHinge.width});			new TweenLite(rightHinge,TWEEN_SPEED,{x:rightHinge.x - rightHinge.width,onComplete:fireListener});		}		private function grabObject():void		{			TrainingScreen(this.parent).removeChild(_droppedObject);			_droppedObject.x = 0;			_droppedObject.y = 0;			addChildAt(_droppedObject, numChildren-2);			new TweenLite(_droppedObject,TWEEN_SPEED,{scaleX:.7,scaleY:.7,onComplete:closeBucket});		}		override public function giveHint():void		{			var timeline:TimelineLite = new TimelineLite();			timeline.append(new TweenLite(this, .1, {rotation: 5}));			timeline.append(new TweenLite(this, .1, {rotation: -5}));			timeline.append(new TweenLite(this, .1, {rotation: 0}));		}		private function fireListener():void		{			dispatchEvent(new Event(Event.COMPLETE));		}	}}