as yet unclassified
convertSlots
	| myObjectSlots myNativeSlots |
	myObjectSlots := objectSlots.
	myNativeSlots := nativeSlots.
	self superclass ifNotNil: [ :sc |
		myObjectSlots := myObjectSlots allButFirst: sc objectSlots size.
		myNativeSlots := myNativeSlots allButFirst: sc nativeSlots size.
	].
	
	^ (myObjectSlots collect: #asInstanceVariableSlot) ,
	  (myNativeSlots collect: #asSLVMStructureFieldSlot)
