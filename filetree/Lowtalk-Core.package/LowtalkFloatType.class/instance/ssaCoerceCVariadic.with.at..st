coercions
ssaCoerceCVariadic: value with: builder at: node
	value type size = 4 ifTrue: [ ^ builder floatingPointCast: value target: builder compilationTarget double].
	^ value