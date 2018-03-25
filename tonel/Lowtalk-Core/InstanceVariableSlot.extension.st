Extension { #name : #InstanceVariableSlot }

{ #category : #'*Lowtalk-Core' }
InstanceVariableSlot >> asLowtalkSlotWith: aCompiler [
	^ LowtalkSlot new
			name: name;
			type: aCompiler objectType;
			index: index;
			yourself
]
