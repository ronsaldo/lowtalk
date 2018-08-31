Class {
	#name : #LowtalkWhiteList,
	#superclass : #LowtalkBObject,
	#classVars : [
		'AddedMethods',
		'OverridenMethods',
		'SelectorsAlwaysAllowed'
	],
	#category : #'Lowtalk-Core-Environment'
}

{ #category : #overrides }
LowtalkWhiteList class >> atOffsetPut: selector receiver: receiver arguments: arguments inSuperclass: isInSuperclass node: aNode compiler: aCompiler [
	| index value |
	self assert: arguments size = 2.
	index := arguments first value + 1.
	value := arguments second value.
	^ receiver lowtalkPerform: #at:put: withLazyArguments: { index . value } inSuperclass: isInSuperclass node: aNode compiler: aCompiler
]

{ #category : #overrides }
LowtalkWhiteList class >> castTo: selector receiver: receiver arguments: arguments inSuperclass: isInSuperclass node: aNode compiler: aCompiler [
	| targetType receiverType |
	self assert: arguments size = 1.
	targetType := arguments first value asLowtalkTypeIn: aNode.
	receiverType := receiver lowtalkLiteralTypeWith: aCompiler.
	^ receiverType convertValue: receiver toType: targetType at: aNode
]

{ #category : #'as yet unclassified' }
LowtalkWhiteList class >> checkMethod: method receiver: receiver node: sendingNode [
	| selector |
	(OverridenMethods includesKey: method) ifTrue: [ ^ self ].
	selector := method selector.
	
	(method hasPragmaNamed: #compileTime) ifTrue: [ ^ self ].
	(SelectorsAlwaysAllowed includes: selector) ifTrue: [ ^ self ].

	^ sendingNode semanticError: 'Compile time expression calling unsupported selector {1}' format: { selector }.
]

{ #category : #overrides }
LowtalkWhiteList class >> createSlotNamedOverrideSelector: selector receiver: receiver arguments: arguments inSuperclass: theSuperclass node: node compiler: aCompiler [
	| slotType |
	slotType := arguments first value.
	^ slotType slot name: receiver 
]

{ #category : #'as yet unclassified' }
LowtalkWhiteList class >> dispatchSelector: selector receiver: receiver arguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler [
	| method actualSuperClass |
	superClass == true ifTrue: [ 
		actualSuperClass := receiver class superclass.
	] ifFalse: [
		superClass == false ifTrue: [ 
			actualSuperClass := receiver class.
		] ifFalse: [ 
			actualSuperClass := superClass.
		]
	].

	AddedMethods at: selector ifPresent: [ :override |
		^ self perform: override withArguments:
			{ selector . receiver .
				LowtalkLazyValue zipValues: arguments types: argumentTypes node: sendingNode.
				actualSuperClass . sendingNode . aCompiler}
	].

	method := actualSuperClass lookupSelector: selector.
	method ifNil: [
		^ receiver lowtalkDispatchSelector: selector arguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler
	].

	aCompiler isSandboxed ifTrue: [ 
		self checkMethod: method receiver: receiver node: sendingNode.
	]. 
	
	OverridenMethods at: method ifPresent: [ :override |
		^ self perform: override withArguments: { selector . receiver .
		(LowtalkLazyValue zipValues: arguments types: argumentTypes node: sendingNode).
		actualSuperClass . sendingNode . aCompiler}
	].

	(method hasPragmaNamed: #lazy) ifTrue: [
		^ receiver perform: selector withArguments: (LowtalkLazyValue zipValues: arguments types: argumentTypes node: sendingNode) inSuperclass: actualSuperClass
	] ifFalse: [
		^ receiver perform: selector withArguments: arguments inSuperclass: actualSuperClass
	]
]

{ #category : #'as yet unclassified' }
LowtalkWhiteList class >> dispatchSelector: selector receiver: receiver lazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler [
	| method |
	AddedMethods at: selector ifPresent: [ :override |
		^ self perform: override withArguments: { selector . receiver . arguments . superClass . sendingNode . aCompiler}
	].

	method := superClass lookupSelector: selector.
	method ifNil: [
		^ receiver lowtalkDispatchSelector: selector lazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler
	].

	self checkMethod: method receiver: receiver node: sendingNode.
	
	OverridenMethods at: method ifPresent: [ :override |
		^ self perform: override withArguments: { selector . receiver . arguments . superClass . sendingNode . aCompiler}
	].

	(method hasPragmaNamed: #lazy) ifTrue: [
		^ receiver perform: selector withArguments: arguments inSuperclass: superClass
	] ifFalse: [
		^ receiver perform: selector withArguments: (arguments collect: #value) inSuperclass: superClass
	]
]

{ #category : #overrides }
LowtalkWhiteList class >> hash: selector receiver: receiver arguments: arguments inSuperclass: isInSuperclass node: aNode compiler: aCompiler [
	| targetType receiverType |
	self assert: arguments size = 0.
	receiver isString ifTrue: [
		 ^ String stringHash: receiver initialHash: 0
	].

	^ receiver hash
]

{ #category : #overrides }
LowtalkWhiteList class >> identityHash: selector receiver: receiver arguments: arguments inSuperclass: isInSuperclass node: aNode compiler: aCompiler [
	self assert: arguments size = 0.
	receiver isSymbol ifTrue: [
		^ aCompiler objectModel truncateIdentityHash: (self hash: selector receiver: receiver arguments: arguments inSuperclass: isInSuperclass node: aNode compiler: aCompiler)
	].

	^ aCompiler objectModel truncateIdentityHash: receiver identityHash
]

{ #category : #initialization }
LowtalkWhiteList class >> initialize [
	SelectorsAlwaysAllowed := Set newFrom: #(
		yourself
		
		"Conversions"
		asArray
		asSymbol
		asString
		asInteger
		asFloat
		
		"Comparisons"
		= ==
		~= ~~
		hash
		identityHash
		
		"Copy"
		copy
		copyWith:
		
		"Arithmetic"
		+ - * / % * // \\ sqrt
		< <= > >=
		negated
		
		bitAnd: bitOr: bitXor:
		bitInvert bitInvert32
		bitShift
		<< >> | &
		
		or: and:
		min: max:
		
		"Collection accessors"
		basicSize size
		basicAt: at:
		basicAt:put: at:put:
		
		at:ifAbsent:
		at:ifAbsentPut:
		at:ifPresent:
		at:ifPresent:ifAbsent:
		at:ifPresent:ifAbsentPut:
		
		"Collection iteration"
		associationsDo:
		keysAndValuesDo:
		do:
		to:by:
		to:by:do:
		to:do:
		
		collect:
		select:
		select:thenDo:
		select:thenCollect:
		
		includes:
		
		"String splitting"
		splitOn:
		
		"Sequences operations"
		,
	).

	AddedMethods := Dictionary newFromPairs: #(
		#basicAtOffset: #basicAtOffset:receiver:arguments:inSuperclass:node:compiler:
		#basicAtOffset:put: #basicAtOffsetPut:receiver:arguments:inSuperclass:node:compiler:
		#atOffset: #atOffset:receiver:arguments:inSuperclass:node:compiler:
		#atOffset:put: #atOffsetPut:receiver:arguments:inSuperclass:node:compiler:

		#castTo: #castTo:receiver:arguments:inSuperclass:node:compiler:
		#identityHash #identityHash:receiver:arguments:inSuperclass:node:compiler:
	).
	
	OverridenMethods := Dictionary newFromPairs: { 
		Symbol >> #=> . #createSlotNamedOverrideSelector:receiver:arguments:inSuperclass:node:compiler:
	}.
	
]
