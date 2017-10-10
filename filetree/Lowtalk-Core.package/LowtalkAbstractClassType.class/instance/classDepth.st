testing
classDepth
	| result position |
	result := 0.
	position := self.
	[ position ] whileNotNil: [
		result := result + 1.
		position := position superclass.
	].
	^ result