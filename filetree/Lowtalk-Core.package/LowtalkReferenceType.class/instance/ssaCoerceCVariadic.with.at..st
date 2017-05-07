coercions
ssaCoerceCVariadic: value with: builder at: node
	self assert: referenced isReferenceType not.
	^ builder load: value