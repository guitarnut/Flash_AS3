package com.starz.functions {
	import com.starz.constants.GawainComments;

	public function GenerateCompliment() : String {
		return String(GawainComments.POSITIVE[Math.ceil(Math.random()*GawainComments.POSITIVE.length)-1]);
	}
}