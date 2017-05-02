accessing
integerNumber
	^ super integerNumber ==> [ :value |
		| content radix sign valueContent|
		content := value inputValue.
		(content includes: $r) ifTrue: [ 
			sign := content first = $- ifTrue: [ -1 ] ifFalse: [ 1 ].
			radix := (content first = $- ifTrue: [ content allButFirst ] ifFalse: [ content ]) asInteger.
			valueContent := content allButFirst: (content indexOf: $r).
			LowtalkASTIntegerLiteral new
				position: value;
				value: (Integer readFrom: valueContent base: radix) * sign;
				yourself
		] ifFalse: [ 
			LowtalkASTIntegerLiteral new
				position: value;
				value: content asInteger;
				yourself
		]
	]