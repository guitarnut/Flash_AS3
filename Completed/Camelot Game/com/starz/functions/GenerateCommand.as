package com.starz.functions {
	import com.starz.constants.GawainComments;

	public function GenerateCommand() : String {
		return String(GawainComments.COMMAND[Math.ceil(Math.random()*GawainComments.POSITIVE.length)-1]);
	}
}