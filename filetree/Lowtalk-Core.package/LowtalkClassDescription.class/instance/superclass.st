accessing
superclass
	| superObject |
	superObject :=  classObject slots at: compiler objectModel superClassSlotIndex.
	^ superObject ifNotNil: [ compiler objectModel getClassDescription: superObject ]