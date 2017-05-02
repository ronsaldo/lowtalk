expressions
chainExpression
	^ chainReceiver , chainKeywordMessage optional , (semicolon , chainedMessage) star