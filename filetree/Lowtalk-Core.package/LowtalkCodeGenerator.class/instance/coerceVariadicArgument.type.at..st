visiting
coerceVariadicArgument: value type: valueType at: node
	^ valueType ssaCoerceCVariadic: value with: builder at: node.