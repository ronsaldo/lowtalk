testing
isSubclassOf: anotherType
	| position |
	position := self.
	self ~~ anotherType ifTrue: [
		self halt
	].

	[ position ] whileNotNil: [
		position == anotherType ifTrue: [ ^ true ].
		position := position superclass.
	].
	^ false