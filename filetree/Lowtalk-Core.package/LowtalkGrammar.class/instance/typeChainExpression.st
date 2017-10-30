type expression
typeChainExpression
	^ typeChainReceiver , typeChainKeywordMessage optional , (semicolon , typeChainedMessage) star