package com.screens{

	import com.gameFX.*;
	import flash.display.MovieClip;
	import flash.events.*;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.text.TextField;
	import flash.utils.Timer;

	public class battleScreen extends MovieClip {

		/* Adjustable values */
		private var animationSpeed:Number=.5;
		private var introAnimationInterval:Number=1;
		private var battlePause:Number=1;
		private var enemyWeaponX1:Number=920;
		private var enemyWeaponX2:Number=540;
		private var enemyWeaponX3:Number=460;
		private var heroWeaponX1:Number;
		private var heroWeaponX2:Number=-110;
		private var heroWeaponX3:Number=-35;
		private var heroWeaponY1:Number;
		private var heroWeaponY2:Number=-193;
		/* Library Items */
		private var myGameFX:specialFX1 = new specialFX1();
		private var myDamageFX:specialFX2 = new specialFX2();
		private var battleResultText:specialFX3 = new specialFX3();
		/* Variables */
		private var tipTimer:Timer;
		private var currentEnemyWeapon:MovieClip;
		private var currentHeroWeapon:MovieClip;
		private var alphaTween:Tween;
		private var backgroundXTween:Tween;
		private var helpTween:Tween;
		private var tipTween:Tween;
		private var locationAlphaTween:Tween;
		private var logoAlphaTween:Tween;
		private var namesAlphaTween:Tween;
		private var opponentTextAlphaTween:Tween;
		private var enemyAlphaTween:Tween;
		private var heroAlphaTween:Tween;
		private var attackMenuTween:Tween;
		private var attackTextTween:Tween;
		private var enemyAttackTextTween:Tween;
		private var enemySwordTween:Tween;
		private var enemyShieldTween:Tween;
		private var enemysledgehammerTween:Tween;
		private var enemyAttackTween:Tween;
		private var enemyAttackXTween:Tween;
		private var enemyAttackYTween:Tween;
		private var userAttackYTween:Tween;
		private var userAttackXTween1:Tween;
		private var userAttackXTween2:Tween;
		private var xHeroTween:Tween;
		private var xEnemyTween:Tween;
		private var yTween:Tween;

		private var battleRound:Number=1;
		private var combatRound:Number=1;
		private var totalBattles:Number=0;
		private var totalTies:Number=0;
		private var playerWins:Number=0;
		private var totalPlayerWins:Number=0;
		private var opponent1Wins:Number=0;
		private var opponent2Wins:Number=0;
		private var opponent3Wins:Number=0;
		private var swordWins:Number=0;
		private var shieldWins:Number=0;
		private var sledgehammerWins:Number=0;

		private var goodGuy:String;
		private var badGuy:String;
		private var pastOpponents:Array = new Array();

		public function battleScreen():void {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(event:Event):void {
			hideEverything();
			playMusic();
			createHero();
			chooseOpponent();
			prepareForBattle();
		}
		private function hideEverything():void {
			for (var i:Number = 0; i < this.numChildren; i++) {
				getChildAt(i).alpha=0;
			}
		}
		/* ------------------------------------------------------------------------- Character Selection ------------------------------------------------------------ */
		private function createHero():void {
			switch (MovieClip(this.parent.parent).playerCharacter) {
				case "crixus" :
					heroCharacter.addChildAt(new Crixus, 0);
					goodGuy="Crixus";
					break;
				case "sura" :
					heroCharacter.addChildAt(new Sura, 0);
					goodGuy="Sura";
					break;
				case "lucritia" :
					heroCharacter.addChildAt(new Lucritia, 0);
					goodGuy="Lucritia";
					break;
				case "batiatus" :
					heroCharacter.addChildAt(new Batiatus, 0);
					goodGuy="Batiatus";
					break;
				case "glaber" :
					heroCharacter.addChildAt(new Glaber, 0);
					goodGuy="Glaber";
					break;
				case "spartacus" :
					heroCharacter.addChildAt(new Spartacus, 0);
					goodGuy="Spartacus";
					break;
				case "doctore" :
					heroCharacter.addChildAt(new Doctore, 0);
					goodGuy="Doctore";
					break;
			}
		}
		private function chooseOpponent():void {
			if (enemyCharacter.numChildren>1) {
				enemyCharacter.removeChildAt(0);
			}
			var myCharacter:Number=Math.round(Math.random()*7);
			switch (myCharacter) {
				case 1 :
					enemyCharacter.addChildAt(new Crixus, 0);
					badGuy="Crixus";
					break;
				case 2 :
					enemyCharacter.addChildAt(new Sura, 0);
					badGuy="Sura";
					break;
				case 3 :
					enemyCharacter.addChildAt(new Lucritia, 0);
					badGuy="Lucritia";
					break;
				case 4 :
					enemyCharacter.addChildAt(new Batiatus, 0);
					badGuy="Batiatus";
					break;
				case 5 :
					enemyCharacter.addChildAt(new Glaber, 0);
					badGuy="Glaber";
					break;
				case 6 :
					enemyCharacter.addChildAt(new Spartacus, 0);
					badGuy="Spartacus";
					break;
				case 7 :
					enemyCharacter.addChildAt(new Doctore, 0);
					badGuy="Doctore";
					break;
				default:
					enemyCharacter.addChildAt(new Doctore, 0);
					badGuy="Doctore";
					break;
			}
			/* Avoid fighting yourself */
			if (goodGuy==badGuy) {
				chooseOpponent();
			} else {
				/* Make sure you don't fight the same person twice */
				if (pastOpponents.length>0) {
					for (var i:Number = 0; i < pastOpponents.length; i++) {
						if (pastOpponents[i]==badGuy) {
							chooseOpponent();
							break;
						}
					}
				}
				pastOpponents.push(badGuy);
				updateEndingScreenImage(badGuy);
			}
		}
		/* ------------------------------------------------------------------------- Stage Setup ------------------------------------------------------------ */
		private function prepareForBattle():void {
			myGameFX.gotoAndStop("Next Round");
			addChild(myGameFX);
			setText();
			var myTimer:Timer=new Timer(introAnimationInterval*1000,0);
			myTimer.addEventListener(TimerEvent.TIMER, animateMe);
			myTimer.start();
			var animationCount:Number=0;
			function animateMe(event:TimerEvent):void {
				switch (animationCount) {
					case 0 :
						alphaTween=new Tween(battleBackground,"alpha",None.easeNone,0,1,animationSpeed,true);
						break;
					case 1 :
						locationAlphaTween=new Tween(battleLocation,"alpha",None.easeNone,0,1,animationSpeed,true);
						break;
					case 2 :
						namesAlphaTween=new Tween(opponentNames,"alpha",None.easeNone,0,1,animationSpeed,true);
						break;
					case 3 :
						heroAlphaTween=new Tween(heroCharacter,"alpha",None.easeNone,0,1,animationSpeed,true);
						xHeroTween=new Tween(heroCharacter,"x",Regular.easeIn,-1*heroCharacter.width,heroCharacter.x,animationSpeed,true);
						enemyAlphaTween=new Tween(enemyCharacter,"alpha",None.easeNone,0,1,animationSpeed,true);
						xEnemyTween=new Tween(enemyCharacter,"x",Regular.easeIn,800+enemyCharacter.width,enemyCharacter.x,animationSpeed,true);
						break;
					case 4 :
						logoAlphaTween=new Tween(logo,"alpha",None.easeNone,0,1,animationSpeed,true);
						break;
					case 5 :
						myTimer.stop();
						myTimer.removeEventListener(TimerEvent.TIMER, animateMe);
						sword.alpha=1;
						shield.alpha=1;
						sledgehammer.alpha=1;
						setupHelpMenu();
						updateStats();
						enableAttackMenu();
						myGameFX.gotoAndStop("Fight");
						addChild(myGameFX);
						break;
					default :
						break;
				}
				animationCount++;
			}
		}

		/* ------------------------------------------------------------------------- User help menu ------------------------------------------------------------ */
		private function setupHelpMenu():void {
			gameTip.alpha=0;
			helpIcon.alpha=1;
			helpIcon.buttonMode=true;
			helpIcon.addEventListener(MouseEvent.MOUSE_DOWN, showTip);
		}
		private function showTip(event:MouseEvent):void {
			helpIcon.removeEventListener(MouseEvent.MOUSE_DOWN, showTip);
			helpIcon.buttonMode=false;
			helpTween=new Tween(helpIcon,"alpha",None.easeNone,1,0,animationSpeed,true);
			tipTween=new Tween(gameTip,"alpha",None.easeNone,0,1,animationSpeed,true);
			tipTimer=new Timer(5000,0);
			tipTimer.addEventListener(TimerEvent.TIMER, resetTip);
			tipTimer.start();
			function resetTip(event:TimerEvent):void {
				tipTimer.stop();
				tipTimer.removeEventListener(TimerEvent.TIMER, resetTip);
				helpTween.yoyo();
				tipTween.yoyo();
				helpIcon.buttonMode=true;
				helpIcon.addEventListener(MouseEvent.MOUSE_DOWN, showTip);
			}
		}
		private function hideTip():void {
			try {
				tipTimer.stop();
				helpIcon.removeEventListener(MouseEvent.MOUSE_DOWN, showTip);
				helpIcon.buttonMode=false;
			} catch (e:Error) {
			}
			helpTween=new Tween(helpIcon,"alpha",None.easeNone,helpIcon.alpha,0,animationSpeed,true);
			tipTween=new Tween(gameTip,"alpha",None.easeNone,gameTip.alpha,0,animationSpeed,true);
		}
		/* ------------------------------------------------------------------------- User battle menu ------------------------------------------------------------ */
		private function enableAttackMenu():void {
			attackMenuTween=new Tween(attackMenu,"alpha",None.easeNone,attackMenu.alpha,1,animationSpeed,true);
			attackTextTween=new Tween(textChoose,"alpha",None.easeNone,textChoose.alpha,1,animationSpeed,true);
			attackMenu.sword.buttonMode=true;
			attackMenu.sword.addEventListener(MouseEvent.MOUSE_DOWN, animateHeroAttack);
			attackMenu.shield.buttonMode=true;
			attackMenu.shield.addEventListener(MouseEvent.MOUSE_DOWN, animateHeroAttack);
			attackMenu.sledgehammer.buttonMode=true;
			attackMenu.sledgehammer.addEventListener(MouseEvent.MOUSE_DOWN, animateHeroAttack);
		}
		private function disableAttackMenu():void {
			attackTextTween.yoyo();
			attackMenu.sword.buttonMode=false;
			attackMenu.sword.removeEventListener(MouseEvent.MOUSE_DOWN, animateHeroAttack);
			attackMenu.shield.buttonMode=false;
			attackMenu.shield.removeEventListener(MouseEvent.MOUSE_DOWN, animateHeroAttack);
			attackMenu.sledgehammer.buttonMode=false;
			attackMenu.sledgehammer.removeEventListener(MouseEvent.MOUSE_DOWN, animateHeroAttack);
		}
		/* ------------------------------------------------------------------------- Combat ------------------------------------------------------------ */
		private function animateHeroAttack(event:MouseEvent):void {
			disableAttackMenu();
			/* Show the "Your opponent is choosing" text */
			opponentTextAlphaTween=new Tween(textOpponent,"alpha",None.easeNone,0,1,animationSpeed,true);
			currentHeroWeapon=MovieClip(event.target.parent);
			/* Store the weapon's location so we can move it back later */
			heroWeaponX1=currentHeroWeapon.x;
			heroWeaponY1=currentHeroWeapon.y;
			/* Move the selected weapon to the front of the other weapons before animating it */
			MovieClip(currentHeroWeapon.parent).swapChildren(currentHeroWeapon,MovieClip(currentHeroWeapon.parent).getChildAt(MovieClip(currentHeroWeapon.parent).numChildren-1));
			/* Move the weapon left */
			userAttackXTween1=new Tween(currentHeroWeapon,"x",Regular.easeOut,heroWeaponX1,heroWeaponX2,animationSpeed,true);
			userAttackXTween1.addEventListener(TweenEvent.MOTION_FINISH, moveWeaponUp);
			function moveWeaponUp(event:TweenEvent):void {
				userAttackXTween1.removeEventListener(TweenEvent.MOTION_FINISH, moveWeaponUp);
				/* Move the weapon up */
				userAttackYTween=new Tween(currentHeroWeapon,"y",Regular.easeOut,heroWeaponY1,heroWeaponY2,animationSpeed,true);
				/* Once it's in place, select the enemy weapon and animate it */
				userAttackYTween.addEventListener(TweenEvent.MOTION_FINISH, animateEnemyAttack);
			}
		}
		private function animateEnemyAttack(event:TweenEvent):void {
			userAttackYTween.removeEventListener(TweenEvent.MOTION_FINISH, animateEnemyAttack);
			var enemyAttack:String=chooseEnemyAttack();
			if (enemyAttack=="sword") {
				currentEnemyWeapon=sword;
			}
			if (enemyAttack=="shield") {
				currentEnemyWeapon=shield;
			}
			if (enemyAttack=="sledgehammer") {
				currentEnemyWeapon=sledgehammer;
			}
			opponentTextAlphaTween.yoyo();
			enemyAttackXTween=new Tween(currentEnemyWeapon,"x",Regular.easeOut,enemyWeaponX1,enemyWeaponX2,animationSpeed,true);
			enemyAttackXTween.addEventListener(TweenEvent.MOTION_FINISH, clashWeapons);
		}
		private function clashWeapons(event:TweenEvent):void {
			/* Play the sound FX for the winning weapon */
			playWeaponSoundFX(currentHeroWeapon.name, currentEnemyWeapon.name);
			/* Animate the weapons */
			currentEnemyWeapon.weapon.gotoAndPlay(2);
			currentHeroWeapon.weapon.gotoAndPlay(2);
			enemyAttackXTween.removeEventListener(TweenEvent.MOTION_FINISH, clashWeapons);
			enemyAttackXTween=new Tween(currentEnemyWeapon,"x",Regular.easeOut,enemyWeaponX2,enemyWeaponX3,animationSpeed,true);
			userAttackXTween2=new Tween(currentHeroWeapon,"x",Regular.easeOut,heroWeaponX2,heroWeaponX3,animationSpeed,true);
			letsGetItOn();
		}
		private function playWeaponSoundFX(weapon1:String, weapon2:String):void {
			/* Play the sound of the winning weapon */
			if (weapon1=="sword"&&weapon2=="shield") {
				MovieClip(this.parent.parent).playFX("Shield");
			}
			if (weapon1=="sword"&&weapon2=="sledgehammer") {
				MovieClip(this.parent.parent).playFX("Sword");
			}
			if (weapon1=="shield"&&weapon2=="sledgehammer") {
				MovieClip(this.parent.parent).playFX("Sledgehammer");
			}
			if (weapon1=="shield"&&weapon2=="sword") {
				MovieClip(this.parent.parent).playFX("Shield");
			}
			if (weapon1=="sledgehammer"&&weapon2=="sword") {
				MovieClip(this.parent.parent).playFX("Sword");
			}
			if (weapon1=="sledgehammer"&&weapon2=="shield") {
				MovieClip(this.parent.parent).playFX("Sledgehammer");
			}
			
		}
		private function chooseEnemyAttack():String {
			var enemyAttackName:String;
			var whichAttack:Number=Math.round(Math.random()*2);
			if (whichAttack == 0) {
				whichAttack = 1;
			}
			/* Prevent a tie by removing the user's weapon from the selection pool */
			switch (currentHeroWeapon.name) {
				case "sword" :
					if (whichAttack==1) {
						enemyAttackName="shield";
					} else if (whichAttack == 2) {
						enemyAttackName="sledgehammer";
					}
					break;
				case "shield" :
					if (whichAttack==1) {
						enemyAttackName="sword";
					} else if (whichAttack == 2) {
						enemyAttackName="sledgehammer";
					}
					break;
				case "sledgehammer" :
					if (whichAttack==1) {
						enemyAttackName="shield";
					} else if (whichAttack == 2) {
						enemyAttackName="sword";
					}
					break;
			}


			return enemyAttackName;
		}
		private function letsGetItOn():void {
			totalBattles++;
			/* Determine the enemy's attack */
			var userAttack:String=currentHeroWeapon.name;
			var enemyAttack:String=currentEnemyWeapon.name;
			/* We're going to have pauses between each phase of the attack animation */
			var battleCount:Number=0;
			var battleTimer:Timer=new Timer(battlePause*1000,0);
			battleTimer.addEventListener(TimerEvent.TIMER, advanceBattle);
			battleTimer.start();
			function advanceBattle(event:TimerEvent):void {
				switch (battleCount) {
					case 0 :
						/* Determine the winner */
						var battleResult:String=pickWinner(userAttack,enemyAttack);
						updateStats();
						if (battleResult=="win") {
							combatRound++;
							youWin();
						} else if (battleResult == "lose") {
							combatRound++;
							enemyWins();
						} else if (battleResult == "tie") {
							tieGame();
						}
						showBattleResultText(battleResult);
						break;
					case 1 :
						removeChild(battleResultText);
						resetBattle();
						break;
					case 2 :
						if (combatRound==4) {
							battleTimer.stop();
							battleTimer.removeEventListener(TimerEvent.TIMER, advanceBattle);
							removeOpponent();
							/* Keep your character onscreen if it's the last round */
							if (battleRound!=3) {
								removeHero();
							}
							hideBattleIcons();
							updateGlobalStats();
							advanceGame();
						} else {
							enableAttackMenu();
							battleTimer.stop();
							battleTimer.removeEventListener(TimerEvent.TIMER, advanceBattle);
						}
						break;
					default :
						break;
				}
				battleCount++;
			}
		}
		private function pickWinner(userAttack, enemyAttack):String {
			var battleResult:String = new String();
			if (userAttack==enemyAttack) {
				battleResult="tie";
			} else if (userAttack == "sword"&&enemyAttack!="shield") {
				swordWins++;
				battleResult="win";
			} else if (userAttack == "shield"&&enemyAttack!="sledgehammer") {
				shieldWins++;
				battleResult="win";
			} else if (userAttack == "sledgehammer"&&enemyAttack!="sword") {
				sledgehammerWins++;
				battleResult="win";
			} else if (battleResult!="tie"&&battleResult!="win") {
				battleResult="lose";
			}
			return battleResult;
		}
		private function youWin():void {
			playerWins++;
			heroCharacter.textWins.text="Wins: "+playerWins;
			myDamageFX.x = 700;
			myDamageFX.y = 344;
			addChild(myDamageFX);
		}
		private function enemyWins():void {
			if (battleRound==1) {
				opponent1Wins++;
				enemyCharacter.textWins.text="Wins: "+opponent1Wins;
			}
			if (battleRound==2) {
				opponent2Wins++;
				enemyCharacter.textWins.text="Wins: "+opponent2Wins;
			}
			if (battleRound==3) {
				opponent3Wins++;
				enemyCharacter.textWins.text="Wins: "+opponent3Wins;
			}
			myDamageFX.x = 144;
			myDamageFX.y = 344;
			addChild(myDamageFX);
		}
		private function showBattleResultText(battleResult:String):void {
			battleResultText.x=400;
			battleResultText.y=230;
			battleResultText.resultText.text=String(currentHeroWeapon.name)+" defeats "+String(currentEnemyWeapon.name)+"!";
			switch (battleResult) {
				case "win" :
					battleResultText.resultText.text=String(currentHeroWeapon.name)+" defeats "+String(currentEnemyWeapon.name)+"!";
					break;
				case "lose" :
					battleResultText.resultText.text=String(currentHeroWeapon.name)+" loses to "+String(currentEnemyWeapon.name)+"!";
					break;
				case "tie" :
					battleResultText.resultText.text="tie!";
					break;
			}
			addChild(battleResultText);
		}
		private function tieGame():void {
			totalTies++;
		}
		private function resetBattle():void {
			/* Move the user's weapon back to its slot */
			userAttackXTween2.yoyo();
			userAttackXTween2.addEventListener(TweenEvent.MOTION_FINISH, moveWeaponDown);
			function moveWeaponDown(event:TweenEvent):void {
				userAttackXTween2.removeEventListener(TweenEvent.MOTION_FINISH, moveWeaponDown);
				userAttackYTween.yoyo();
				userAttackYTween.addEventListener(TweenEvent.MOTION_FINISH, moveWeaponToOriginalSlot);
			}
			function moveWeaponToOriginalSlot(event:TweenEvent):void {
				userAttackYTween.removeEventListener(TweenEvent.MOTION_FINISH, moveWeaponToOriginalSlot);
				userAttackXTween1.yoyo();
			}
			/* Hide the enemy's weapon */
			enemyAttackXTween=new Tween(currentEnemyWeapon,"x",Regular.easeIn,currentEnemyWeapon.x,enemyWeaponX1,animationSpeed,true);
		}
		private function removeOpponent():void {
			xEnemyTween.yoyo();
		}
		private function removeHero():void {
			/* We want to keep the hero on the screen for the final ending screen */
			if (battleRound!=4) {
				xHeroTween.yoyo();
			}
			heroCharacter.textWins.visible=false;
		}
		private function showOpponent():void {
			xEnemyTween.yoyo();
		}
		private function showHero():void {
			xHeroTween.yoyo();
			heroCharacter.textWins.visible=true;
		}
		private function hideBattleIcons():void {
			attackMenuTween=new Tween(attackMenu,"alpha",None.easeNone,1,0,animationSpeed,true);
		}
		private function showBattleIcons():void {
			attackMenuTween.yoyo();
		}
		private function advanceGame():void {
			combatRound=1;
			battleRound++;
			if (playerWins>=2) {
				myGameFX.gotoAndStop("Victory");
			} else {
				myGameFX.gotoAndStop("Defeated");
			}
			addChild(myGameFX);
			locationAlphaTween.yoyo();
			namesAlphaTween.yoyo();
			if (battleRound!=4) {
				namesAlphaTween.addEventListener(TweenEvent.MOTION_FINISH, triviaQuestion);
			} else {
				nextRound();
			}
		}
		private function nextRound():void {
			if (battleRound!=4) {
				playMusic();
				chooseOpponent();
				setText();
				showOpponent();
				showHero();
				showBattleIcons();
				locationAlphaTween.yoyo();
				namesAlphaTween.yoyo();
				enableAttackMenu();
				myGameFX.gotoAndStop("Fight");
				addChild(myGameFX);
			} else {
				hideTip();
				endCombat();
			}
		}
		private function endCombat():void {
			makeComment();
			logoAlphaTween.yoyo();
			heroCharacter.textWins.visible=false;
			backgroundXTween = new Tween(battleBackground, "x", Regular.easeInOut, battleBackground.x, battleBackground.x-800, 5, true);
		}
		/* ------------------------------------------------------------------------- Trivia ------------------------------------------------------------ */
		private function triviaQuestion(event:TweenEvent):void {
			namesAlphaTween.removeEventListener(TweenEvent.MOTION_FINISH, triviaQuestion);
			addChild(MovieClip(this.parent.parent).myTriviaScreen);
		}
		public function triviaComplete():void {
			removeChild(MovieClip(this.parent.parent).myTriviaScreen);
			nextRound();
		}
		/* ------------------------------------------------------------------------- Text ------------------------------------------------------------ */
		private function setText():void {
			heroCharacter.textWins.text="Wins: 0";
			enemyCharacter.textWins.text="Wins: 0";
			playerWins=0;
			switch (battleRound) {
				case 1 :
					battleLocation.text="Round "+battleRound+": The Ludus";
					opponentNames.text=goodGuy+" vs "+badGuy;
					break;
				case 2 :
					battleLocation.text="Round "+battleRound+": The Colosseum";
					opponentNames.text=goodGuy+" vs "+badGuy;
					break;
				case 3 :
					battleLocation.text="Round "+battleRound+": The Palace Chamber";
					opponentNames.text=goodGuy+" vs "+badGuy;
					break;
				default :
					break;
			}
		}
		/* ------------------------------------------------------------------------- Battle Statistics ------------------------------------------------------------ */
		private function updateStats():void {
			attackMenu.swordText.text="Wins: "+swordWins;
			attackMenu.shieldText.text="Wins: "+shieldWins;
			attackMenu.sledgehammerText.text="Wins: "+sledgehammerWins;
		}
		private function updateGlobalStats():void {
			if (battleRound==1) {
				if (opponent1Wins>1) {
					battleBackground.results1.text="You were vanquished by "+badGuy;
				} else {
					totalPlayerWins++;
					battleBackground.results1.text="You bested the skills of "+badGuy;
				}
			}
			if (battleRound==2) {
				if (opponent2Wins>1) {
					battleBackground.results2.text=badGuy +" left you broken in the sand";
				} else {
					totalPlayerWins++;
					battleBackground.results2.text="Your swordplay left "+badGuy+" in ruins";
				}
			}
			if (battleRound==3) {
				if (opponent3Wins>1) {
					battleBackground.results3.text=badGuy + " handed you your head";
				} else {
					totalPlayerWins++;
					battleBackground.results3.text="You crushed "+badGuy+ " with ease";
				}
			}
		}
		private function updateEndingScreenImage(myCharacter:String):void {
			var myBadGuy:MovieClip = new MovieClip();
			switch (myCharacter) {
				case "Crixus" :
					myBadGuy.addChild(new Crixus);
					break;
				case "Sura" :
					myBadGuy.addChild(new Sura);
					break;
				case "Lucritia" :
					myBadGuy.addChild(new Lucritia);
					break;
				case "Batiatus" :
					myBadGuy.addChild(new Batiatus);
					break;
				case "Glaber" :
					myBadGuy.addChild(new Glaber);
					break;
				case "Spartacus" :
					myBadGuy.addChild(new Spartacus);
					break;
				case "Doctore" :
					myBadGuy.addChild(new Doctore);
					break;
			}
			if (battleRound==1) {
				battleBackground.opponent1.addChild(myBadGuy);
			}
			if (battleRound==2) {
				battleBackground.opponent2.addChild(myBadGuy);
			}
			if (battleRound==3) {
				battleBackground.opponent3.addChild(myBadGuy);
			}
		}
		private function makeComment():void {
			switch (totalPlayerWins) {
				case 0 :
					battleBackground.comments.text="You lay on the arena floor, a mangled mess. Pray the medicus gets to you in time.";
					battleBackground.fightRecord.text="You won 0 out of 3 matches.";
					playEndingMusic("bad");
					break;
				case 1 :
					battleBackground.comments.text="Only one victory? Your name will surely not adorn the walls of history.";
					battleBackground.fightRecord.text="You won 1 out of 3 matches.";
					playEndingMusic("bad");
					break;
				case 2 :
					battleBackground.comments.text="Victory. Your one loss is but a stain on a record worthy of Jupiter himself.";
					battleBackground.fightRecord.text="You won 2 out of 3 matches.";
					playEndingMusic("good");
					break;
				case 3 :
					battleBackground.comments.text="You are truly a legend in the arena. Your name will go down in history.";
					battleBackground.fightRecord.text="You won 3 out of 3 matches.";
					playEndingMusic("good");
					break;
			}
		}
		/* ------------------------------------------------------------------------- Audio ------------------------------------------------------------ */
		private function playMusic():void {
			MovieClip(this.parent.parent).playMusic("Battle");
		}
		private function playEndingMusic(endingType:String):void {
			if (endingType=="good") {
				MovieClip(this.parent.parent).playMusic("Victory");
			}
			if (endingType=="bad") {
				MovieClip(this.parent.parent).playMusic("Defeat");
			}
		}
	}
}