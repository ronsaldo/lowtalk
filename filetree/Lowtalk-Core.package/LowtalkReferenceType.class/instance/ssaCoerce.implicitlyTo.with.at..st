coercions
ssaCoerce: value implicitlyTo: targetType with: builder at: node
	(referenced canBeImplicitlyConvertedTo: targetType) ifTrue: [
		referenced isArrayType ifTrue: [ ^ value ].
		referenced isFunctionType ifTrue: [ ^ value ].
		(referenced isBlockType and: [ value isFunction ]) ifTrue: [ ^ value ].
		(referenced isBlockType and: [ value isCompiledMethodMetaData ]) ifTrue: [ ^ value sourceMethod ].
		
		^ referenced ssaCoerce: (builder load: value) implicitlyTo: targetType with: builder at: node
	].

	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node