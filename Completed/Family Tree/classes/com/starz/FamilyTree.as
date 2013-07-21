package com.starz {
	import com.starz.assets.LightRay;
	import com.starz.assets.PillarsCharacter;
	import com.starz.assets.SocietyMenu;
	import com.starz.assets.TreeInstructions;
	import com.starz.constants.ClassType;
	import com.starz.constants.Layout;
	import com.starz.core.utils.Debug;
	import com.starz.core.utils.RandomNumber;
	import com.starz.events.PillarsEvent;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author rhenley
	 */
	public class FamilyTree extends Sprite {
		private static var GROUPED_CHARACTERS_Y : Number = 220;
		private static var Y_POSITION_VARIATION : Number = 25;
		private static var X_POSITION_VARIATION : Number = 70;
		private static var ROTATION_VARIATION : Number = 15;
		private static var RANDOMIZER : Number = 8;

		public var characterPositions : Array = new Array();

		private var _characters : Characters;
		private var _societyRankings : SocietyMenu;
		private var _clickedCharacter : PillarsCharacter;
		private var _background : BackgroundImage;
		private var _instructions : InstructionsButton;
		private var _home : HomeButton;
		private var _instructionsText : Instructions;

		private var _allCharacters : Array = new Array();
		private var _allCharacters2 : Array = new Array();
		private var _groupedCharacters : Array = new Array();
		private var _positionedCharacters : Array = new Array();
		//private var _inkLines : Array = new Array();
		private var _lightRays : Array = new Array();
		private var _currentGroup : String;

		private var _characterX : Number = 0;
		private var _characterY : Number;
		private var _characterCount : Number = 1

		private var _disableClicks : Boolean = false;

		public function FamilyTree() {
			Debug.password = 'starz';
			Debug.clear();
			Debug.log('Initialized');

			addEventListener(PillarsEvent.CHARACTER_CLICKED, handleCharacterClick);
					
			setupStage();
			storeCharacters();
			randomizeCharacters();
			establishClasses();
			establishRelationships();
			setCharacterText();
		}

		private function storeCharacters() : void {
			_allCharacters.push(_characters.aliena, _characters.maud, _characters.philip, _characters.regan, _characters.richard, _characters.stephen, _characters.tom, _characters.waleran, _characters.william, _characters.bartholomew, _characters.ellen, _characters.jack);
			_allCharacters2.push(_characters.aliena, _characters.maud, _characters.philip, _characters.regan, _characters.richard, _characters.stephen, _characters.tom, _characters.waleran, _characters.william, _characters.bartholomew, _characters.ellen, _characters.jack);
		}

		public function positionCharacters(character : PillarsCharacter) : void {
			_characterX = Layout.STAGE_WIDTH / 4 * _characterCount - character.width;
			
			if(RandomNumber(RANDOMIZER) >= RANDOMIZER / 2) {
				character.startingX = _characterX + -1 * (RandomNumber(X_POSITION_VARIATION));
			} else {
				character.startingX = _characterX + RandomNumber(X_POSITION_VARIATION);
			}
			
			if(character.startingX <= character.width / 2)character.startingX += character.width / 2;
			if(character.startingX >= Layout.STAGE_WIDTH - character.width / 2)character.startingX -= character.width / 2;
			
			if(!_characterY)_characterY = character.height * Layout.CARD_SCALE;
			if(RandomNumber(RANDOMIZER) >= RANDOMIZER / 2) {
				character.startingY = _characterY + -1 * (RandomNumber(Y_POSITION_VARIATION));
			} else {
				character.startingY = _characterY + RandomNumber(Y_POSITION_VARIATION);
			}
			
			/* Make sure the first row isn't placed behind the icons */
			if(character.startingY / 2 <= _societyRankings.height)character.startingY += _societyRankings.height;
			
			character.rotation = RandomNumber(ROTATION_VARIATION);
			if(RandomNumber(RANDOMIZER) >= RANDOMIZER / 2)character.rotation = character.rotation * -1;
			
			character.startingRotation = character.rotation;
			
			_characterCount++;
			_positionedCharacters.push(character);
			
			if (_characterCount > 4) {
				_characterY += Layout.STAGE_HEIGHT / 3.7;
				_characterCount = 1;
			}
		}

		private function setupStage() : void {
			_background = new BackgroundImage();
			//_background.addEventListener(MouseEvent.MOUSE_DOWN, resetAll);
			_background.width = Layout.STAGE_WIDTH;
			_background.height = Layout.STAGE_HEIGHT;
			addChild(_background);
			
			_characters = new Characters();
			_characters.x = 0;
			_characters.y = 0;
			addChild(_characters);
						
			_societyRankings = new SocietyMenu();
			_societyRankings.x = Layout.STAGE_WIDTH / 2;
			_societyRankings.y = 10;
			_societyRankings.addEventListener(MouseEvent.MOUSE_DOWN, createClassGroup);
			addChild(_societyRankings);
			_societyRankings.showMe();
			
			_instructionsText = new TreeInstructions();
			_instructionsText.x = Layout.STAGE_WIDTH / 2;
			_instructionsText.y = Layout.STAGE_HEIGHT / 2;
			addChild(_instructionsText);
			
			_instructions = new InstructionsButton();
			_instructions.x = 10;
			_instructions.y = 10;
			_instructions.buttonMode = true;
			_instructions.mouseChildren = false;
			_instructions.addEventListener(MouseEvent.MOUSE_DOWN, showInstructions);
			addChild(_instructions);
			
			_home = new HomeButton();
			_home.x = Layout.STAGE_WIDTH - _home.width - 10;
			_home.y = 10;
			_home.buttonMode = true;
			_home.mouseChildren = false;
			_home.addEventListener(MouseEvent.MOUSE_DOWN, resetAll);
			addChild(_home);
		}

		private function showInstructions(event : MouseEvent) : void {
			if(_instructionsText.visible == false)_instructionsText.showMe();
		}

		public function randomizeCharacters() : void {
			for (var i : Number = 0;i < _characters.numChildren;i++) {
				try {
					_characters.getChildAt[i].setChildIndex(_characters.getChildAt[i], RandomNumber(_characters.numChildren - 1));
				} catch (e : Error) {
				}
			}
			for (var j : Number = 0;j < _characters.numChildren;j++) {
				var whichCharacter : Number = RandomNumber(_allCharacters2.length);
				if(whichCharacter == _allCharacters2.length)whichCharacter--;
				_allCharacters2[whichCharacter].positionMe();
				_allCharacters2.splice(whichCharacter, 1);
			}
		}

		public function disableClicks(disable : Boolean = true) : void {
			_disableClicks = disable;
		}

		/* ----- Linkage and Grouping ------------------------------------------------------------------------------------------------------- */
		private function establishRelationships() : void {
			_characters.aliena.linkage.push(_characters.jack, _characters.richard, _characters.bartholomew, _characters.philip, _characters.william);
			_characters.maud.linkage.push(_characters.stephen, _characters.bartholomew, _characters.waleran);
			_characters.philip.linkage.push(_characters.waleran, _characters.tom, _characters.jack, _characters.aliena);
			_characters.regan.linkage.push(_characters.william, _characters.waleran, _characters.stephen);
			_characters.richard.linkage.push(_characters.bartholomew, _characters.aliena, _characters.stephen);
			_characters.stephen.linkage.push(_characters.maud, _characters.waleran, _characters.bartholomew, _characters.regan, _characters.richard);
			_characters.tom.linkage.push(_characters.ellen, _characters.jack, _characters.philip);
			_characters.waleran.linkage.push(_characters.philip, _characters.ellen, _characters.regan, _characters.stephen, _characters.jack);
			_characters.william.linkage.push(_characters.regan, _characters.aliena, _characters.richard, _characters.jack);
			_characters.bartholomew.linkage.push(_characters.aliena, _characters.richard, _characters.maud, _characters.stephen);
			_characters.ellen.linkage.push(_characters.jack, _characters.tom, _characters.waleran);
			_characters.jack.linkage.push(_characters.aliena, _characters.ellen, _characters.tom, _characters.philip, _characters.waleran);
		}

		private function establishClasses() : void {
			_characters.aliena.classType = ClassType.CLASS_NOBILITY;
			_characters.maud.classType = ClassType.CLASS_ROYALS;
			_characters.philip.classType = ClassType.CLASS_CLERGY;
			_characters.regan.classType = ClassType.CLASS_NOBILITY;
			_characters.richard.classType = ClassType.CLASS_NOBILITY;
			_characters.stephen.classType = ClassType.CLASS_ROYALS;
			_characters.tom.classType = ClassType.CLASS_PEASANT;
			_characters.waleran.classType = ClassType.CLASS_CLERGY;
			_characters.william.classType = ClassType.CLASS_NOBILITY;
			_characters.bartholomew.classType = ClassType.CLASS_NOBILITY;
			_characters.ellen.classType = ClassType.CLASS_PEASANT;
			_characters.jack.classType = ClassType.CLASS_PEASANT;
		}

		
		/* ----- Text Settings for Characters ------------------------------------------------------------------------------------------------------- */
		private function setCharacterText() : void {
			_characters.aliena.longText = "Bartholomew’s beautiful daughter, the object of William’s obsession and the love of Jack’s life.";
			_characters.aliena.shortText = "Played by Hayley Atwell";
			_characters.aliena.linkText.push("Can love truly conquer all?", "These siblings are bonded by\nblood and politics.", "He's raised his daughter well.", "Can their entrepreneurship\nsave Kingsbridge?", "Spurned by Aliena, she is\nnow his obsession.");
			
			_characters.maud.longText = "King Henry’s daughter whose quest for the throne will\nbe heavily contested.";
			_characters.maud.shortText = "Played by Alison Pill";
			_characters.maud.linkText.push("Is he more deserving\nof the throne?", "One of Maud’s\nfew trustworthy allies.", "Is his loyalty authentic?");
			
			_characters.philip.longText = "As Prior of Kingsbridge, Philip will learn the game of politics by dealing with Waleran.";
			_characters.philip.shortText = "Played by Matthew Macfadyen";
			_characters.philip.linkText.push("Some debts call for\nmore than gratitude.", "Which man’s expertise\nwill prove more useful?", "Together, they’ll build\ngreat things.", "Can their entrepreneurship\nsave Kingsbridge?");
			
			_characters.regan.longText = "Shamelessly possessed with achieving power and wealth for her family.";
			_characters.regan.shortText = "Played by Sarah Parish";
			_characters.regan.linkText.push("His mother’s love\nknows no bounds.", "Thick as thieves.", "Corruption starts at the top.");
			
			_characters.richard.longText = "Bartholomew’s son, a brave knight and heir to the title of Earl of Shiring.";
			_characters.richard.shortText = "Played by Sam Claflin";
			_characters.richard.linkText.push("Like father, like son.", "These siblings are bonded by\nblood and politics.", "Is this a king\nworth fighting for?");
			
			_characters.stephen.longText = "King Henry’s nephew who\nhas secret aspirations to be England’s next ruler.";
			_characters.stephen.shortText = "Played by Tony Curran";
			_characters.stephen.linkText.push("Is she more deserving\nof the throne?", "Powerful ambitions call for\npowerful allies.", "No title is safe.", "Even kings can\nbe manipulated.", "Is he as skilled in the court as\nhe is on the battlefield?");
			
			_characters.tom.longText = "Master-builder of the Kingsbridge Cathedral and father to Alfred and Jack.";
			_characters.tom.shortText = "Played by Rufus Sewell";
			_characters.tom.linkText.push("Provides Tom a warm bed\nin a cold world.", "He has much to learn\nfrom Tom.", "Two men who share\none vision.");
			
			_characters.waleran.longText = "Ruthlessly manipulative, Waleran believes it’s God’s will for him to gain power within the Church. ";
			_characters.waleran.shortText = "Played by Ian McShane";
			_characters.waleran.linkText.push("Can even the purest of hearts\nbe corrupted?", "Some secrets never die.", "Thick as thieves.", "No royal favor\ngoes unreturned.", "Never underestimate a pawn.");
			
			_characters.william.longText = "A pawn in his mother’s master plan, William is nothing less than pure evil.";
			_characters.william.shortText = "Played by David Oakes";
			_characters.william.linkText.push("This mother’s love\nknows no bounds.", "The source of his desires,\nand eternal hatred.", "The larger the threat,\nthe stronger the adversary.", "Who will cast the first stone?");
			
			_characters.bartholomew.longText = "Beloved Earl of Shiring, strong ally to Maud and devoted father of Aliena and Richard.";
			_characters.bartholomew.shortText = "Played by Donald Sutherland";
			_characters.bartholomew.linkText.push("A daughter’s admiration\nlasts a lifetime.", "Like father, like son.", "Bartholomew’s ally to the end.", "Will Bartholomew have\na place in his court?");
			
			_characters.ellen.longText = "A healer and free spirit who instinctively protects her son, Jack, Tom and his family.";
			_characters.ellen.shortText = "Played by Natalia Wörner";
			_characters.ellen.linkText.push("Spirit is a strong trait\nin this family.", "Can they build\nsomething together?", "His secret gives her strength.");
			
			_characters.jack.longText = "An artist, architect and dreamer who is driven by his love for Aliena.";
			_characters.jack.shortText = "Played by Eddie Redmayne";
			_characters.jack.linkText.push("Every artist has his muse.", "Some mother-son bonds\nare unbreakable.", "Can Tom be the father\nthat Jack never had?", "Together, they’ll build\ngreat things.", "Should a man of the cloth fear\na boy in rags?");
		}

		/* ----- Grouping Controls (Character Classes) --------------------------------------------------------------------------------------------- */
		private function createClassGroup(event : MouseEvent) : void {
			if(!_disableClicks) {
				if(_currentGroup) {
					if(_currentGroup != event.target.name) {
						resetGroup();
						selectGroup(event.target.name);
					}
				} else {
					selectGroup(event.target.name);
				}
			}
		}

		private function selectGroup(group : String) : void {
			if(group == "but_nobility")organizeGroup(ClassType.CLASS_NOBILITY);
			if(group == "but_commoners")organizeGroup(ClassType.CLASS_PEASANT);
			if(group == "but_clergy")organizeGroup(ClassType.CLASS_CLERGY);
			if(group == "but_royal")organizeGroup(ClassType.CLASS_ROYALS);
			_currentGroup = group;
		}

		private function organizeGroup(group : String, count : Number = 0, currentX : Number = 0) : void {
			if(count == 0)_groupedCharacters = new Array();
			if(_allCharacters[count].classType == group) {
				_groupedCharacters.push(_allCharacters[count]);
				_allCharacters[count].groupedX = currentX;
				_allCharacters[count].groupedY = GROUPED_CHARACTERS_Y;
				_allCharacters[count].isGrouped = true;
				currentX += _allCharacters[count].width + 10;
			}
			count++;
			if(count < _allCharacters.length)organizeGroup(group, count, currentX);
			if(count == _allCharacters.length) {
				adjustGroupPosition();
				animateGroup();
				dimNonGrouped();
				resetInactiveCharacters();
			}
		}

		private function adjustGroupPosition() : void {
			var groupWidth : Number = (_groupedCharacters.length * _allCharacters[0].width) + ((_groupedCharacters.length - 1) * 10);
			var xAdjustment : Number = (Layout.STAGE_WIDTH - groupWidth + _allCharacters[0].width) / 2;
			for each(var character : PillarsCharacter in _groupedCharacters) {
				character.groupedX += xAdjustment;
			}
		}

		private function animateGroup() : void {
			bringGroupToForeground(_groupedCharacters);
			for each(var character : PillarsCharacter in _groupedCharacters) {
				character.groupMe();
			}
		}

		/* Group Icon Visibility */
		private function showGroups() : void {
			_societyRankings.showMe();
		}

		private function hideGroups() : void {
			_societyRankings.hideMe();
		}

		/* ----- Character Click Handlers ------------------------------------------------------------------------------------------------------- */
		private function handleCharacterClick(event : PillarsEvent) : void {
			if((!_disableClicks)&&(!event.target.isFlipped)) {
				if((_clickedCharacter != event.target) || (_clickedCharacter.isCentered == false)) {
					if(_clickedCharacter) {
						if(_clickedCharacter.linkage.length >= 1) {
							resetCharacters();
							removeLightRays();
						}
					}
					_clickedCharacter = PillarsCharacter(event.target);
					if(_clickedCharacter.linkage.length >= 1) {
						if(_groupedCharacters.length >= 1)resetGroup();
						hideGroups();
						handleClickedCharacter();
					}
				}
			}
		}

		private function handleClickedCharacter() : void {
			bringObjectsToForeground(null, _clickedCharacter);
			_clickedCharacter.centerMe();
			_clickedCharacter.isCentered = true;
			_clickedCharacter.addEventListener(PillarsEvent.CHARACTER_CENTERED, readyForConnections);
			populateText();
			dimNonLinked();
			resetInactiveCharacters();
		}

		private function populateText() : void {
			for(var i : Number = 0;i < _clickedCharacter.linkage.length;i++) {
				_clickedCharacter.linkage[i].shortLinkText = _clickedCharacter.linkText[i];
			}
		}

		private function readyForConnections(event : Event) : void {
			event.target.removeEventListener(PillarsEvent.CHARACTER_CENTERED, readyForConnections);
			connectCharacters();
		}

		private function connectCharacters(count : Number = 0) : void {
			if(count == 0)bringObjectsToForeground(_clickedCharacter.linkage);
			
			_clickedCharacter.linkage[count].connectMe(count, _clickedCharacter.linkage.length);
			_clickedCharacter.linkage[count].isLinked = true;

			count++;
			
			if(count < _clickedCharacter.linkage.length)connectCharacters(count);
			if(count == _clickedCharacter.linkage.length)addLightRays();
		}

		/* ----- Light Ray FX ------------------------------------------------------------------------------------------------------- */
		private function addLightRays(count : Number = 0) : void {
			var startingX : Number = _clickedCharacter.x;
			var startingY : Number = _clickedCharacter.y;
			var endingX : Number = _clickedCharacter.linkage[count].linkedX;
			var endingY : Number = _clickedCharacter.linkage[count].linkedY;
			
			var lightRay : LightRay = new LightRay();
			lightRay.determineAngle(startingX, startingY, endingX, endingY);
			lightRay.x = startingX;
			lightRay.y = startingY;
			
			_characters.addChildAt(lightRay, _characters.numChildren - _clickedCharacter.linkage.length - 1);
			_lightRays.push(lightRay);
			
			lightRay.showMe();
			
			count++;
			if(count < _clickedCharacter.linkage.length)addLightRays(count);
		}

		private function removeLightRays() : void {
			if(_lightRays.length > 0) {
				_lightRays[0].hideMe();
				_lightRays.splice(0, 1);
			}
		
			if(_lightRays.length > 0)removeLightRays();
		}

		/* ----- Character Fade Back FX ------------------------------------------------------------------------------------------------------- */
		private function dimNonGrouped() : void {
			for (var i : Number = 0;i < _allCharacters.length;i++) {
				var match : Boolean = false;
				for (var j : Number = 0;j < _groupedCharacters.length;j++) {
					if(_groupedCharacters[j] == _allCharacters[i])match = true;
				}
				if(!match)_allCharacters[i].dimMe();
			}
		}

		private function dimNonLinked() : void {
			for (var i : Number = 0;i < _allCharacters.length;i++) {
				var match : Boolean = false;
				for (var j : Number = 0;j < _clickedCharacter.linkage.length;j++) {
					if(_clickedCharacter.linkage[j] == _allCharacters[i])match = true;
					if(_clickedCharacter == _allCharacters[i])match = true;
				}
				if(!match)_allCharacters[i].dimMe();
			}
		}

		private function resetDim() : void {
			for (var i : Number = 0;i < _allCharacters.length;i++) {
				if(_allCharacters[i].isDimmed)_allCharacters[i].resetDim();
			}
		}

		/* ----- Character Resets ------------------------------------------------------------------------------------------------------- */
		private function resetCharacters(count : Number = 0) : void {
			if(_clickedCharacter) {
				if(count == 0)_clickedCharacter.resetMe();
				if(_clickedCharacter.linkage.length > 0)_clickedCharacter.linkage[count].resetMe();
				count++;
			
				if(count < _clickedCharacter.linkage.length)resetCharacters(count);
				if(count == _clickedCharacter.linkage.length)showGroups();
			}
			resetDim();
		}
		
		private function resetInactiveCharacters():void {
			dispatchEvent(new PillarsEvent(PillarsEvent.FLIP_CARDS_BACK, false, false));
		}

		private function resetGroup() : void {
			for each(var character : PillarsCharacter in _groupedCharacters) {
				character.resetMe();
			}
			_currentGroup = null;
			resetDim();
		}

		private function resetAll(event : MouseEvent = null) : void {
			if(!_disableClicks) {
				if(_clickedCharacter)resetCharacters();
				if(_groupedCharacters.length > 0)resetGroup();
				showGroups();
				removeLightRays();
			}
		}

		/* ----- Object Depth ------------------------------------------------------------------------------------------------------- */
		public function bringObjectsToForeground(objects : Array = null, foregroundObject : PillarsCharacter = null) : void {
			if(objects) {
				for(var i : Number = 0;i < objects.length;i++) {
					_characters.setChildIndex(objects[i], _characters.numChildren - 2 - i);
				}
			}
			if(foregroundObject) {
				_characters.setChildIndex(foregroundObject, _characters.numChildren - 1);
			}
		}

		public function bringGroupToForeground(objects : Array) : void {
			for(var i : Number = 0;i < objects.length;i++) {
				_characters.setChildIndex(objects[i], _characters.numChildren - 1 - i);
			}
		}
	}
}