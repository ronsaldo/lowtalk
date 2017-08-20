visiting
store: value in: pointer
	"| barrier |
	value type isDynamicObjectType ifTrue: [
		barrier := compiler ssaWriteBarrier.
		barrier ifNotNil: [
			^ builder call: barrier arguments: { value . pointer }
		].
	]."

	builder store: value in: pointer