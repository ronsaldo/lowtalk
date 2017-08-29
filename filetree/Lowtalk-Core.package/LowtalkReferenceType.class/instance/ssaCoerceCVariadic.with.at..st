coercions
ssaCoerceCVariadic: value with: builder at: node
	self assert: referenced isReferenceType not.
	^ referenced ssaCoerceCVariadic: (builder load: value) with: builder at: node