as yet unclassified
convertSlots
	^ (objectSlots collect: [ :slot | InstanceVariableSlot named: slot name ]) ,
	  (nativeSlots collect: [:slot | self halt ])
