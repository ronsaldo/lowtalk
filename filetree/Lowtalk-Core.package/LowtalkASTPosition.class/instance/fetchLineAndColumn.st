accessing
fetchLineAndColumn
	| lineColumn |
	collection ifNil: [
		line := 0.
		column := 0.
		^ self
	].

	lineColumn := collection lineColumnAt: start.
	line := lineColumn first.
	column := lineColumn second.