Class {
	#name : #LowtalkPackedStructureType,
	#superclass : #LowtalkStructureType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #'structure class' }
LowtalkPackedStructureType >> inImageStructureLayoutClass [
	^ SLVMPackedStructureLayout
]

{ #category : #accessing }
LowtalkPackedStructureType >> ssaTypeClass [
	^ SLVMPackedStructureType
]
