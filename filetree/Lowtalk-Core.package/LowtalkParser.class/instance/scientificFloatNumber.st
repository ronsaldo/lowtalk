accessing
scientificFloatNumber
	^ super scientificFloatNumber ==> [ :value |
		LowtalkASTFloatLiteral new
			position: value;
			value: (Float readFrom: value inputValue);
			yourself
	]