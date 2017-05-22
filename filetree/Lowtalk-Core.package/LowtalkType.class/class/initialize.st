initialization
initialize
	super initialize.
	
	CommonSpecialMessages := Dictionary newFromPairs: #(
		+ Arithmetic
		- Arithmetic
		* Arithmetic
		/ Arithmetic
		
		negated UnaryArithmeric

		| BinaryBitwise
		bitOr: BinaryBitwise
		& BinaryBitwise
		bitAnd: BinaryBitwise
		bitXor: BinaryBitwise
		
		bitInvert UnaryLogicalBitwise
		bitInvert32 UnaryLogicalBitwise
		
		== IdentityEquality
		~~ IdentityEquality
		
		= Equality
		~= Equality
		
		< Comparison
		<= Comparison
		> Comparison
		>= Comparison

		ifTrue: IfSelection
		ifFalse: IfSelection
		ifNil: IfSelection
		ifNotNil: IfSelection

		ifTrue:ifFalse: IfSelection
		ifFalse:ifTrue: IfSelection
		ifNil:ifNotNil: IfSelection
		ifNotNil:ifNil: IfSelection
		
		to:do: RangeLoop
		to:by:do: RangeLoop
		
		castTo: CastTo
		
		yourself Yourself
	).
	
	BlockSpecialMessages  := Dictionary newFromPairs: #(
		whileTrue WhileLoop
		whileTrue: WhileLoop
		whileFalse WhileLoop
		whileFalse: WhileLoop
		whileNotNil: WhileLoop
		whileNil: WhileLoop
	).
