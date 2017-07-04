as yet unclassified
compiledMethodForReceiverTypeValue: receiverType
	^ LowtalkMethodSemanticAnalyzer new
		analyzeMethod: node receiverType: receiverType environment: environment