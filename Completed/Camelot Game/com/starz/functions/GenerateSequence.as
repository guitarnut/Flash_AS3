package com.starz.functions
{
	import com.starz.constants.BattleSequences;

	public function GenerateSequence(type:String):Array
	{
		var sequence:Array;
		switch (type)
		{
			case "Easy" :
				sequence = BattleSequences.EASY[Math.ceil(Math.random() * BattleSequences.EASY.length) - 1];
				break;
			case "Medium" :
				sequence = BattleSequences.MEDUIM[Math.ceil(Math.random() * BattleSequences.MEDUIM.length) - 1];
				break;
			case "Hard" :
				sequence = BattleSequences.HARD[Math.ceil(Math.random() * BattleSequences.HARD.length) - 1];
				break;
		}
		return sequence;
	}
}