accessing
unaryExpressionSuffixCall
	^ super unaryExpressionSuffixCall ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle callBracket token: tokens first);
			add: (PhanideHighlightCommandStyle callBracket token: tokens last)
	]