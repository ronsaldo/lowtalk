Class {
	#name : #LowtalkUnionType,
	#superclass : #LowtalkStructureType,
	#category : #'Lowtalk-Core-Types'
}

{ #category : #'structure class' }
LowtalkUnionType >> inImageStructureLayoutClass [
	^ SLVMUnionLayout
]

{ #category : #accessing }
LowtalkUnionType >> ssaTypeClass [
	^ SLVMUnionType
]
