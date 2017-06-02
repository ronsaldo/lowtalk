as yet unclassified
contextMetaDataHeaderSize
	^ contextMetaDataHeaderSize ifNil: [ contextMetaDataHeaderSize := (compiler objectModel convertMethodContextMetadataFunction value: nil value: #()) ssaValueType size ]