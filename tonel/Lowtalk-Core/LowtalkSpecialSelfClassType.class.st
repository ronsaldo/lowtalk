Class {
	#name : #LowtalkSpecialSelfClassType,
	#superclass : #LowtalkSpecialGenericType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkSpecialSelfClassType >> evaluateInEnvironment: environment at: node [
	^ environment receiverType metaClass
]

{ #category : #'as yet unclassified' }
LowtalkSpecialSelfClassType >> evaluateSelfInstanceTypeInEnvironment: environment at: node [
	^ environment receiverType
]

{ #category : #methods }
LowtalkSpecialSelfClassType >> methodSignatureForSelector: selector environment: environment [
	^ environment receiverType ifNotNil: [ :receiver |
		receiver metaClass ifNotNil: [ :meta | meta methodSignatureForSelector: selector environment: environment ]
	]
]

{ #category : #accessing }
LowtalkSpecialSelfClassType >> name [
	^ #_SelfClassType
]

{ #category : #'as yet unclassified' }
LowtalkSpecialSelfClassType >> solveSpecialTypeWithReceiverNode: receiverNode type: receiverType environment: environment at: node [
	(receiverNode isSelf or: [ receiverNode isSuper ]) ifTrue: [
		^ self
	].
	^ receiverType evaluateSelfClassTypeInEnvironment: environment at: node
]
