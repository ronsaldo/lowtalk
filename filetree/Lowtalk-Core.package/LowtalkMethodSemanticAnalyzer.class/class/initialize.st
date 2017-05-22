initialization
initialize
	BlockMessages := Dictionary newFromPairs: #(
		whileTrue WhileLoop
		whileTrue: WhileLoop
		whileFalse WhileLoop
		whileFalse: WhileLoop
		whileNotNil: WhileLoop
		whileNil: WhileLoop
	).
	
	BooleanControlFlowMessages := Set newFrom: #(
		ifTrue:
		ifFalse:
		
		ifTrue:ifFalse:
		ifFalse:ifTrue:
		
		whileTrue
		whileTrue:
		whileFalse
		whileFalse:
	).