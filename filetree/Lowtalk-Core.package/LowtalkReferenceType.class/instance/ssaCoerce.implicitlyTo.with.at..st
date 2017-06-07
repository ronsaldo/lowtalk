coercions
ssaCoerce: value implicitlyTo: targetType with: builder at: node
	(referenced canBeImplicitlyConvertedTo: targetType) ifTrue: [
		referenced isFunctionType ifTrue: [ ^ value ].
		(referenced isBlockType and: [ value isFunction ]) ifTrue: [ ^ value ].
		^ referenced ssaCoerce: (builder load: value) implicitlyTo: targetType with: builder at: node
	].

	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node