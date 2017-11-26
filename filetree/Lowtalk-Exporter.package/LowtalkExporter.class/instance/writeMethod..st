writing
writeMethod: aCompiledMethod
	out nextPutAll: ':['; nextPutAll: aCompiledMethod sourceCode withUnixLineEndings; lf.
	out nextPutAll: '].'; lf