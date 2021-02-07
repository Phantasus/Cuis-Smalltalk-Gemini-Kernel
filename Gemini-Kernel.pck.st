'From Cuis 5.0 [latest update: #4526] on 7 February 2021 at 4:51:05 pm'!
'Description License: MIT'!
!provides: 'Gemini-Kernel' 1 22!
SystemOrganization addCategory: 'Gemini-Kernel-Tests'!
SystemOrganization addCategory: 'Gemini-Kernel'!


!classDefinition: #GeminiLinkAction category: 'Gemini-Kernel'!
TextAction subclass: #GeminiLinkAction
	instanceVariableNames: 'linkUrl'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Gemini-Kernel'!
!classDefinition: 'GeminiLinkAction class' category: 'Gemini-Kernel'!
GeminiLinkAction class
	instanceVariableNames: ''!

!classDefinition: #GeminiResponseTest category: 'Gemini-Kernel-Tests'!
TestCase subclass: #GeminiResponseTest
	instanceVariableNames: 'usedClass fixtures'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Gemini-Kernel-Tests'!
!classDefinition: 'GeminiResponseTest class' category: 'Gemini-Kernel-Tests'!
GeminiResponseTest class
	instanceVariableNames: ''!

!classDefinition: #GeminiFixtures category: 'Gemini-Kernel-Tests'!
Object subclass: #GeminiFixtures
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Gemini-Kernel-Tests'!
!classDefinition: 'GeminiFixtures class' category: 'Gemini-Kernel-Tests'!
GeminiFixtures class
	instanceVariableNames: ''!

!classDefinition: #GeminiClient category: 'Gemini-Kernel'!
Object subclass: #GeminiClient
	instanceVariableNames: 'requestUrl'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Gemini-Kernel'!
!classDefinition: 'GeminiClient class' category: 'Gemini-Kernel'!
GeminiClient class
	instanceVariableNames: ''!

!classDefinition: #GeminiDocument category: 'Gemini-Kernel'!
Object subclass: #GeminiDocument
	instanceVariableNames: 'rawText baseUrl'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Gemini-Kernel'!
!classDefinition: 'GeminiDocument class' category: 'Gemini-Kernel'!
GeminiDocument class
	instanceVariableNames: ''!

!classDefinition: #GeminiResponse category: 'Gemini-Kernel'!
Object subclass: #GeminiResponse
	instanceVariableNames: 'metaHeader body statusCode requestUrl'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Gemini-Kernel'!
!classDefinition: 'GeminiResponse class' category: 'Gemini-Kernel'!
GeminiResponse class
	instanceVariableNames: ''!

!classDefinition: #GeminiStreamer category: 'Gemini-Kernel'!
Object subclass: #GeminiStreamer
	instanceVariableNames: 'currentStream'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Gemini-Kernel'!
!classDefinition: 'GeminiStreamer class' category: 'Gemini-Kernel'!
GeminiStreamer class
	instanceVariableNames: ''!


!GeminiDocument commentStamp: '<historical>' prior: 0!
Represents a document model for the text/gemini mimetype used by the gemini protocol to display pages!

!GeminiLinkAction methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 16:38:55'!
actOnClickFor: model
	| newClient response |
	newClient _ linkUrl asGeminiClient.
	response _ newClient next.
	response openInWorld.


        ^true
! !

!GeminiLinkAction methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 16:15:34'!
target: newUrl

	linkUrl _ newUrl asUri! !

!GeminiResponseTest methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 02:11:47'!
setUp
	usedClass _ GeminiResponse.
	fixtures _ GeminiFixtures new.! !

!GeminiResponseTest methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 13:58:30'!
testRedirectResponse
	| buffer |
	buffer _ usedClass withAll: fixtures tortureTestDerivedFixture2.
	
	self assert: nil equals: buffer body.
	self assert: nil equals: buffer mimeType.
	self assert: '/test/torture/' equals: buffer redirectUrl asString.
	
	self assert: 31 equals: buffer statusCode.
	
	self assert: buffer isSuccess not.
	self assert: buffer isRedirect.! !

!GeminiResponseTest methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 00:54:49'!
testSuccessfulResponse
	| buffer |
	buffer _ usedClass withAll: fixtures tortureTestDerivedFixture1.
	
	self assert: 'You are about to start the Gemini' asByteArray equals: buffer body.
	self assert: 'text/gemini' equals: buffer mimeType.
	self assert: 20 equals: buffer statusCode.
	self assert: buffer isSuccess.! !

!GeminiFixtures methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 00:49:19'!
tortureTestDerivedFixture1
	^#[50 48 32 116 101 120 116 47 103 101 109 105 110 105 13 10 89 111 117 32 97 114 101 32 97 98 111 117 116 32 116 111 32 115 116 97 114 116 32 116 104 101 32 71 101 109 105 110 105]! !

!GeminiFixtures methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 03:57:39'!
tortureTestDerivedFixture2	
	^#[51 49 32 47 116 101 115 116 47 116 111 114 116 117 114 101 47 13 10]! !

!GeminiClient methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 14:58:18'!
goTo: newUrl
	requestUrl _ newUrl asUri.
	
	^self next.! !

!GeminiClient methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 11:39:00'!
initialize
	requestUrl _ nil.! !

!GeminiClient methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 12:25:29'!
initializeWith: configurator
	requestUrl _ configurator at: #requestUrl ifAbsent: [ nil ].! !

!GeminiClient methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 14:08:15'!
newConnection
	"Establishes a new connection with the remote server and perform essential initial handshakes"

	| newStream newHost newPort |
	newHost _ requestUrl at: #host.
	newPort _ requestUrl at: #port ifAbsent: [ 1965 ].
	
	(requestUrl at: #scheme) = 'gemini'
		ifFalse: [ self error: 'unsupported request scheme' ].
	
	newStream _ SecureSocketStream
		openConnectionToHostNamed: newHost
		port: newPort.
	
	newStream binary.
	newStream sslConnect.
		
	^newStream! !

!GeminiClient methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 12:27:07'!
newRequest
	"Creates a new gemini request from the current state"
	| url |
	url _ requestUrl asString.
	
	self assert: url size <= 1024.
	
	^ByteArray streamContents: [:stream |
		stream nextPutAll: url asByteArray.
		stream nextPut: 13. "cr"
		stream nextPut: 10. "lf" ]
		! !

!GeminiClient methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 16:27:44'!
next
	| streamer newResponse redirectCounts maxRedirects |
	redirectCounts _ 0.
	maxRedirects _ 5.
	
	streamer _ GeminiStreamer on: self newConnection.	
	newResponse _ streamer nextPutAll: self newRequest.

	[ newResponse isRedirect and: [ redirectCounts < maxRedirects ]]
		whileTrue: [
			redirectCounts _ redirectCounts + 1.
			requestUrl _ requestUrl join: newResponse redirectUrl.
			
			streamer setStream: self newConnection.
			newResponse _ streamer nextPutAll: self newRequest ].
	
	newResponse requestUrl: requestUrl copy.

	^newResponse! !

!GeminiClient class methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 02:03:23'!
newFrom: configurator
	| newClient |
	
	newClient _ self basicNew.
	newClient initializeWith: configurator.
	
	^newClient! !

!GeminiDocument methodsFor: 'accessing' stamp: 'jpb 2/7/2021 15:34:55'!
text: aString 
	rawText _ aString! !

!GeminiDocument methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 16:20:54'!
asText
	| textModel |
	
	textModel _ Text new.
	rawText linesDo: [:line| textModel _ textModel append: (self parseLine: line) ].
	
	^textModel! !

!GeminiDocument methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 16:31:29'!
baseUrl: newUrl
	"Sets the base url for resolving relative links"
	baseUrl _ newUrl! !

!GeminiDocument methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 15:40:41'!
edit
	^self asText edit! !

!GeminiDocument methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 16:40:53'!
openInWorld
	self edit! !

!GeminiDocument methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 15:52:31'!
parseLine: newLine
	
	newLine ifEmpty: [ ^String newLineString ].
	
	newLine size > 2
		ifTrue: [ '=>' = (newLine copyFrom: 1 to: 2) ifTrue: [ ^ self parseLinkLine: newLine ]].
		
	^ newLine , String newLineString 
	
	
	! !

!GeminiDocument methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 16:32:34'!
parseLinkLine: newLine
	| linkLabel linkUri readStream whiteSpace newText newLink |	
	
	whiteSpace _ { Character tab. Character space }.
	readStream _ newLine readStream.
	
	self assert: readStream next = $=.
	self assert: readStream next = $>.
	
	"consume whitespace"
	[ whiteSpace includes: readStream peek ]
		whileTrue: [ readStream next ].
		
	linkUri _ String streamContents: [:linkStream |
		| newChar|
		[ newChar _ readStream next. 
		readStream atEnd or: [ (whiteSpace includes: newChar) ]]
			whileFalse: [ linkStream nextPut: newChar ]].
		
	"consume whitespace"
	[ whiteSpace includes: readStream peek ]
		whileTrue: [ readStream next ].
	
	linkLabel _ String streamContents: [:linkStream |
		[ readStream atEnd ]
			whileFalse: [ linkStream nextPut: readStream next ]].
		
	newText _ (linkLabel , String newLineString ) asText.
	newLink _ GeminiLinkAction new.
	
	linkUri _ linkUri asUri.
	linkUri isRelative ifTrue: [ linkUri _ baseUrl join: linkUri ].
	
	newLink target: linkUri.	
	newText addAttribute: newLink.
	
	^newText! !

!GeminiDocument class methodsFor: 'instance creation' stamp: 'jpb 2/7/2021 15:34:37'!
fromString: aString 
	| newInstance | 
	newInstance _ self new.
	newInstance text: aString.
	
	^newInstance! !

!GeminiDocument class methodsFor: 'instance creation' stamp: 'jpb 2/7/2021 15:11:27'!
withAll: aByteArray 
	^self fromString: (String fromUtf8: aByteArray)! !

!GeminiResponse methodsFor: 'testing' stamp: 'jpb 2/7/2021 01:52:17'!
isFailure
	^self isPermanentFailure or: [ self isTemporaryFailure ]! !

!GeminiResponse methodsFor: 'testing' stamp: 'jpb 2/7/2021 01:51:19'!
isPermanentFailure
	^(statusCode div: 10) = 5! !

!GeminiResponse methodsFor: 'testing' stamp: 'jpb 2/7/2021 01:50:38'!
isRedirect
	^(statusCode div: 10) = 3! !

!GeminiResponse methodsFor: 'testing' stamp: 'jpb 2/7/2021 01:46:15'!
isSuccess
	^(statusCode div: 10) = 2! !

!GeminiResponse methodsFor: 'testing' stamp: 'jpb 2/7/2021 01:50:58'!
isTemporaryFailure
	^(statusCode div: 10) = 4! !

!GeminiResponse methodsFor: 'testing' stamp: 'jpb 2/7/2021 01:51:49'!
isUnauthorized
	^(statusCode div: 10) = 6! !

!GeminiResponse methodsFor: 'accessing' stamp: 'jpb 2/7/2021 01:39:24'!
at: fieldName put: newValue

	#meta = fieldName
		ifTrue: [ metaHeader _ newValue. ^newValue ].
		
	#body = fieldName
		ifTrue: [ body _ newValue. ^newValue ].
		
	#statusCode = fieldName
		ifTrue: [ statusCode _ newValue. ^newValue].
		
	self error: 'Unknown field'! !

!GeminiResponse methodsFor: 'accessing' stamp: 'jpb 2/7/2021 01:44:47'!
body
	^body! !

!GeminiResponse methodsFor: 'accessing' stamp: 'jpb 2/7/2021 16:45:18'!
bodyParsed
	'text/gemini' = self mimeType
		ifTrue: [
			| newDocument | newDocument _ GeminiDocument withAll: body.
			newDocument _ newDocument baseUrl: requestUrl copy.
			^newDocument ]! !

!GeminiResponse methodsFor: 'accessing' stamp: 'jpb 2/7/2021 01:47:39'!
mimeType
	self isSuccess
		ifTrue: [ ^metaHeader ]
		ifFalse: [ ^nil ]! !

!GeminiResponse methodsFor: 'accessing' stamp: 'jpb 2/7/2021 13:52:44'!
redirectUrl
	self isRedirect 
		ifTrue: [ ^metaHeader asUri ].
		
	^nil! !

!GeminiResponse methodsFor: 'accessing' stamp: 'jpb 2/7/2021 16:28:48'!
requestUrl
	"Returns the used request Url to fetch this response"
	^requestUrl! !

!GeminiResponse methodsFor: 'accessing' stamp: 'jpb 2/7/2021 16:28:30'!
requestUrl: newUrl
	requestUrl _ newUrl! !

!GeminiResponse methodsFor: 'accessing' stamp: 'jpb 2/7/2021 01:45:09'!
statusCode
	^statusCode ! !

!GeminiResponse methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 16:40:41'!
openInWorld
	"Displays this response in the world"
	| newDocument |
	
	newDocument _ self bodyParsed.
	
	newDocument isNil
		ifTrue: [ self inspect ]
		ifFalse: [ newDocument openInWorld ]! !

!GeminiResponse class methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 01:06:03'!
readFrom: readStream
	| newInstance streamer |
	newInstance _ self new.
	
	streamer _ GeminiStreamer on: readStream.
	streamer readResponseInto: newInstance.
	
	^newInstance! !

!GeminiResponse class methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 00:59:14'!
withAll: aCollection
	^self readFrom: aCollection readStream! !

!GeminiStreamer methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 01:25:05'!
nextDigit
	"Reads the next digit char, raise error when not digit"
	| newChar |
	
	newChar _ currentStream next asCharacter.
	
	self assert: newChar isDigit.
	
	^newChar! !

!GeminiStreamer methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 01:36:09'!
nextLineCrLf
	self assert: currentStream next = 13. "cr"
	self assert: currentStream next = 10. "lf"
	
	^String crlfString! !

!GeminiStreamer methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 11:19:05'!
nextPutAll: newRequest
	"Sends the binary request to the server and reads the response. Closes the connection after that"
	| newResponse |
	
	[	
		currentStream nextPutAll: newRequest.
		currentStream flush.

		newResponse _ GeminiResponse readFrom: currentStream.
	]
	ensure: [ currentStream close ].

	^newResponse! !

!GeminiStreamer methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 01:48:10'!
readResponseInto: aCollection
	
	| statusCode metaStream body maxMetaSize metaOffset  |
	maxMetaSize _ 1024.
	statusCode _ (String 
		with: self nextDigit
		with: self nextDigit) asNumber.
	
	currentStream next = 16r20
		ifFalse: [ self error: 'Expected space' ].
	
	metaOffset _ 0.
	metaStream _ ByteArray streamContents: [:stream|
		[ currentStream peek = 13 ]
			whileFalse: [
				metaOffset <= maxMetaSize
					ifTrue: [ stream nextPut: currentStream next. metaOffset _ metaOffset + 1 ]
					ifFalse: [ self error: 'Meta header exceeds ' , maxMetaSize asString ]]		
	] limitedTo: maxMetaSize.

	self nextLineCrLf.
	
	"if success then read body"
	(statusCode div: 10) = 2
		ifTrue: [ body _ currentStream upToEnd ].
	
	aCollection at: #statusCode put: statusCode.
	aCollection at: #meta put: (String fromUtf8: metaStream contents).
	aCollection at: #body put: body.
		
	
	^aCollection! !

!GeminiStreamer methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 01:07:37'!
setStream: newStream
	currentStream _ newStream.! !

!GeminiStreamer class methodsFor: 'as yet unclassified' stamp: 'jpb 2/7/2021 01:07:13'!
on: newStream
	| newInstance |
	
	newInstance _ self new.
	newInstance setStream: newStream.
	
	^newInstance! !

!GenericUri methodsFor: '*Gemini-Kernel' stamp: 'jpb 2/7/2021 16:37:53'!
asGeminiClient
	self assert: 'gemini' = (self at: #scheme).

	^GeminiClient newFrom: { #requestUrl -> self } asDictionary.! !
