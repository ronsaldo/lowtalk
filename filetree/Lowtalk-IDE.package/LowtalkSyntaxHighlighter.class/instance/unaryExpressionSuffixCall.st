accessing
unaryExpressionSuffixCall
	^ super unaryExpressionSuffixCall ==> [ :tokens |
		self commands
			add: (LowtalkHighlightCommandApplyStyle callBracket token: tokens first);
			add: (LowtalkHighlightCommandApplyStyle callBracket token: tokens last)
	]