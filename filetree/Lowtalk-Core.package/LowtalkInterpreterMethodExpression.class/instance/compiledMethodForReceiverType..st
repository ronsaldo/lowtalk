as yet unclassified
compiledMethodForReceiverType: receiverTypeLazyValue
	<compileTime>
	<lazy>
	| receiverType |
	receiverType := receiverTypeLazyValue value asLowtalkTypeIn: receiverTypeLazyValue node.
	^ LowtalkMethodSemanticAnalyzer new
		analyzeMethod: node receiverType: receiverType environment: environment