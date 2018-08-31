Class {
	#name : #LowtalkCompiledMethodGenerator,
	#superclass : #LowtalkASTVisitor,
	#instVars : [
		'compiler',
		'irBuilder',
		'usedNames',
		'usedNameCount',
		'selfType',
		'method',
		'gensymCount',
		'normalReturnMethod'
	],
	#classVars : [
		'BlockMessages'
	],
	#category : #'Lowtalk-Core-Interpreter'
}

{ #category : #initialization }
LowtalkCompiledMethodGenerator class >> initialize [
	
	BlockMessages := Dictionary newFromPairs: #(
		whileTrue WhileLoop
		whileTrue: WhileLoop
		whileFalse WhileLoop
		whileFalse: WhileLoop
		whileNotNil: WhileLoop
		whileNil: WhileLoop
	).
]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> coerceImplicitlyFrom: sourceType to: targetType at: node [
	sourceType irCoerceImplicitlyTo: targetType with: irBuilder at: node
]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> coerceInlineBlock: blockNode resultInto: targetType [
	blockNode isBlockNode ifFalse: [ 
		self halt.
	].

	self coerceImplicitlyFrom: blockNode returnType to: targetType at: blockNode
]

{ #category : #'inline messages' }
LowtalkCompiledMethodGenerator >> compileInlineWhileMessage: message [
	| doneCondition |
	self assert: message arguments size <= 1.
	
	irBuilder jumpBackTarget: #whileLoopCondition.
	self inlineBlock: message receiver.
	
	doneCondition := false.
	(#(whileTrue whileTrue: whileFalse whileFalse:) includes: message selector) ifTrue: [ 
		self coerceInlineBlock: message receiver resultInto: compiler booleanType.
		doneCondition := #(whileFalse whileFalse:) includes: message selector
	] ifFalse: [ 
		self assert: (#(whileNotNil: whileNil:) includes: message selector).
		irBuilder pushLiteral: nil.
		message selector == #whileNotNil: ifTrue: [ 
			irBuilder send: #~~.
		] ifFalse: [ 
			irBuilder send: #==.
		].
	].
	
	irBuilder jumpAheadTo: #whileDone if: doneCondition.

	message arguments size = 1 ifTrue: [
		self inlineBlock: message arguments first.
		irBuilder popTop
	].

	irBuilder jumpBackTo: #whileLoopCondition.
	irBuilder jumpAheadTarget: #whileDone.
	irBuilder pushLiteral: nil.

]

{ #category : #accessing }
LowtalkCompiledMethodGenerator >> compiler [
	^ compiler
]

{ #category : #accessing }
LowtalkCompiledMethodGenerator >> compiler: anObject [
	compiler := anObject.
	self assert: compiler class == LowtalkCompiler
]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> convertExplicitlyFrom: sourceType to: targetType at: node [
	sourceType irConvertExplicitlyTo: targetType with: irBuilder at: node
]

{ #category : #'as yet unclassified' }
LowtalkCompiledMethodGenerator >> convertTemporaryName: temporaryName [
	| result |
	result := temporaryName.
	[usedNames includes: result] whileTrue: [
		result := result , usedNameCount asString.
		usedNameCount := usedNameCount + 1.
	].
	result := result asSymbol.
	usedNames add: result.
	^ result
]

{ #category : #'inline messages' }
LowtalkCompiledMethodGenerator >> generateAndMessage: message receiverType: receiverType inSuperclass: inSuperclass [
	self convertExplicitlyFrom: receiverType to: compiler booleanType at: message.
	irBuilder jumpAheadTo: #else if: true.
	irBuilder pushLiteral: false. 
	irBuilder jumpAheadTo: #end.
	
	irBuilder jumpAheadTarget: #else.
	self inlineBlock: message arguments first.
	irBuilder jumpAheadTarget: #end.

]

{ #category : #'stub inline messages' }
LowtalkCompiledMethodGenerator >> generateArithmeticMessage: message receiverType: receiverType inSuperclass: inSuperclass [
	^ self generateNormalMessage: message receiverType: receiverType inSuperclass: inSuperclass
]

{ #category : #'stub inline messages' }
LowtalkCompiledMethodGenerator >> generateBinaryBitwiseMessage: message receiverType: receiverType inSuperclass: inSuperclass [
	^ self generateNormalMessage: message receiverType: receiverType inSuperclass: inSuperclass
]

{ #category : #'as yet unclassified' }
LowtalkCompiledMethodGenerator >> generateCastToMessage: message receiverType: receiverType inSuperclass: inSuperclass [
	receiverType irConvertExplicitlyTo: message type with: irBuilder at: message
]

{ #category : #'stub inline messages' }
LowtalkCompiledMethodGenerator >> generateComparisonMessage: message receiverType: receiverType inSuperclass: inSuperclass [
	^ self generateNormalMessage: message receiverType: receiverType inSuperclass: inSuperclass
]

{ #category : #'stub inline messages' }
LowtalkCompiledMethodGenerator >> generateEqualityMessage: message receiverType: receiverType inSuperclass: inSuperclass [
	^ self generateNormalMessage: message receiverType: receiverType inSuperclass: inSuperclass
]

{ #category : #'top level entry points' }
LowtalkCompiledMethodGenerator >> generateFunctionBody: body [
	self visitNode: body.
	
	method hasLocalReturns ifTrue: [
		irBuilder
			pushReceiver
			returnTop.
	] ifFalse: [
		method returnType isVoidType ifTrue: [ 
			irBuilder pushLiteral: nil.
		] ifFalse:[
			self coerceImplicitlyFrom: body type to: method returnType at: method node.
		].
		
		irBuilder returnTop.
	]

]

{ #category : #'stub inline messages' }
LowtalkCompiledMethodGenerator >> generateIdentityEqualityMessage: message receiverType: receiverType inSuperclass: inSuperclass [
	^ self generateNormalMessage: message receiverType: receiverType inSuperclass: inSuperclass
]

{ #category : #'inline messages' }
LowtalkCompiledMethodGenerator >> generateIfSelectionMessage: message receiverType: receiverType inSuperclass: inSuperclass [
	(#(ifTrue: ifFalse: ifTrue:ifFalse: ifFalse:ifTrue:) includes: message selector) ifTrue: [
		^ self generateInlineIfBooleanMessage: message receiverType: receiverType inSuperclass: inSuperclass
	].

	(#(ifNil: ifNotNil: ifNil:ifNotNil: ifNotNil:ifNil:) includes: message selector) ifTrue: [ 
		^ self generateInlineIfNilMessage: message receiverType: receiverType inSuperclass: inSuperclass
	].

	self error: 'Unsuporter if selection message'.
]

{ #category : #'inline messages' }
LowtalkCompiledMethodGenerator >> generateInlineIfBooleanMessage: message receiverType: receiverType inSuperclass: inSuperclass [
	| receiverValueType |
	receiverValueType := receiverType withoutReferences.
	self coerceImplicitlyFrom: receiverType to: receiverValueType at: message.
	
	irBuilder jumpAheadTo: #ifElse if: (#(ifFalse: ifFalse:ifTrue:) includes: message selector).
	self inlineBlock: message arguments first.
	self coerceInlineBlock: message arguments first resultInto: message type.
	irBuilder jumpAheadTo: #ifMerge.

	irBuilder jumpAheadTarget: #ifElse.
	message arguments size > 1 ifTrue: [ 
		self inlineBlock: message arguments second.
		self coerceInlineBlock: message arguments second resultInto: message type.
	] ifFalse: [ 
		irBuilder pushLiteral: nil
	].
	irBuilder jumpAheadTarget: #ifMerge.

]

{ #category : #'inline messages' }
LowtalkCompiledMethodGenerator >> generateInlineIfNilMessage: message receiverType: receiverType inSuperclass: inSuperclass [
	| receiverValueType |
	receiverValueType := receiverType withoutReferences.
	self coerceImplicitlyFrom: receiverType to: receiverValueType at: message.
	
	irBuilder
		pushDup;
		pushLiteral: nil;
		send: #==;
		jumpAheadTo: #ifElse if: (#(ifNotNil: ifNotNil:ifNil:) includes: message selector).

	(#(ifNil: ifNil:ifNotNil:) includes: message selector) ifTrue: [
		irBuilder popTop.
		self inlineBlock: message arguments first.
		self coerceInlineBlock: message arguments first resultInto: message type.
	] ifFalse: [
		self inlineBlock: message arguments first cull: 1 types: {receiverValueType}.
		self coerceInlineBlock: message arguments first resultInto: message type.
	].
	
	irBuilder jumpAheadTo: #ifMerge.

	irBuilder jumpAheadTarget: #ifElse.
	message arguments size > 1 ifTrue: [ 
		(message selector == #ifNotNil:ifNil:) ifTrue: [
			irBuilder popTop.
			self inlineBlock: message arguments second.
			self coerceInlineBlock: message arguments second resultInto: message type.
		] ifFalse: [
			self inlineBlock: message arguments second cull: 1 types: {receiverValueType}.
			self coerceInlineBlock: message arguments second resultInto: message type.
		].
	].

	irBuilder jumpAheadTarget: #ifMerge.

]

{ #category : #'as yet unclassified' }
LowtalkCompiledMethodGenerator >> generateInterpreterMethod: aMethod [
	| compiledMethod |
	normalReturnMethod := aMethod.
	method := aMethod.
	selfType := method receiverType.
	
	irBuilder := IRBuilder new.
	irBuilder numArgs: method arguments size.
	
	method arguments do: [ :arg |
		arg compiledMethodVariable: (self convertTemporaryName: arg name).
		irBuilder addTemp: arg compiledMethodVariable.
	].

	method temporaries do: [ :temp |
		temp compiledMethodVariable: (self convertTemporaryName: temp name).
		self initializeTemporary: temp.
	].

	self generateFunctionBody: method node body.
	
	compiledMethod := irBuilder ir compiledMethod.
	method selector ifNotNil: [ compiledMethod selector: method selector ].
	"classBinding := method methodClass classBindingWithCompiler: compiler.
	classBinding ifNotNil: [ method classBinding: classBinding]."
	
	^ compiledMethod
]

{ #category : #'as yet unclassified' }
LowtalkCompiledMethodGenerator >> generateInterpreterMethod: method closureEnvironment: closureEnvironment [
	self flag: 'Do we need the closure environment?'.
	^ self generateInterpreterMethod: method

]

{ #category : #'inline messages' }
LowtalkCompiledMethodGenerator >> generateMessage: message receiverType: receiverType inSuperclass: inSuperclass [
	| inlineSelector |
	message compileTimeValue ifNotNil: [ self halt ].
	message specialMessageType ifNotNil: [ 
		inlineSelector := 'generate' , message specialMessageType , 'Message:receiverType:inSuperclass:'.
		^ self perform: inlineSelector asSymbol withArguments: { message . receiverType . inSuperclass }
	].

	self generateNormalMessage: message receiverType: receiverType inSuperclass: inSuperclass
]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> generateNormalMessage: message receiverType: receiverType inSuperclass: inSuperclass [
	| actualReceiverType |
	actualReceiverType := receiverType.
	self coerceImplicitlyFrom: actualReceiverType to: compiler objectType at: message.

	irBuilder pushLiteral: message selector.
	
	message arguments do: [ :arg |
		self visitNode: arg.
		self coerceImplicitlyFrom: arg type to: compiler objectType at: message.
	].

	irBuilder
		pushConsArray: message arguments size;
		pushLiteral: (message arguments collect: [:arg | compiler objectType]);
		pushLiteral: inSuperclass;
		pushLiteral: message;
		pushLiteral: compiler.

	irBuilder send: #lowtalkPerform:withArguments:types:inSuperclass:node:compiler: 

]

{ #category : #'inline messages' }
LowtalkCompiledMethodGenerator >> generateOrMessage: message receiverType: receiverType inSuperclass: inSuperclass [
	self convertExplicitlyFrom: receiverType to: compiler booleanType at: message.
	irBuilder jumpAheadTo: #else if: false.
	irBuilder pushLiteral: true. 
	irBuilder jumpAheadTo: #end.
	
	irBuilder jumpAheadTarget: #else.
	self inlineBlock: message arguments first.
	irBuilder jumpAheadTarget: #end.

]

{ #category : #'stub inline messages' }
LowtalkCompiledMethodGenerator >> generatePointerDeReferenceMessage: message receiverType: receiverType inSuperclass: inSuperclass [
	^ self generateNormalMessage: message receiverType: receiverType inSuperclass: inSuperclass
]

{ #category : #'inline messages' }
LowtalkCompiledMethodGenerator >> generateRangeLoopMessage: message receiverType: receiverType inSuperclass: inSuperclass [
	| limit block limitEmit limitTemp step stepEmit stepTemp loopConditionMessage iterator |
	limit := message arguments first.
	block := message arguments last.

	"Coerce the start"
	self coerceImplicitlyFrom: receiverType to: message coercionType at: message.
	iterator := self generateTemp.
	irBuilder
		storeTemp: iterator. "Do not pop the receiver. It its the result value."

	"Coerce the step"	
	message arguments size = 3 ifTrue: [
		self visitNode: message arguments second.
		self coerceImplicitlyFrom: message arguments second type to: message coercionType at: message.
		stepTemp := self generateTemp.
		irBuilder
			storeTemp: stepTemp;
			popTop.
		stepEmit := [ irBuilder pushTemp: stepTemp ].
		self halt.
	] ifFalse: [
		loopConditionMessage := #<=.
		step := message coercionType convertLiteralValue: 1 fromType: compiler integerLiteralType at: message.
		stepEmit := [ irBuilder pushLiteral: step ].
	].
	
	"Coerce the limit"
	limitEmit := [self visitNode: limit].
	limit isLiteralNode | limit isSelf | limit isSuper ifFalse: [
		self visitNode: limit.
		self coerceImplicitlyFrom: limit type to: message coercionType at: message.
		limitTemp := self generateTemp.
		irBuilder
			storeTemp: limitTemp;
			popTop.
		limitEmit := [ irBuilder pushTemp: limitTemp ].
	].

	irBuilder
		jumpBackTarget: #rangeLoopHeader;
		pushTemp: iterator.
	limitEmit value.
	irBuilder send: loopConditionMessage;
		jumpAheadTo: #done if: false;

	"Inline the block"		
		pushTemp: iterator.
	self inlineBlock: block arguments: 1 types: { message coercionType }.
	irBuilder popTop.
	
	"Increase the iterator"
	irBuilder pushTemp: iterator.
	stepEmit value.
	irBuilder send: #+;
		storeTemp: iterator;
		popTop.
		
	irBuilder
		jumpBackTo: #rangeLoopHeader;
		jumpAheadTarget: #done
	

]

{ #category : #'as yet unclassified' }
LowtalkCompiledMethodGenerator >> generateReinterpretCastToMessage: message receiverType: receiverType inSuperclass: inSuperclass [
	"For now do nothing"
	
]

{ #category : #'inline messages' }
LowtalkCompiledMethodGenerator >> generateSetSlotMessage: message receiverType: receiverType inSuperclass: inSuperclass [
	| referenceType structureType slot newValue newValueType setSlotSelector |
	self assert: message arguments size = 1.
	referenceType := receiverType.
	structureType := referenceType withoutReferences.
	self assert: structureType isStructureType.

	setSlotSelector := #lowtalkRefSetField:value:.
	referenceType isReferenceType ifFalse: [
		setSlotSelector := #lowtalkSetField:value:
	].

	"Get the slot name"
	slot := structureType slotNamed: message selector allButLast.
	irBuilder pushLiteral: slot.

	"Convert the slot value"
	newValue := self visitNode: message arguments first.
	newValueType := message arguments first type.
	self coerceImplicitlyFrom: newValueType to: slot type at: message.

	irBuilder send: setSlotSelector
]

{ #category : #'inline messages' }
LowtalkCompiledMethodGenerator >> generateSlotMessage: message receiverType: receiverType inSuperclass: inSuperclass [
	| referenceType structureType slot getSlotSelector |
	self assert: message arguments size = 0.
	referenceType := receiverType.
	structureType := referenceType withoutReferences.
	self assert: structureType isStructureType.

	getSlotSelector := #lowtalkRefGetFieldRef:.
	referenceType isReferenceType ifFalse: [
		getSlotSelector := #lowtalkGetFieldRef:
	].

	"Get the slot name"
	slot := structureType slotNamed: message selector.
	irBuilder pushLiteral: slot.

	irBuilder send: getSlotSelector
]

{ #category : #'stub inline messages' }
LowtalkCompiledMethodGenerator >> generateStructureNewMessage: message receiverType: receiverType inSuperclass: inSuperclass [
	^ self generateNormalMessage: message receiverType: receiverType inSuperclass: inSuperclass
]

{ #category : #private }
LowtalkCompiledMethodGenerator >> generateSymbol [
	gensymCount := gensymCount + 1.
	^ self convertTemporaryName: ('__ltigsym' , gensymCount asString) asSymbol
]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> generateTemp [
	| symbol |
	symbol := self generateSymbol.
	irBuilder addTemp: symbol.
	^ symbol
	
]

{ #category : #'inline messages' }
LowtalkCompiledMethodGenerator >> generateYourselfMessage: message receiverType: receiverType inSuperclass: inSuperclass [
	"Nothing to do"
]

{ #category : #initialization }
LowtalkCompiledMethodGenerator >> initialize [
	super initialize.
	usedNames := Set new.
	usedNameCount := 1.
	gensymCount := 0.
]

{ #category : #initialization }
LowtalkCompiledMethodGenerator >> initializeTemporary: temp [
	irBuilder
		addTemp: temp compiledMethodVariable.

	temp isInlineArgument ifFalse: [ 
		temp compiledMethodVariableIsSlot: true.

		irBuilder
			pushLiteral: temp valueType defaultValue;
			send: #asLowtalkVariableSlot;
			storeTemp: temp compiledMethodVariable;
			popTop
	].
]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> inlineBlock: potentialBlockNode [
	self inlineBlock: potentialBlockNode arguments: 0 types: #()
]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> inlineBlock: potentialBlockNode arguments: arguments types: types [
	| selector arg argumentValueType |
	potentialBlockNode isBlockNode ifFalse: [
		selector := String streamContents: [ :out |
			(1 to: arguments) do: [ out nextPutAll: 'value:' ]
		].
		selector := selector asSymbol.
		self halt.
	].
	
	potentialBlockNode arguments size to: 1 by: -1 do: [ :index |
		arg := potentialBlockNode arguments at: index.
		self assert: arg binding isInlineArgument.
		argumentValueType := types at: index.
		self coerceImplicitlyFrom: argumentValueType to: arg binding valueType at: potentialBlockNode.
		arg binding irStoreStackTopWith: irBuilder.
		irBuilder
			popTop
	].

	self visitNode: potentialBlockNode body.
	self coerceImplicitlyFrom: potentialBlockNode body type to: potentialBlockNode returnType at: potentialBlockNode

]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> inlineBlock: potentialBlockNode cull: optionalArguments types: types [
	| selector discardedArguments |
	potentialBlockNode isBlockNode ifFalse: [
		selector := String streamContents: [ :out |
			(1 to: optionalArguments) do: [ out nextPutAll: 'cull:' ]
		].
		selector := selector asSymbol.
		self halt.
	].
	
	discardedArguments := optionalArguments - potentialBlockNode arguments size.
	1 to: discardedArguments do: [ :i | irBuilder popTop ].
	
	self inlineBlock: potentialBlockNode arguments: potentialBlockNode arguments types: (types first: potentialBlockNode arguments size)
]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> visitArrayLiteralNode: node [
	irBuilder pushLiteral: node value
]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> visitArrayNode: node [
	self halt.
]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> visitAssignmentNode: aNode [
	self flag: 'TODO: Support per value identifiers.'.
	self assert: aNode reference type isReferenceType.
	
	self visitNode: aNode reference.
	self visitNode: aNode value.
	self coerceImplicitlyFrom: aNode value type to: aNode reference type withoutReferences at:  aNode.
	irBuilder send: #value:.

]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> visitBlockNode: aBlockNode [
	| blockMethod argumentNames tempNames copiedNames |
	aBlockNode arguments size > 15 ifTrue: [self backendError: 'Too many arguments' forNode: aBlockNode ].
	
	blockMethod := aBlockNode definition.
	blockMethod hasLocalReturns ifTrue: [ 
		self halt.
	].

	blockMethod arguments do: [ :arg |
		arg compiledMethodVariable: (self convertTemporaryName: arg name).
	].

	blockMethod temporaries do: [ :temp |
		temp compiledMethodVariable: (self convertTemporaryName: temp name).
	].

	argumentNames := (blockMethod arguments collect: #compiledMethodVariable) asArray.
	tempNames := (blockMethod temporaries collect: #compiledMethodVariable) asArray.
	copiedNames := (blockMethod outerClosureVariables collect: #compiledMethodVariable) asArray..

	irBuilder
			pushClosureCopyCopiedValues: copiedNames
			args: argumentNames
			jumpTo:  #block.

	irBuilder addTemps: tempNames.
	blockMethod temporaries do: [ :temp |
		self initializeTemporary: temp
	].
	
	self withMethod: blockMethod do: [
		self visitNode: aBlockNode body.
	].
	
	blockMethod returnType isVoidType ifTrue: [ 
		irBuilder pushLiteral: nil.
	] ifFalse: [
		self coerceImplicitlyFrom: aBlockNode body type to: blockMethod returnType at: aBlockNode
	].

	irBuilder blockReturnTop.
	irBuilder jumpAheadTarget: #block;
		pushLiteral: blockMethod;
		send: #asLowtalkBlockClosureFor:

]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> visitBooleanLiteralNode: aNode [
	^ irBuilder pushLiteral: aNode value
]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> visitCallExpression: expression [
	| receiverType expectedArgumentTypes arguments |
	receiverType := expression receiver type withoutReferences.

	(receiverType isFunctionType or: [ receiverType isBlockType ]) ifTrue: [ 
		expectedArgumentTypes := receiverType arguments.
	] ifFalse: [
		expectedArgumentTypes expression arguments collect: [ :a | compiler objectType ].
	].
	
	"Get the receiver"
	self visitNode: expression receiver.
	self coerceImplicitlyFrom: expression receiver type to: receiverType at: expression.
	
	"Process the arguments"
	arguments := expression arguments.
	arguments doWithIndex: [ :arg :index |
		self visitNode: arg.
		self coerceImplicitlyFrom: arg type to: (expectedArgumentTypes at: index) at: arg.
	].

	irBuilder
		pushConsArray: arguments size;
		pushLiteral: expectedArgumentTypes;
		pushLiteral: compiler;
		pushLiteral: expression;
		send: #lowtalkValueWithArguments:types:compiler:at:

]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> visitExpressionListNode: list [
	| hasToPop |
	hasToPop := false.
	list expressions ifEmpty: [ ^ irBuilder pushLiteral: nil ].
	list expressions do: [ :node |
		hasToPop ifTrue: [ irBuilder popTop ].
		
		self visitNode: node.
		hasToPop := true.
	]
]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> visitFloatLiteralNode: aNode [
	^ irBuilder pushLiteral: aNode value
]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> visitIdentifierReferenceNode: node [
	| binding |
	binding := node binding.
	binding isVariable ifTrue: [
		binding isCompileTimeVariable ifTrue: [
			node type isReferenceType ifTrue: [ 
				^ irBuilder pushLiteral: binding
			] ifFalse: [ 
				self halt
			].
		].
	
		binding isMethodReceiverSlot ifTrue: [
			node type isReferenceType ifTrue: [
				^ irBuilder
					pushReceiver;
					pushLiteral: binding description;
					send: #pointerForSlotDescription:
			] ifFalse: [
				self halt.
			]
		].
	
		node binding isMethodVariable ifTrue: [ 
			self assert: node binding method isNotNil.
			self assert: node binding compiledMethodVariable isNotNil.
			node binding method ~~ method ifTrue: [ 
				^ self captureInClosure: node binding ssaValue
			].
			^ irBuilder pushTemp: node binding compiledMethodVariable
		].
	
		^ irBuilder pushLiteral: binding
	].

	binding isNamespace ifTrue: [ 
		node type isCompileTimeType ifTrue: [ ^ irBuilder pushLiteral: binding ].
	].
	self halt
]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> visitIntegerLiteralNode: node [
	irBuilder pushLiteral: node value
]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> visitLetExpressionNode: node [
	node initialValue ifNil: [ ^ irBuilder pushLiteral: node type defaultValue ].
	
	self visitNode: node initialValue.
	self coerceImplicitlyFrom: node initialValue type to: node valueType at: node.
	node binding irStoreStackTopWith: irBuilder.

]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> visitMessageChainNode: messageChain [
	| superClass lastMesageIndex |
	self visitNode: messageChain receiver.
	superClass := messageChain receiver isSuper.
	lastMesageIndex := messageChain messages size.
	messageChain messages doWithIndex: [ :message  :index |
		index ~= lastMesageIndex ifTrue: [ irBuilder pushDup ].
		self generateMessage: message receiverType: messageChain receiver type inSuperclass: superClass.
		index ~= lastMesageIndex ifTrue: [ irBuilder popTop ].
	].

]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> visitMessageNode: messageNode [
	messageNode compileTimeValue ifNotNil: [ ^ irBuilder pushLiteral: messageNode compileTimeValue ].
	(messageNode receiver isBlockNode and: [ BlockMessages includesKey: messageNode selector ]) ifTrue: [
		^ self compileInlineWhileMessage: messageNode
	].

	self visitNode: messageNode receiver.
	self generateMessage: messageNode receiverType: messageNode receiver type inSuperclass: messageNode receiver isSuper
]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> visitNilLiteralNode: aNode [
	^ irBuilder pushLiteral: aNode value
]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> visitReturnNode: node [
	| valueType returnType |
	self visitNode: node value.
	valueType := node value type.
	
	method hasLocalReturns ifFalse: [
		self halt
	] ifTrue: [
		returnType := method returnType.
	].

	self coerceImplicitlyFrom: valueType to: returnType at: node.
	irBuilder returnTop
	
]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> visitSelfNode: aNode [
	irBuilder pushReceiver
]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> visitStringLiteralNode: aNode [
	^ irBuilder pushLiteral: aNode value
]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> visitSymbolLiteralNode: aNode [
	^ irBuilder pushLiteral: aNode value
]

{ #category : #visiting }
LowtalkCompiledMethodGenerator >> withMethod: newMethod do: aBlock [
	| oldMethod |
	oldMethod := method.
	method := newMethod.
	aBlock ensure: [
		method := oldMethod
	]
]
