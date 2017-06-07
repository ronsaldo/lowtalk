messages
generatePrimitiveIdentityHashMessage: message receiver: receiver receiverType: receiverType
	self flag: 'Implement myself'.
	^ message type defaultSSAValueWith: builder