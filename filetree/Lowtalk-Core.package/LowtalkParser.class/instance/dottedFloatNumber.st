accessing
dottedFloatNumber
	^ super dottedFloatNumber ==> [ :value |
		LowtalkASTFloatLiteral new
			position: value;
			value: (Float readFrom: value inputValue);
			yourself
	]