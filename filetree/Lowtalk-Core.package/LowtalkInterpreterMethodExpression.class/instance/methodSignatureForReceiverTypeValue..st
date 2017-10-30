as yet unclassified
methodSignatureForReceiverTypeValue: receiverType
	^ LowtalkMethodSemanticAnalyzer new
		analyzeMethodSignature: node receiverType: receiverType environment: environment