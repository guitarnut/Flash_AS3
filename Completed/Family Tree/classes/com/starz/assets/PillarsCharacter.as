package com.starz.assets {
	import com.greensock.OverwriteManager;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.starz.FamilyTree;
	import com.starz.constants.ClassType;
	import com.starz.constants.Layout;
	import com.starz.core.utils.Debug;
	import com.starz.core.utils.GetClass;
	import com.starz.events.PillarsEvent;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author rhenley
	 */
	public class PillarsCharacter extends MovieClip {
		private static const TWEEN_SPEED_1 : Number = 1;
		private static const TWEEN_SPEED_2 : Number = 3;
		private static const TWEEN_SPEED_3 : Number = .25;
		private static const TWEEN_SPEED_4 : Number = .5;

		private static const DIMMED : Number = .3;

		private static const TOP_ROW_Y : Number = 120;
		private static const BOTTOM_ROW_Y : Number = Layout.STAGE_HEIGHT - 160;

		private static const GLOW_PEASANT : uint = 0xAF6906;
		private static const GLOW_NOBILITY : uint = 0x3A56BD;
		private static const GLOW_CLERGY : uint = 0x870808;
		private static const GLOW_ROYALS : uint = 0x480F7E;

		public var startingX : Number;
		public var startingY : Number;
		public var startingRotation : Number;
		public var linkage : Array = new Array();
		public var linkText : Array = new Array();
		public var linkedX : Number;
		public var linkedY : Number;
		public var groupedX : Number;
		public var groupedY : Number;
		public var characterName : String;
		public var classType : String;
		public var isFlipped : Boolean = false;
		public var isLinked : Boolean = false;
		public var isCentered : Boolean = false;
		public var isGrouped : Boolean = false;
		public var isDimmed : Boolean = false;
		public var isFloating : Boolean = false;
		private var _hasGlow : Boolean = false;
		public var longText : String = "This is my overview.";
		public var shortText : String = "";
		public var shortLinkText : String = "";

		private var _introTween : TweenLite;
		private var _centerTween : TweenLite;
		private var _connectTween : TweenLite;
		private var _flipTween : TweenLite;
		private var _floatTween : TweenLite;
		private var _zoomTween : TweenLite;
		private var _groupTween : TweenLite;
		private var _shadowTween : TweenMax;
		private var _glowTween : TweenMax;
		private var _dimTween : TweenLite;
		private var _resetTween : TweenLite;
		private var _rotationTween : TweenLite;

		private var _cardAssets : CardAssets;
		private var _parchment : Parchment;

		private var _overlapsCharacter : Boolean;
		private var _savedXScale : Number;
		private var _isFlipping : Boolean = false;
		private var _moveCardWhenComplete : Boolean = false;
		private var _centerCardWhenComplete : Boolean = false;
		private var _resetCardWhenComplete : Boolean = false;
		private var _myX : Number;
		private var _myY : Number;

		public function PillarsCharacter() {			
			this.buttonMode = true;
			this.mouseChildren = true;
			this.scaleX = Layout.CARD_SCALE;
			this.scaleY = Layout.CARD_SCALE;
			addAssets();
			
			OverwriteManager.init(OverwriteManager.AUTO); 
			
			addEventListener(MouseEvent.MOUSE_DOWN, handleMouseClick);
			addEventListener(PillarsEvent.INFO_CLICKED, infoClicked);
			addEventListener(PillarsEvent.FLIP_CLICKED, flipClicked);
		}

		/* ----- Character Setup ------------------------------------------------------------------------------------------------------- */
		private function addAssets() : void {
			_cardAssets = new CardAssets();
			addChild(_cardAssets);
			
			_parchment = new Parchment();
			_parchment.visible = false;
			_parchment.scaleY = 1.1;
			addChildAt(_parchment, 1);
		}

		public function positionMe(event : Event = null) : void {
			_overlapsCharacter = false;
			
			this.x = Layout.STAGE_WIDTH / 2;
			this.y = Layout.STAGE_HEIGHT + this.height;
			
			FamilyTree(this.parent.parent).positionCharacters(this);
						
			_introTween = new TweenLite(this, TWEEN_SPEED_1, {x: startingX, y: startingY});
			
			/* Non-linked and non-grouped characters must reset when another character or group is clicked */
			FamilyTree(this.parent.parent).addEventListener(PillarsEvent.FLIP_CARDS_BACK, flipInactiveCardBack);
		}

		private function handleMouseClick(event : MouseEvent) : void {
			if((GetClass(event.target) != infoButton) && (GetClass(event.target) != flipButton)) {
				dispatchEvent(new PillarsEvent(PillarsEvent.CHARACTER_CLICKED, true, false));
			}
		}

		/* ----- User Interaction ------------------------------------------------------------------------------------------------------- */
		private function infoClicked(event : PillarsEvent) : void {
			if(!isDimmed) {
				_cardAssets.but_info.hideMe();
				flipMeOver();
			}
		}

		private function flipClicked(event : PillarsEvent) : void {
			_cardAssets.but_flip.hideMe();
			flipMeBack();
		}

		private function disableClicks() : void {
			FamilyTree(this.parent.parent).disableClicks();
		}

		private function enableClicks() : void {
			FamilyTree(this.parent.parent).disableClicks(false);
		}

		/* ----- Grouping Actions ------------------------------------------------------------------------------------------------------- */
		public function groupMe() : void {
			isGrouped = true;
			disableClicks();
			if(isFlipped)flipMeBack();
			_groupTween = new TweenLite(this, TWEEN_SPEED_4, {x: groupedX, y: groupedY, rotation: 0, onComplete: groupingComplete});
		}

		private function groupingComplete() : void {
			highlightMe();
		}

		private function playConnectTween() : void {
			_moveCardWhenComplete = false;
			disableClicks();
			_connectTween = new TweenLite(this, TWEEN_SPEED_1, {x: _myX, y: _myY, rotation: 0, onComplete: zoomIn});
		}

		public function connectMe(slot : Number, totalConnections : Number) : void {
			isLinked = true;
			var fiveUp : Boolean = false;
			var spacing : Number;
			var position : Number = slot + 1;
			
			spacing = totalConnections + 1;

			if((totalConnections == 5) && (position < 4)) {
				spacing = 4
				fiveUp = true;
			}
			
			if((totalConnections == 5) && (position >= 4)) {
				spacing = 4
				if(position == 4)position = 1;
				if(position == 5)position = 3;
				fiveUp = true;
			}
									
			_myX = (Layout.STAGE_WIDTH / spacing) * position;
			
			if((slot < 4) && (!fiveUp))_myY = TOP_ROW_Y;
			if((slot < 3) && (fiveUp))_myY = TOP_ROW_Y;
			
			if((slot >= 3) && (fiveUp))_myY = BOTTOM_ROW_Y;
			
			linkedX = _myX;
			linkedY = _myY;
			
			if(!isFlipped)playConnectTween();
			if(isFlipped) {
				_moveCardWhenComplete = true;
				flipMeBack();
			}
		}

		/* ----- Centering Actions ------------------------------------------------------------------------------------------------------- */
		public function centerMe() : void {
			disableClicks();
			_myX = Layout.STAGE_WIDTH / 2;
			_myY = Layout.STAGE_HEIGHT / 2 + 45;
			if(!isFlipped)playCenterTween();
			if(isFlipped) {
				_centerCardWhenComplete = true;
				flipMeBack();
			}
		}

		private function playCenterTween() : void {
			_centerCardWhenComplete = false;
			_centerTween = new TweenLite(this, TWEEN_SPEED_1, {x: _myX, y: _myY, rotation: 0, onComplete: characterCentered});
		}

		private function characterCentered() : void {
			zoomIn();
			dispatchEvent(new PillarsEvent(PillarsEvent.CHARACTER_CENTERED, false, false));
		}

		/* ----- Misc Animations and FX ------------------------------------------------------------------------------------------------------- */
		private function zoomIn() : void {
			enableClicks()
			if(_hasGlow)_glowTween.reverse();
			if(isCentered) {
				_cardAssets.linkText.theText.text = shortText;
				_zoomTween = new TweenLite(this, TWEEN_SPEED_3, {scaleX: Layout.CARD_SCALE + Layout.CENTER_CARD_ZOOM, scaleY: Layout.CARD_SCALE + Layout.CENTER_CARD_ZOOM, onComplete: floatFX});
				_shadowTween = new TweenMax(this, TWEEN_SPEED_3, {dropShadowFilter:{color:0x000000, alpha:.5, blurX:5, blurY:5, distance:8}});
			}
			if(isLinked) {
				_cardAssets.linkText.theText.text = shortLinkText;
				_zoomTween = new TweenLite(this, TWEEN_SPEED_3, {scaleX: Layout.CARD_SCALE + Layout.LINKED_CARD_ZOOM, scaleY: Layout.CARD_SCALE + Layout.LINKED_CARD_ZOOM, onComplete: floatFX});
				_shadowTween = new TweenMax(this, TWEEN_SPEED_3, {dropShadowFilter:{color:0x000000, alpha:.5, blurX:3, blurY:3, distance:5}});
			}
			_cardAssets.linkText.showMe();
		}

		public function dimMe() : void {
			isDimmed = true;
			_dimTween = new TweenLite(this, TWEEN_SPEED_1, {alpha: DIMMED});
		}

		public function resetDim() : void {
			isDimmed = false;
			_dimTween = new TweenLite(this, TWEEN_SPEED_1, {alpha: 1});
		}

		public function highlightMe() : void {
			_hasGlow = true;
			var glowColor : uint;
			if(classType == ClassType.CLASS_PEASANT)glowColor = GLOW_PEASANT;
			if(classType == ClassType.CLASS_NOBILITY)glowColor = GLOW_NOBILITY;
			if(classType == ClassType.CLASS_CLERGY)glowColor = GLOW_CLERGY;
			if(classType == ClassType.CLASS_ROYALS)glowColor = GLOW_ROYALS;
			_glowTween = new TweenMax(this, TWEEN_SPEED_3, {glowFilter:{color:glowColor, alpha:.9, blurX:15, blurY:15, distance:15, strength:3}, onComplete: enableClicks, onReverseStart: glowReset});
		}

		private function glowReset() : void {
			_hasGlow = false;
		}

		private function floatFX(floatUp : Boolean = true, firstRun : Boolean = true) : void {
			isFloating = true;
			if(firstRun)_floatTween = new TweenLite(this, TWEEN_SPEED_2, {scaleX: this.scaleX + .05, scaleY:this.scaleY + .05, onComplete: floatFX, onCompleteParams:[false, false], onReverseComplete: floatFX, onReverseCompleteParams:[true, false]});
			if((isLinked) || (isCentered)) {
				if(!_isFlipping) {
					if(floatUp) {
						_floatTween.play();
					}
					if(!floatUp) {
						_floatTween.reverse();
					}
				}
			}
		}

		/* ----- Character Flipping ------------------------------------------------------------------------------------------------------- */
		private function flipMeOver() : void {
			if((isLinked) || (isCentered))_floatTween.pause();
			isFlipped = true;
			_isFlipping = true;
			_savedXScale = this.scaleX;
			_flipTween = new TweenLite(this, TWEEN_SPEED_3, {scaleX: 0, onComplete: showBack});
		}

		private function flipMeBack() : void {
			isFlipped = false;
			_isFlipping = true;
			_savedXScale = this.scaleX;
			_flipTween = new TweenLite(this, TWEEN_SPEED_3, {scaleX: 0, onComplete: showFront});
		}

		private function flipInactiveCardBack(event : PillarsEvent = null) : void {
			if((isFlipped) && (!isGrouped) && (!isLinked) && (!isCentered)) {
				Debug.log('Flipping ' + this.name);
				isFlipped = false;
				_isFlipping = true;
				_savedXScale = this.scaleX;
				_flipTween = new TweenLite(this, TWEEN_SPEED_3, {scaleX: 0, onComplete: showFront});
			}
		}

		private function showFront() : void {
			_cardAssets.infoText.hideMe();
			_cardAssets.but_flip.hideMe();
			_cardAssets.but_info.showMe();
			_parchment.visible = false;
			if((isLinked) || (isCentered))_cardAssets.linkText.showMe();
			playFlipAnimation();
		}

		private function showBack() : void {
			if(isDimmed)resetDim();
			MovieClip(this.parent).setChildIndex(this, MovieClip(this.parent).numChildren - 1);
			_cardAssets.infoText.theText.text = longText;
			_cardAssets.infoText.showMe();
			_cardAssets.but_flip.showMe();
			_cardAssets.linkText.hideMe();
			_parchment.visible = true;
			playFlipAnimation();
		}

		private function playFlipAnimation() : void {
			if(isLinked)_flipTween = new TweenLite(this, TWEEN_SPEED_3, {scaleX: Layout.CARD_SCALE + Layout.LINKED_CARD_ZOOM, scaleY: Layout.CARD_SCALE + Layout.LINKED_CARD_ZOOM, onComplete: flipComplete});
			if(isCentered)_flipTween = new TweenLite(this, TWEEN_SPEED_3, {scaleX: Layout.CARD_SCALE + Layout.CENTER_CARD_ZOOM, scaleY: Layout.CARD_SCALE + Layout.CENTER_CARD_ZOOM, onComplete: flipComplete});
			if((!isCentered) && (!isLinked))_flipTween = new TweenLite(this, TWEEN_SPEED_3, {scaleX: Layout.CARD_SCALE, scaleY: Layout.CARD_SCALE, onComplete: flipComplete});
		}

		private function flipComplete() : void {
			_isFlipping = false;
			if(_moveCardWhenComplete)playConnectTween();
			if(_centerCardWhenComplete)playCenterTween();
			if(_resetCardWhenComplete)resetMe();
			if((isLinked) || (isCentered))floatFX();
		}		

		/* ----- Character Resets ------------------------------------------------------------------------------------------------------- */
		public function resetMe() : void {
			if(!isFlipped) {
				if((isGrouped && !isCentered) && (isGrouped && !isLinked)) {
					_groupTween.reverse();
					if(_hasGlow)_glowTween.reverse();
					isGrouped = false;
				}
				if((isGrouped && isCentered) && (isGrouped && isLinked)) {
					_glowTween.reverse();
				}
				if(isCentered) {
					isCentered = false;
					resetPosition();
					_shadowTween.reverse();
					_cardAssets.linkText.hideMe();
					resetScale();
				}
				if(isLinked) {
					isLinked = false;
					resetPosition();
					_shadowTween.reverse();
					_cardAssets.linkText.hideMe();
					resetScale();
				}
				if(this.rotation != startingRotation)resetRotation();
				_resetCardWhenComplete = false;
			}
			if(isFlipped) {
				_resetCardWhenComplete = true;
				flipMeBack();
			}
		}

		private function resetPosition() : void {
			_resetTween = new TweenLite(this, TWEEN_SPEED_1, {x: startingX, y: startingY});
		}

		private function resetRotation() : void {
			_rotationTween = new TweenLite(this, TWEEN_SPEED_3, {rotation: startingRotation});
		}

		private function resetScale() : void {
			_resetCardWhenComplete = false;
			_zoomTween = new TweenLite(this, TWEEN_SPEED_3, {scaleX: Layout.CARD_SCALE, scaleY: Layout.CARD_SCALE});
		}
	}
}
