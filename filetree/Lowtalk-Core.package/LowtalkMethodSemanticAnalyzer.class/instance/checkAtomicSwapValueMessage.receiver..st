special messages
checkAtomicSwapValueMessage: message receiver: receiver
	| pointerType pointedType value valueType |
	pointerType := receiver type.
	pointerType isPointerType ifFalse: [
		message semanticError: 'Expected a pointer type to perform atomic operation'.
	].

	pointedType := pointerType pointed.
	pointedType readOnly ifTrue: [ 
		message semanticError: 'Modifying a read-only value.'.
	].

	"Check the value type"
	value := message arguments first.
	self visitNode: value.
	valueType := value type withoutReferences.
	(valueType canBeImplicitlyConvertedTo: pointedType) ifFalse: [
		message semanticError: 'Cannot implicitly convert value of type "{1}" to type "{2}".' format: { valueType name . pointedType }
	].
	
	message type: pointedType.