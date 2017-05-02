parsing
parseFromFileNamed: aFileName
	| fileRef contents |
	fileRef := aFileName asFileReference.
	contents := fileRef contents asLowtalkCollectionWithContext.
	contents name: fileRef fullName.
	^ self parse: contents