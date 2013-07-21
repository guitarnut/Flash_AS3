package com.starz.view
{
	import com.starz.view.components.GameScreen;
	import com.starz.control.ControlsManager;
	import flash.events.Event;
	import com.starz.events.GameEvent;
	import com.starz.constants.BattleSequences;
	import com.starz.constants.GawainComments;
	import com.starz.functions.GenerateCompliment;
	import com.starz.functions.GenerateCommand;
	import com.starz.functions.GenerateInsult;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.starz.functions.GenerateSequence;
	import com.starz.constants.GameScores;
	import com.starz.constants.Achievements;
	import com.starz.view.components.AnimatedCharacter;
	import com.greensock.TweenLite;

	public dynamic class CombatScreen extends GameScreen {;

	private static const PAUSE:Number = 3;

	private var _controls:ControlsManager;
	private var _userSequenceCount:Number;
	private var _userCommandSlots:Array;
	private var _computerCommandSlots:Array;
	private var _currentSequence:Array;
	private var _attempts:Number;
	private var _sequence:Number;
	private var _difficulty:String;
	private var _perfectRound:Boolean;
	private var _player:AnimatedCharacter;
	private var _hudTween:TweenLite;
	private var _playerTween:TweenLite;
	private var _iconTween:TweenLite;
	private var _titleTween:TweenLite;
	private var _commandsTween:TweenLite;
	private var _commandsTween2:TweenLite;
	private var _attemptsTween:TweenLite;
	private var _gawainTween:TweenLite;

	public function CombatScreen():void
	{
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	public function setDifficulty(difficulty:String):void
	{
		_difficulty = difficulty;
	}
	public function setCharacter(character):void
	{
		switch (character)
		{
			case "gawain" :
				_player = new Gawain();
				break;
			case "arthur" :
				_player = new Arthur();
				break;
			case "kay" :
				_player = new Kay();
				break;
			case "leontes" :
				_player = new Leontes();
				break;
		}
		addChildAt(_player, 1);
		_player.scaleX = .62;
		_player.scaleY = .62;
		_player.x = 218;
		_player.y = 237;
		_player.addEventListener(GameEvent.MOVEMENT_COMPLETE, advance_playerMoveDisplay);
		_player.bindControls(_controls);

		analytics("Character selected: "+character);
	}
	private function init(e:Event):void
	{
		addListeners();
		storeCommandSlots();

		userMoveCommands.isUser = true;

		_controls = new ControlsManager(this.stage);
	}
	private function storeCommandSlots():void
	{
		_userCommandSlots = new Array();
		_userCommandSlots.push(userMoveCommands.slotOne, userMoveCommands.slotTwo, userMoveCommands.slotThree, userMoveCommands.slotFour);
		_computerCommandSlots = new Array();
		_computerCommandSlots.push(moveCommands.slotOne, moveCommands.slotTwo, moveCommands.slotThree, moveCommands.slotFour);
	}
	override protected function addListeners():void
	{
		gawain.addEventListener(GameEvent.MOVEMENT_COMPLETE, advanceMoveDisplay);
	}
	public function startRound():void
	{
		playMusic(new CombatMusic(), true);
		showMe();
		positionStageObjects();
		_perfectRound = true;
		_sequence = 1;
		pauseGame(.5, new Array(openingAnimation), new Array(null));
		pauseGame(3, new Array(demonstrateMove), new Array(null));
	}
	private function positionStageObjects():void
	{
		hudBG.y = hudBG.y + hudBG.height;
		titleText.y = titleText.y + 200;
		gawainIcon.x = gawainIcon.x - 250;
		moveCommands.x = moveCommands.x + 650;
		attemptsMC.x = attemptsMC.x + 650;
		gawain.x = gawain.x + 450;
		_player.x = _player.x - 450;
		userMoveCommands.x = userMoveCommands.x - 450;
	}
	private function openingAnimation():void
	{
		_hudTween = new TweenLite(hudBG, .25, {y: hudBG.y - hudBG.height});
		_titleTween = new TweenLite(titleText, .5, {delay: .25, y: titleText.y - 200});
		_iconTween = new TweenLite(gawainIcon, .5, {delay: .25, x: gawainIcon.x + 250});
		_commandsTween = new TweenLite(moveCommands, .5, {delay: .75, x: moveCommands.x - 650});
		_attemptsTween = new TweenLite(attemptsMC, .5, {delay: .75, x: attemptsMC.x - 650});
		_gawainTween = new TweenLite(gawain, .5, {delay: 1.25, x: gawain.x - 450});
		_playerTween = new TweenLite(_player, .5, {delay: 1.25, x: _player.x + 450});
		_commandsTween2 = new TweenLite(userMoveCommands, .5, {delay: 1.25, x: userMoveCommands.x + 450});
	}
	private function advanceToNextMove():void
	{
		_sequence++;

		if (_sequence <= 3)
		{
			demonstrateMove();
		}
		else
		{
			endRound();
		}
	}
	private function endRound():void
	{
		gawainText.text = "";
		attemptsMC.attemptsText.text = "";
		dispatchEvent(new GameEvent(GameEvent.LEVEL_COMPLETE));
	}
	private function startGameplay():void
	{
		_controls.controlsActive(true);
	}
	private function endGameplay():void
	{
		_controls.controlsActive(false);
	}
	private function demonstrateMove(sequence:Array = null):void
	{
		if (sequence == null)
		{
			_currentSequence = GenerateSequence(_difficulty);
			_attempts = 1;
		}
		else
		{
			_attempts++;
		}
		if (_attempts <= 3)
		{
			moveCommands.storeSequence(_currentSequence);

			gawainText.text = GenerateCommand();
			gawain.playSequence(_currentSequence);

			attemptsMC.attemptsText.text = "Attempt " + _attempts + " of 3";

			_player.requiredSequence = _currentSequence;
			_userSequenceCount = 0;
			startGameplay();
		}
		else
		{
			sequenceFailed();
		}
	}
	private function advanceMoveDisplay(e:GameEvent):void
	{
		moveCommands.showSequence(e.gameData.sequenceCount);
	}
	private function advance_playerMoveDisplay(e:GameEvent):void
	{
		userMoveCommands.showUserSequence(e.gameData.userMove, _userSequenceCount);
		_userSequenceCount++;
		if (_userSequenceCount == _player.requiredSequence.length)
		{
			endGameplay();
			critique_player();
		}
	}
	private function checkUserInput():Boolean
	{
		var correctSequence = true;
		for (var i:Number = 0; i <_player.requiredSequence.length; i++)
		{
			if (_userCommandSlots[i].currentCommand.name != _computerCommandSlots[i].currentCommand.name)
			{
				_userCommandSlots[i].wrongAnswer();
				correctSequence = false;
				_perfectRound = false;
			}
		}
		return correctSequence;
	}
	private function critique_player():void
	{
		if (checkUserInput())
		{
			reward_player();
		}
		else
		{
			punish_player();
		}
	}
	private function reward_player():void
	{
		updateScore();
		if (_attempts == 1)
		{
			dispatchEvent(new GameEvent(GameEvent.COMBO_ACED));
		}
		if (_sequence == 3)
		{
			T_Achievement();
		}
		gawainText.text = GenerateCompliment();
		pauseGame(PAUSE, new Array(userMoveCommands.reset, moveCommands.reset, advanceToNextMove), new Array(null, null, null));
	}
	private function punish_player():void
	{
		updateScore(false);
		gawainText.text = GenerateInsult();
		pauseGame(PAUSE, new Array(userMoveCommands.reset, moveCommands.reset, demonstrateMove), new Array(null, null, _currentSequence));
	}
	private function sequenceFailed():void
	{
		var gameData:Object= new Object();
		gameData.points = GameScores.FAILED_COMBO;
		dispatchEvent(new GameEvent(GameEvent.UPDATE_SCORE, gameData));
		analytics("Failed sequence: "+String(_currentSequence));
		gawainText.text = "Let's move on to something else.";
		A_Achievement();
		pauseGame(PAUSE, new Array(userMoveCommands.reset, moveCommands.reset, advanceToNextMove), new Array(null, null, null));
	}
	private function A_Achievement():void
	{
			var gameData:Object = new Object();
			gameData.achievement = Achievements.ARE_YOU_PAYING_ATTENTION;
			dispatchEvent(new GameEvent(GameEvent.ACHIEVEMENT, gameData));
	}
	private function T_Achievement():void
	{
		if (_perfectRound)
		{
			var gameData:Object = new Object();
			gameData.achievement = Achievements.TOP_STUDENT;
			dispatchEvent(new GameEvent(GameEvent.ACHIEVEMENT, gameData));
		}
	}
	private function updateScore(b$:Boolean = true):void
	{
		var gameData:Object= new Object();
		if (b$)
		{
			gameData.points = GameScores.CORRECT_COMBO;
			dispatchEvent(new GameEvent(GameEvent.UPDATE_SCORE, gameData));
		}
		else
		{
			gameData.points = GameScores.INCORRECT_COMBO;
			dispatchEvent(new GameEvent(GameEvent.UPDATE_SCORE, gameData));
		}
	}
	public function reset():void {
		removeChild(_player);
		_player.removeEventListener(GameEvent.MOVEMENT_COMPLETE, advance_playerMoveDisplay);
		_player.reset();
	}

}
}