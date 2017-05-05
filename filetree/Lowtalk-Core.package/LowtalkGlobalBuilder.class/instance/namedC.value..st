as yet unclassified
namedC: nameLazyValue value: lazyValue
	<compileTime>
	<lazy>
	^ (self named: nameLazyValue type: lazyValue inferValueType value: lazyValue)
		isVisibleInC: true;
		yourself
