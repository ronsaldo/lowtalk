accessing
typeBinaryExpression
	^ super typeBinaryExpression ==> [ :list |
		| result |
		result := list first.
		list second do: [ :binaryMessage |
			result := LowtalkASTMessage new
				position: binaryMessage first;
				receiver: result;
				selector: binaryMessage first inputValue asSymbol;
				arguments: { binaryMessage second };
				yourself
		].
		result
	]