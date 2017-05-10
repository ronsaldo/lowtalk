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

		'int =' ieq
		'int ~=' ine
		'int <' ilt
		'int <=' ile
		'int >' igt
		'int >=' ige
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