package com.screens{

	import com.screens.screenAssets.*;
	import flash.display.MovieClip;
	import flash.events.*;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.text.TextField;

	public class characterScreen extends MovieClip {
		
		/* Library Items */
		private var crixusInfo:characterInfo = new characterInfo();
		private var suraInfo:characterInfo = new characterInfo();
		private var lucritiaInfo:characterInfo = new characterInfo();
		private var batiatusInfo:characterInfo = new characterInfo();
		private var glaberInfo:characterInfo = new characterInfo();
		private var spartacusInfo:characterInfo = new characterInfo();
		private var doctoreInfo:characterInfo = new characterInfo();
		/* Variables */
		private var currentCharacterInfo:characterInfo;
		private var myChosenCharacter:chosenCharacter;

		public function characterScreen():void {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(event:Event):void {
			playMusic();
			createCharacterBoxes();
			createMouseOvers();
			addEventListener(Event.REMOVED_FROM_STAGE, removeCharacter);
		}
		private function createCharacterBoxes():void {
			crixusInfo.characterName.text = "Crixus";
			crixusInfo.characterDescription.text = "The top gladiator at the Ludus, Crixus has a deep-seated dislike of Spartacus. Skilled with sword and shield, he brings death to the arena. And the crowds love him for it.\nStrengths: Muscle. Dedication. Speed.";
			crixusInfo.characterPlaceholder.addChild(new Crixus);
			
			suraInfo.characterName.text = "Sura";
			suraInfo.characterDescription.text = "Spartacus’ wife and a Thracian priestess who has visions of events yet to pass. Don’t be fooled by her femininity, she’s just as deadly as she is beautiful.\nStrengths: Foresight. Close combat.  Beauty.";
			suraInfo.characterPlaceholder.addChild(new Sura);
			
			lucritiaInfo.characterName.text = "Lucritia";
			lucritiaInfo.characterDescription.text = "Batiatus’ wife and equal, she manages situations with a steel grip inside a kid glove. Passionate, conniving and ruthless, she’ll play every situation to her advantage.\nStrengths: Sexuality. Slyness. Manipulation.";
			lucritiaInfo.characterPlaceholder.addChild(new Lucritia);
			
			batiatusInfo.characterName.text = "Batiatus";
			batiatusInfo.characterDescription.text = "The merciless owner of the Ludus, he added Spartacus to his squad of gladiators with hopes of achieving fortune and power in Rome. He’ll stop at nothing to get his way.\nStrengths: Cunning.  Power. Charm.";
			batiatusInfo.characterPlaceholder.addChild(new Batiatus);
			
			glaberInfo.characterName.text = "Glaber";
			glaberInfo.characterDescription.text = "An ambitious Roman Legate who plays politics in Rome, he blames Spartacus for his failed military campaign. A skillful soldier who is not to be trusted.\nStrengths: Authority. Determination. Wealth.";
			glaberInfo.characterPlaceholder.addChild(new Glaber);
			
			spartacusInfo.characterName.text = "Spartacus";
			spartacusInfo.characterDescription.text = "A Thracian soldier in the Roman Auxiliary, he was sentenced to death in the arena but survived against all odds. Spartacus is a true warrior with brains to match his brawn.\nStrengths: Intelligence. Athleticism. Charisma.";
			spartacusInfo.characterPlaceholder.addChild(new Spartacus);
			
			doctoreInfo.characterName.text = "Doctore";
			doctoreInfo.characterDescription.text = "Batiatus’ most loyal and trusted slave, Doctore was a highly celebrated gladiator who now teaches others to fight. He knows every trick in the book.\nStrengths: Honor. Experience. Wisdom.";
			doctoreInfo.characterPlaceholder.addChild(new Doctore);
		}
		private function createMouseOvers():void {
			makeCharacterButton(crixus);
			makeCharacterButton(sura);
			makeCharacterButton(lucritia);
			makeCharacterButton(batiatus);
			makeCharacterButton(glaber);
			makeCharacterButton(spartacus);
			makeCharacterButton(doctore);
		}
		private function makeCharacterButton(buttonName:MovieClip):void {
			buttonName.buttonMode = true;
			buttonName.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
			buttonName.addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
			buttonName.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseClick);
		}
		private function handleMouseOver(event:MouseEvent):void {
			switch(event.target.name) {
				case "crixus":
				currentCharacterInfo = crixusInfo;
				addChild(crixusInfo);
				break;
				case "sura":
				currentCharacterInfo = suraInfo;
				addChild(suraInfo);
				break;
				case "lucritia":
				currentCharacterInfo = lucritiaInfo;
				addChild(lucritiaInfo);
				break;
				case "batiatus":
				currentCharacterInfo = batiatusInfo;
				addChild(batiatusInfo);
				break;
				case "glaber":
				currentCharacterInfo = glaberInfo;
				addChild(glaberInfo);
				break;
				case "spartacus":
				currentCharacterInfo = spartacusInfo;
				addChild(spartacusInfo);
				break;
				case "doctore":
				currentCharacterInfo = doctoreInfo;
				addChild(doctoreInfo);
				break;
			}
		}
		private function handleMouseOut(event:MouseEvent):void {
			currentCharacterInfo.removeMe();
		}
		private function handleMouseClick(event:MouseEvent):void {
			myChosenCharacter = new chosenCharacter();
			MovieClip(this.parent.parent).playerCharacter = event.target.name;
			switch(event.target.name) {
				case "crixus":
				myChosenCharacter.characterPlaceholder.addChild(new Crixus);
				addChild(myChosenCharacter);
				break;
				case "sura":
				myChosenCharacter.characterPlaceholder.addChild(new Sura);
				addChild(myChosenCharacter);
				break;
				case "lucritia":
				myChosenCharacter.characterPlaceholder.addChild(new Lucritia);
				addChild(myChosenCharacter);
				break;
				case "batiatus":
				myChosenCharacter.characterPlaceholder.addChild(new Batiatus);
				addChild(myChosenCharacter);
				break;
				case "glaber":
				myChosenCharacter.characterPlaceholder.addChild(new Glaber);
				addChild(myChosenCharacter);
				break;
				case "spartacus":
				myChosenCharacter.characterPlaceholder.addChild(new Spartacus);
				addChild(myChosenCharacter);
				break;
				case "doctore":
				myChosenCharacter.characterPlaceholder.addChild(new Doctore);
				addChild(myChosenCharacter);
				break;
			}
		}
		private function removeCharacter(event:Event):void {
			try {
				removeChild(myChosenCharacter);
			} catch (e:Error) {
			}
		}
		/* ------------------------------------------------------------------------- Audio ------------------------------------------------------------ */
		private function playMusic():void {
			MovieClip(this.parent.parent).playMusic("Characters");
		}
	}
}