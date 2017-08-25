coercions
ssaCoerce: value implicitlyTo: targetType with: builder at: node
	(referenced canBeImplicitlyConvertedTo: targetType) ifTrue: [
		referenced isArrayType ifTrue: [ ^ value ].
		referenced isFunctionType ifTrue: [ ^ value ].
		(referenced isBlockType and: [ value isFunction ]) ifTrue: [ ^ value ].
		(referenced isBlockType and: [ value isCompiledMethodMetaData ]) ifTrue: [ ^ value sourceMethod ].
		
		^ referenced ssaCoerce: (builder load: value) implicitlyTo: targetType with: builder at: node
	].

	(referenced isArrayType and: [ targetType isPointerType and: [ referenced baseType = targetType pointed ] ]) ifTrue: [
		^ builder getReference: value element: (builder constInt: 0)
	].

	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node