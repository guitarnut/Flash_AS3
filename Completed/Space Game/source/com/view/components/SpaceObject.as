package com.view.components {
	import com.events.SpaceEvent;
	import com.greensock.TweenLite;
	import com.starz.core.games.objects.Sprite3D;
	import com.view.SpaceScene;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author rhenley
	 */
	public class SpaceObject extends Sprite3D {
		private static const ROTATION_SPEED : Number = 5;

		public var moviePath : String = "none";

		public var isMovie : Boolean = false;
		public var isGood : Boolean = false;
		public var isOriginal : Boolean = false;
		public var isBenefit : Boolean = false;
		public var isBad : Boolean = false;
		public var isBonus : Boolean = false;

		public var objectName : String;
		private var _clickedTween : TweenLite;
		private var _clickable : Boolean = true;

		
		public function SpaceObject(texture : DisplayObjectContainer, type : String) : void {
			if(type == "bonus")rotateMe = false;
			
			addTexture(texture);
			addEventListener(Event.ADDED_TO_STAGE, setSpaceObjectScale);
			addEventListener(MouseEvent.MOUSE_DOWN, objectClicked);
			this.mouseChildren = false;
			this.buttonMode = false;
			determineType(type);
			super();
		}

		public function setZDepth(zDepth : Number) : void {
			super.zDepth = zDepth;
		}

		public function setRange(range : Number) : void {
			super.range = range;
		}

		private function setSpaceObjectScale(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, setSpaceObjectScale);
			super.setScale();
		}

		private function determineType(type : String) : void {
			if(type == "movie")isMovie = true;
			if(type == "original")isOriginal = true;
			if(type == "benefit")isBenefit = true;
			if(type == "good")isGood = true;
			if(type == "bad")isBad = true;
			if(type == "bonus")isBonus = true;
		}

		private function objectClicked(event : MouseEvent) : void {
			if(_clickable) {
				if(!isBad)SpaceScene(this.parent).collectedObjects.push(this);
				
				_clickable = false;
				dontAnimate = true;
			
				if(isGood)dispatchEvent(new SpaceEvent(SpaceEvent.GOOD_ITEM_CLICKED));
				if(isBad)dispatchEvent(new SpaceEvent(SpaceEvent.BAD_ITEM_CLICKED));
				if(isBonus)dispatchEvent(new SpaceEvent(SpaceEvent.BONUS_ITEM_CLICKED));
				if(isMovie)dispatchEvent(new SpaceEvent(SpaceEvent.MOVIE_ITEM_CLICKED));
				if(isOriginal)dispatchEvent(new SpaceEvent(SpaceEvent.ORIGINALS_ITEM_CLICKED));
				if(isBenefit)dispatchEvent(new SpaceEvent(SpaceEvent.BENEFIT_ITEM_CLICKED));
			
				if(moviePath != "none") {
					var movieData : Object = new Object();
					movieData.moviePath = moviePath;
				}
			
				hide();
			}
		}

		private function hide() : void {
			_clickedTween = new TweenLite(this, .75, {alpha : 0, rotation: 180, scaleX: 0, onComplete: destroy});
		}

		private function destroy() : void {
			this.visible = false;
			dispatchEvent(new SpaceEvent(SpaceEvent.REMOVE_ITEM, true, true));
		}
		
		public function killTweens():void {
			TweenLite.killTweensOf(this);
		}

		public function resetMe() : void {
			this.x = 0;
			this.y = 0;
			this.visible = true;
			this.alpha = 1;
			this.rotation = 0;
			this.scaleX = .4;
			this.scaleY = .4;
		}
	}
}
