initialization
initialize
	super initialize.
	
	BinaryOperationMap := Dictionary newFromPairs: #(
		'uint +' add
		'uint -' sub
		'uint *' mul
		'uint //' udiv
		'uint \\' urem
		'uint %' urem
		
		'uint ==' ieq
		'uint ~~' ine
		'uint =' ieq
		'uint ~=' ine
		'uint <' ult
		'uint <=' ule
		'uint >' ugt
		'uint >=' uge

		'pointer ==' ieq
		'pointer ~~' ine
		'pointer =' ieq
		'pointer ~=' ine
		'pointer <' ult
		'pointer <=' ule
		'pointer >' ugt
		'pointer >=' uge
		
		'int +' add
		'int -' sub
		'int *' mul
		'int //' div
		'int \\' rem
		'int %' rem

		'int ==' ieq
		'int ~~' ine
		'int =' ieq
		'int ~=' ine
		'int <' ilt
		'int <=' ile
		'int >' igt
		'int >=' ige
		
		'uint &' bitand
		'uint bitAnd:' bitand
		'uint |' bitor
		'uint bitOr:' bitor
		'uint ^' bitxor
		'uint bitXor:' bitxor
		'uint <<' shiftleft
		'uint >>' shiftright

		'int &' bitand
		'int bitAnd:' bitand
		'int |' bitor
		'int bitOr:' bitor
		'int ^' bitxor
		'int bitXor:' bitxor
		'int <<' shiftleft
		'int >>' shiftrightarithmetic
		
		'object ==' dynObjectIdentityEquals
		'object ~~' dynObjectIdentityNotEquals
		
		'float +' fadd
		'float -' fsub
		'float *' fmul
		'float /' fdiv
		'float \\'frem

		'float =' ofeq
		'float ~=' ofne
		'float <' oflt
		'float <=' ofle
		'float >' ofgt
		'float >='ofge
	).
	
	MessageConditionTypes := Dictionary newFromPairs: #(
		ifTrue: true
		ifFalse: false
		ifTrue:ifFalse: true
		ifFalse:ifTrue: false

		ifNil: nil
		ifNotNil: 0
		ifNil:ifNotNil: nil
		ifNotNil:ifNil: 0
		
		whileTrue true
		whileFalse false
		whileTrue: true
		whileFalse: false
		whileNil: nil
		whileNotNil: 0
	).
	
	BlockMessages := Dictionary newFromPairs: #(
		whileTrue WhileLoop
		whileTrue: WhileLoop
		whileFalse WhileLoop
		whileFalse: WhileLoop
		whileNotNil: WhileLoop
		whileNil: WhileLoop
	).
	
	InlinedThisContextMessages := Dictionary newFromPairs: #(
		uncheckedReplaceFunctionWith: UncheckedReplaceFunctionWith
	)