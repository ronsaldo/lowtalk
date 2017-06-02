messages
generateReinterpretCastToMessage: message receiver: receiver receiverType: receiverType
	| receiverValue |
	receiverValue := self coerceImplicitly: receiver type: receiverType to: receiverType withoutReferences at: message.
	^ builder bitCast: receiverValue target: message type ssaType