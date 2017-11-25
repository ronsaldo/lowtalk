*Lowtalk-Core
lowtalkContext
	(method hasPragmaNamed: #lowtalkEnvironmentHolder) ifTrue: [
		^ receiver environment
	].

	^ sender ifNotNil: [ sender lowtalkContext ]