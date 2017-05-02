accessing
unaryExpression
	^ super unaryExpression ==> [ :list |
		| result |
		result := list first.
		list second do: [ :unaryMessage |
			result := LowtalkASTMessage new
				position: unaryMessage;
				receiver: result;
				selector: unaryMessage inputValue asSymbol;
				arguments: #();
				yourself
		].
		result
	]