messages
generatePrivateSlotsMessage: message receiver: receiver receiverType: receiverType
	^ self coerceImplicitly: receiver type: receiverType to: receiverType withoutReferences at: message