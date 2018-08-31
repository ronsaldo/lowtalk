Class {
	#name : #LowtalkTypeSharedPool,
	#superclass : #SharedPool,
	#classVars : [
		'BlockSpecialMessages',
		'CommonSpecialMessages',
		'CommonTypeSpecialMessages',
		'DynamicObjectSpecialMessages'
	],
	#category : #'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkTypeSharedPool class >> blockSpecialMessages [
	^ BlockSpecialMessages
]

{ #category : #accessing }
LowtalkTypeSharedPool class >> commonSpecialMessages [
	^ CommonSpecialMessages
]

{ #category : #accessing }
LowtalkTypeSharedPool class >> commonTypeSpecialMessages [
	^ CommonTypeSpecialMessages
]

{ #category : #initialization }
LowtalkTypeSharedPool class >> initialize [
	super initialize.
	
	CommonTypeSpecialMessages := Dictionary newFromPairs: #(
		size TypeSizeQuery
		alignment TypeSizeQuery
	).
	
	CommonSpecialMessages := Dictionary newFromPairs: #(
		+ Arithmetic
		- Arithmetic
		* Arithmetic
		/ Arithmetic
		// Arithmetic
		\\ Arithmetic
		
		negated UnaryArithmetic
		sqrt UnaryArithmetic

		| BinaryBitwise
		bitOr: BinaryBitwise
		& BinaryBitwise
		bitAnd: BinaryBitwise
		bitXor: BinaryBitwise

		bitShift: SignedDirectionBitShift
		>> BinaryBitwise
		<< BinaryBitwise
		bitRotateLeft: BinaryBitwise
		bitRotateRight: BinaryBitwise
		
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
		
		and: And
		or: Or
		not Not

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
		reinterpretCastTo: ReinterpretCastTo
		
		yourself Yourself
		
		__private Invalid
		firstFixedFieldPointer 			Invalid
		firstFixedFieldPointerOfType:  Invalid
	).
	
	BlockSpecialMessages  := Dictionary newFromPairs: #(
		whileTrue WhileLoop
		whileTrue: WhileLoop
		whileFalse WhileLoop
		whileFalse: WhileLoop
		whileNotNil: WhileLoop
		whileNil: WhileLoop
	).

	DynamicObjectSpecialMessages := Dictionary newFromPairs: #(
		firstFixedFieldPointer 			FirstSlotPointer
		firstFixedFieldPointerOfType:  FirstSlotPointer
	)
]
