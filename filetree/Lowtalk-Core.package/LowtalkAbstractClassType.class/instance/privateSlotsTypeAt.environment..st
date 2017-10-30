accessing
privateSlotsTypeAt: aNode environment: anEnvironment
	^ (LowtalkObjectSlotsType target: compilationTarget)
		objectType: self;
		accessMode: #__private