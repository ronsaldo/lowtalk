Class {
	#name : #LowtalkSpecialSelfType,
	#superclass : #LowtalkSpecialGenericType,
	#category : #'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkSpecialSelfType >> evaluateInEnvironment: environment at: node [
	^ environment receiverType
]

{ #category : #testing }
LowtalkSpecialSelfType >> isSpecialSelfType [
	^ true
]

{ #category : #methods }
LowtalkSpecialSelfType >> methodSignatureForSelector: selector environment: environment [
	^ environment receiverType ifNotNil: [ :receiver | receiver methodSignatureForSelector: selector environment: environment]
]

{ #category : #accessing }
LowtalkSpecialSelfType >> name [
	^ #_SelfType
]

{ #category : #'as yet unclassified' }
LowtalkSpecialSelfType >> solveSpecialTypeWithReceiverNode: receiverNode type: receiverType environment: environment at: node [
	(receiverNode isSelf or: [ receiverNode isSuper ]) ifTrue: [
		^ self
	].
	^ receiverType evaluateSelfTypeInEnvironment: environment at: node
]
