Extension { #name : #Context }

{ #category : #'*Lowtalk-Core' }
Context >> lowtalkContext [
	(method hasPragmaNamed: #lowtalkEnvironmentHolder) ifTrue: [
		^ receiver environment
	].

	^ sender ifNotNil: [ sender lowtalkContext ]
]
