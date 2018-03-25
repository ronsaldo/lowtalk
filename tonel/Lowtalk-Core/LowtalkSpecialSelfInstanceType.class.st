Class {
	#name : #LowtalkSpecialSelfInstanceType,
	#superclass : #LowtalkSpecialGenericType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkSpecialSelfInstanceType >> evaluateInEnvironment: environment at: node [
	^ environment receiverType instanceOrNil ifNil: [ environment compiler objectType ]
]

{ #category : #'as yet unclassified' }
LowtalkSpecialSelfInstanceType >> evaluateSelfClassTypeInEnvironment: environment at: node [
	^ environment receiverType
]

{ #category : #methods }
LowtalkSpecialSelfInstanceType >> methodSignatureForSelector: selector environment: environment [
	^ environment receiverType ifNotNil: [ :receiver |
		receiver instanceOrNil ifNotNil: [ :instance | instance methodSignatureForSelector: selector environment: environment ]
	]
]

{ #category : #accessing }
LowtalkSpecialSelfInstanceType >> name [
	^ #_SelfInstanceType
]

{ #category : #'as yet unclassified' }
LowtalkSpecialSelfInstanceType >> solveSpecialTypeWithReceiverNode: receiverNode type: receiverType environment: environment at: node [
	(receiverNode isSelf or: [ receiverNode isSuper ]) ifTrue: [
		^ self
	].
	^ receiverType evaluateSelfInstanceTypeInEnvironment: environment at: node
]
