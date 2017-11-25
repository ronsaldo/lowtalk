*Lowtalk-Core
asLowtalkSlotWith: aCompiler
	^ LowtalkSlot new
			name: name;
			type: aCompiler objectType;
			index: index;
			yourself