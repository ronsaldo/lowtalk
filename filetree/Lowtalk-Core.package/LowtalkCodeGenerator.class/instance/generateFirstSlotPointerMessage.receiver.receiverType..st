messages
generateFirstSlotPointerMessage: message receiver: receiver receiverType: receiverType
	"Get the receiver value"
	| receiverValueType receiverValue result resultType expectedResultType |
	receiverValueType := receiverType withoutReferences.
	receiverValue := self coerceImplicitly: receiver type: receiverType to: receiverValueType at: message.
	
	"Get the receiver first field pointer"
	result := builder getReference: receiverValue element: (SLVMConstantValue int: 0).
	resultType := compiler objectType pointer.
	expectedResultType := message type.
	^ resultType ssaConvert: result explicitlyTo: expectedResultType with: builder at: message