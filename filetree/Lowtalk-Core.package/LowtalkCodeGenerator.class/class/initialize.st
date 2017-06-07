initialization
initialize
	super initialize.
	
	BinaryOperationMap := Dictionary newFromPairs: #(
		'uint +' add
		'uint -' sub
		'uint *' mull
		'uint //' udiv
		'uint \\' urem
		'uint %' urem
		
		'uint ==' ieq
		'uint ~~' ine
		'uint =' ieq
		'uint ~=' ine
		'uint <' ilt
		'uint <=' ile
		'uint >' igt
		'uint >=' ige
		
		'int +' add
		'int -' sub
		'int *' mull
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

		'int &' bitand
		'int bitAnd:' bitand
		'int |' bitor
		'int bitOr:' bitor
		'int ^' bitxor
		'int bitXor:' bitxor
		
		'object ==' dynObjectIdentityEquals
		'object ~~' dynObjectIdentityNotEquals
	).
	
	MessageConditionTypes := Dictionary newFromPairs: #(
		ifTrue: true
		ifFalse: false
		ifTrue:ifFalse: true
		ifFalse:ifTrue: false

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