package com.starz.functions {
	import com.starz.constants.GawainComments;

	public function GenerateInsult() : String {
		return String(GawainComments.NEGATIVE[Math.ceil(Math.random()*GawainComments.POSITIVE.length)-1]);
	}
}