accessing
privateSlotsTypeIn: anEnvironment at: aNode
	^ (LowtalkObjectSlotsType target: compilationTarget)
		objectType: self;
		accessMode: #__private