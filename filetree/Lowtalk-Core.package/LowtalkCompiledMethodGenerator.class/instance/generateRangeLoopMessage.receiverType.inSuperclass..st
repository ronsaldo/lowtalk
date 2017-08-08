inline messages
generateRangeLoopMessage: message receiverType: receiverType inSuperclass: inSuperclass
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
	
