*Lowtalk-Core
asLowtalkSlotWith: aCompiler
	^ LowtalkSlot new
			name: self;
			type: aCompiler objectType;
			yourself