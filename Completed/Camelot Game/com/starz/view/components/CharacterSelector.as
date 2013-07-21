package com.starz.view.components
{
	import com.starz.events.GameEvent;
	import flash.events.Event;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;

	public class CharacterSelector extends MovieClip
	{
		private static const TWEEN_SPEED:Number = .5;
		private var _oldCharacterTween:TweenLite;
		private var _newCharacterTween:TweenLite;
		private var _currentCharacter:AnimatedCharacter;
		private var _characters:Array;
		private var _characterNames:Array;
		private var _characterDescriptions:Array;
		private var _characterCount:Number;
		private var _storedX:Number;
		private var _tweening:Boolean;

		public function CharacterSelector():void
		{
			init();
		}
		private function init():void
		{
			leftArrow.buttonMode = true;
			leftArrow.mouseChildren = false;
			leftArrow.addEventListener(MouseEvent.CLICK, previousCharacter);

			rightArrow.buttonMode = true;
			rightArrow.mouseChildren = false;
			rightArrow.addEventListener(MouseEvent.CLICK, nextCharacter);

			selectButton.addEventListener(MouseEvent.CLICK, chooseCharacter);

			prepCharacters();
		}
		private function prepCharacters():void
		{
			_characters = new Array(arthur,kay,leontes);
			_characterNames = new Array("Arthur","Kay", "Leontes");
			_characterDescriptions = new Array("King of Camelot","Arthur's Brother", "Arthur's Bodyguard");
			_characterCount = 0;
			_currentCharacter = _characters[0];
			
			changeText(0);

			for (var i:Number = 1; i <_characters.length; i++)
			{
				_characters[i].alpha = 0;
			}
		}
		private function previousCharacter(e:MouseEvent):void
		{
			if (! _tweening)
			{
				hideCharacter(_characterCount, "left");
				_characterCount--;
				if (_characterCount < 0)
				{
					_characterCount = _characters.length - 1;
				}
				showCharacter(_characterCount, "left");
			}
		}
		private function nextCharacter(e:MouseEvent):void
		{
			if (! _tweening)
			{
				hideCharacter(_characterCount, "right");
				_characterCount++;
				if (_characterCount == _characters.length)
				{
					_characterCount = 0;
				}
				showCharacter(_characterCount, "right");
			}
		}
		private function showCharacter(characterCount:Number, tweenDirection:String):void
		{
			if (tweenDirection == "left")
			{
				_characters[characterCount].x +=  100;
				_newCharacterTween = new TweenLite(_characters[characterCount],TWEEN_SPEED,{x:_characters[characterCount].x - 100,alpha:1,onComplete:changeText,onCompleteParams:[characterCount]});
			}
			if (tweenDirection == "right")
			{
				_characters[characterCount].x -=  100;
				_newCharacterTween = new TweenLite(_characters[characterCount],TWEEN_SPEED,{x:_characters[characterCount].x + 100,alpha:1,onComplete:changeText,onCompleteParams:[characterCount]});
			}
			_currentCharacter = _characters[characterCount];
		}
		private function hideCharacter(characterCount:Number, tweenDirection:String):void
		{
			_storedX = _characters[characterCount].x;
			_tweening = true;
			if (tweenDirection == "left")
			{
				_oldCharacterTween = new TweenLite(_characters[characterCount],TWEEN_SPEED,{x:_characters[characterCount].x - 100,alpha:0,onComplete:resetCharacter,onCompleteParams:[characterCount]});
			}
			if (tweenDirection == "right")
			{
				_oldCharacterTween = new TweenLite(_characters[characterCount],TWEEN_SPEED,{x:_characters[characterCount].x + 100,alpha:0,onComplete:resetCharacter,onCompleteParams:[characterCount]});
			}
		}
		private function resetCharacter(characterCount:Number):void
		{
			_characters[characterCount].x = _storedX;
			_tweening = false;
		}
		private function changeText(characterCount:Number):void
		{
			_currentCharacter.gotoAndPlay("Nod");
			characterName.text = _characterNames[characterCount]
			characterDescription.text = _characterDescriptions[characterCount]
		}
		private function chooseCharacter(e:MouseEvent):void
		{
			var gameData:Object = new Object();
			gameData.character = _currentCharacter;
			dispatchEvent(new GameEvent(GameEvent.CHARACTER_SELECTED, gameData));
		}
	}

}