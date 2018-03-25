Extension { #name : #Object }

{ #category : #'*Lowtalk-Core' }
Object >> asLowtalkImportedValueWith: aCompiler [
	^ self
]

{ #category : #'*Lowtalk-Core' }
Object >> asLowtalkTypeIn: typeExpression [
	typeExpression semanticError: 'Expected a type expression.'
]

{ #category : #'*Lowtalk-Core' }
Object >> asLowtalkVariableSlot [
	^ LowtalkVariableSlot new value: self
]

{ #category : #'*Lowtalk-Core' }
Object >> inferLowtalkTypeWith: aCompiler [
	^ aCompiler objectType
]

{ #category : #'*Lowtalk-Core' }
Object >> isLowtalkBObject [
	^ false
]

{ #category : #'*Lowtalk-Core' }
Object >> isLowtalkType [
	^ false
]

{ #category : #'*Lowtalk-Core' }
Object >> lowtalkConvertToObjectAt: aNode [
	self
]

{ #category : #'*Lowtalk-Core' }
Object >> lowtalkDispatchSelector: selector arguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler [
	^ sendingNode semanticError: 'Compile time expression calling unexistent selector {1}' format: { selector printString}.
]

{ #category : #'*Lowtalk-Core' }
Object >> lowtalkDispatchSelector: selector lazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler [
	^ sendingNode semanticError: 'Compile time expression calling unexistent selector {1}' format: { selector printString}.
]

{ #category : #'*Lowtalk-Core' }
Object >> lowtalkInferTypeForNodeType: nodeType [
	^ nodeType
]

{ #category : #'*Lowtalk-Core' }
Object >> lowtalkLiteralTypeWith: aLowtalkCompiler [
	^ aLowtalkCompiler objectType
]

{ #category : #'*Lowtalk-Core' }
Object >> lowtalkPerform: selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler [
	^ LowtalkWhiteList dispatchSelector: selector receiver: self arguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler
]

{ #category : #'*Lowtalk-Core' }
Object >> lowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler [
	^ LowtalkWhiteList dispatchSelector: selector receiver: self lazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler
]

{ #category : #'*Lowtalk-Core' }
Object >> lowtalkStoreValueIntoSlot: slot [
	slot value: self.
	^ self
]

{ #category : #'*Lowtalk-Core' }
Object >> lowtalkValueWithArguments: evaluationArguments types: evaluationArgumentTypes compiler: aLowtalkCompiler at: aNode [
	^ self valueWithArguments: (evaluationArguments collectWithIndex: [:arg :index |
		(evaluationArgumentTypes at: index) convertValue: arg toType: aLowtalkCompiler objectType at: aNode
		])
]
