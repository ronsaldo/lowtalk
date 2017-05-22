messages
generateCastToMessage: message receiver: receiver receiverType: receiverType
	^ receiverType ssaConvert: receiver explicitlyTo: message type with: builder at: message