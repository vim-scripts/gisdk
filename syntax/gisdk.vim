" Vim syntax file
" Language:	GISDK Caliper Script
" Maintainer:	Luis Carvalho <lexcarvalho@hotmail.com>
" Last Change:	2002 Apr 27

" This style is based upon Bram's C style (c.vim)

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Keywords
syn keyword	gConditional	if then else on goto
syn keyword	gRepeat			while for to step do end endItem
syn keyword	gElement		Prompt Icons Help List Variable Editable
syn keyword	gElement		Button Frame Edit CheckBox Text Popdown Menu ScrollBox Tool Init Close
syn keyword	gStatement		shared global and or lon lat coord dim
syn keyword	gMacro			Macro DBox Title Toolbox NoKeyboard Default Disabled endMacro endDBox
syn keyword	gConstant		null Numeric String Intersecting Enclosed length True False default
syn keyword	gConstant		Area Line Point ActiveNetwork Several More same center left right
syn keyword	gTodo			contained TODO FIXME XXX

" Operators
syn match gOperator	"||\|&&\|!=\|>=\|<=\|=\~\|!\~\|>\|<\|+\|-\|=\|\." skipwhite nextgroup=gString,gNumber

" gCommentGroup allows adding matches for special things in comments
syn cluster	gCommentGroup	contains=gTodo

" String and Character constants
" Highlight special characters (those which have a backslash) differently
syn match	gSpecial	display contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"
syn region	gString		start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=gSpecial

syn match	gCharacter	"L\='[^\\]'"
syn match	gCharacter	"L'[^']*'" contains=gSpecial
syn match	gSpecialError	"L\='\\[^'\"?\\abfnrtv]'"
syn match	gSpecialCharacter "L\='\\['\"?\\abfnrtv]'"
syn match	gSpecialCharacter display "L\='\\\o\{1,3}'"
syn match	gSpecialCharacter display "'\\x\x\{1,2}'"
syn match	gSpecialCharacter display "L'\\x\x\+'"

"highlight trailing white space
"syn match	gSpaceError	display excludenl "\s\+$"
"syn match	gSpaceError	display " \+\t"me=e-1

"catch errors caused by wrong parenthesis and brackets
syn cluster	gParenGroup	contains=gParenError,gSpecial,gCommentSkip,gCommentString,gComment2String,@gCommentGroup,gCommentStartError,gUserCont,gUserLabel,gBitField,gCommentSkip,gNumber,gFloat,gNumbersCom

syn region	gParen		transparent start='(' end=')' contains=ALLBUT,@gParenGroup,gErrInBracket,gErrInCurlyBracket
syn match	gParenError	display "[\])]"
syn match	gErrInParen	display contained "[;\]}]"
syn region	gBracket	transparent start='\[' end=']' contains=ALLBUT,@gParenGroup,gErrInParen,gErrInCurlyBracket
syn match	gErrInBracket	display contained "[);}]"
syn region	gCurlyBracket	transparent start='{' end='}' contains=ALLBUT,@gParenGroup,gErrInParen,gErrInBracket
syn match	gErrInCurlyBracket	display contained "[);\]]"

"integer number, or floating point number without a dot and with "f".
syn case ignore
syn match	gNumbers	display transparent "\<\d\|\.\d" contains=gNumber,gFloat
" Same, but without octal error (for comments)
syn match	gNumbersCom	display contained transparent "\<\d\|\.\d" contains=gNumber,gFloat
syn match	gNumber		display contained "\d\+\(u\=l\{0,2}\|ll\=u\)\>"
"hex number
syn match	gNumber		display contained "0x\x\+\(u\=l\{0,2}\|ll\=u\)\>"
syn match	gFloat		display contained "\d\+f"
"floating point number, with dot, optional exponent
syn match	gFloat		display contained "\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\="
"floating point number, starting with a dot, optional exponent
syn match	gFloat		display contained "\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
"floating point number, without dot, with exponent
syn match	gFloat		display contained "\d\+e[-+]\=\d\+[fl]\=\>"
" flag an octal number with wrong digits
syn case match

" A comment can contain gString, gCharacter and gNumber.
" But a "*/" inside a gString in a gComment DOES end the comment!  So we
" need to use a special type of gString: gCommentString, which also ends on
" "*/", and sees a "*" at the start of the line as comment again.
" Unfortunately this doesn't very well work for // type of comments :-(
syntax match	gCommentSkip	contained "^\s*\*\($\|\s\+\)"
syntax region	gCommentString	contained start=+L\="+ skip=+\\\\\|\\"+ end=+"+ end=+\*/+me=s-1 contains=gSpecial,gCommentSkip
syntax region	gComment2String	contained start=+L\="+ skip=+\\\\\|\\"+ end=+"+ end="$" contains=gSpecial
syntax region	gCommentL	start="//" skip="\\$" end="$" keepend contains=@gCommentGroup,gComment2String,gCharacter,gNumbersCom,gSpaceError
syntax region	gComment	matchgroup=gCommentStart start="/\*" matchgroup=NONE end="\*/" contains=@gCommentGroup,gCommentStartError,gCommentString,gCharacter,gNumbersCom,gSpaceError

" keep a // comment separately, it terminates a preproc. conditional
syntax match	gCommentError	display "\*/"
syntax match	gCommentStartError display "/\*"me=e-1 contained


" Highlight User Labels
syn cluster	gMultiGroup	contains=gSpecial,gCommentSkip,gCommentString,gComment2String,@gCommentGroup,gCommentStartError,gUserCont,gUserLabel,gBitField,gNumber,gFloat,gNumbersCom
syn region	gMulti		transparent start='?' skip='::' end=':' contains=ALLBUT,@gMultiGroup
syn cluster	gLabelGroup	contains=gUserLabel
syn match	gUserCont	display "^\s*\I\i*\s*:$" contains=@gLabelGroup
syn match	gUserCont	display ";\s*\I\i*\s*:$" contains=@gLabelGroup
syn match	gUserCont	display "^\s*\I\i*\s*:[^:]"me=e-1 contains=@gLabelGroup
syn match	gUserCont	display ";\s*\I\i*\s*:[^:]"me=e-1 contains=@gLabelGroup
syn match	gUserLabel	display "\I\i*" contained

" Avoid recognizing most bitfields as labels
syn match	gBitField	display "^\s*\I\i*\s*:\s*[1-9]"me=e-1
syn match	gBitField	display ";\s*\I\i*\s*:\s*[1-9]"me=e-1


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version < 508
  command -nargs=+ HiLink hi link <args>
else
  command -nargs=+ HiLink hi def link <args>
endif

  HiLink gCommentL			gComment
  HiLink gCommentStart		gComment
  HiLink gLabel				Label
  HiLink gUserLabel			Label
  HiLink gConditional		Conditional
  HiLink gRepeat			Repeat
  HiLink gCharacter			Character
  HiLink gSpecialCharacter	gSpecial
  HiLink gNumber			Number
  HiLink gFloat				Float
  HiLink gParenError		gError
  HiLink gErrInParen		gError
  HiLink gErrInBracket		gError
  HiLink gErrInCurlyBracket	gError
  HiLink gCommentError		gError
  HiLink gCommentStartError	gError
  HiLink gSpaceError		gError
  HiLink gSpecialError		gError
  HiLink gError				Error
  HiLink gStatement			Statement
  HiLink gConstant			Constant
  HiLink gCommentString		gString
  HiLink gComment2String	gString
  HiLink gCommentSkip		gComment
  HiLink gString			String
  HiLink gComment			Comment
  HiLink gSpecial			SpecialChar
  HiLink gTodo				Todo
  HiLink gOperator			Operator
  HiLink gElement			Type
  HiLink gFunction			Function
  HiLink gMacro				Macro

  delcommand HiLink

let b:current_syntax = "gisdk"

" The whole bunch of functions for TransCAD 3.5.
" Comment out what you don't like.
syn keyword gFunction	Abs
syn keyword gFunction	Acos
syn keyword gFunction	Acosh
syn keyword gFunction	AddAnnotation
syn keyword gFunction	AddCDFLayer
syn keyword gFunction	AddIDField
syn keyword gFunction	AddImageLayer
syn keyword gFunction	AddLayer
syn keyword gFunction	AddLayerToWorkspace
syn keyword gFunction	AddLegendItem
syn keyword gFunction	AddLink
syn keyword gFunction	AddLRSLayer
syn keyword gFunction	AddMatrixCore
syn keyword gFunction	AddMenuItem
syn keyword gFunction	AddNode
syn keyword gFunction	AddPoint
syn keyword gFunction	AddRecord
syn keyword gFunction	AddRecords
syn keyword gFunction	AddRoute
syn keyword gFunction	AddRouteStops
syn keyword gFunction	AddRouteSystemLayer
syn keyword gFunction	AddRSPhysicalStops
syn keyword gFunction	AddShortestPathRoutes
syn keyword gFunction	AggregateMatrix
syn keyword gFunction	AggregateTable
syn keyword gFunction	ApplyOverlayTable
syn keyword gFunction	AreMatricesCompatible
syn keyword gFunction	ArrangeIcons
syn keyword gFunction	ArrayLength
syn keyword gFunction	ArrayMax
syn keyword gFunction	ArrayMin
syn keyword gFunction	ArrayPosition
syn keyword gFunction	Ascii
syn keyword gFunction	Asin
syn keyword gFunction	Asinh
syn keyword gFunction	Atan
syn keyword gFunction	Atan2
syn keyword gFunction	Atanh
syn keyword gFunction	AttachTableTranslation
syn keyword gFunction	Avg
syn keyword gFunction	Azimuth
syn keyword gFunction	BringAnnotationToFront
syn keyword gFunction	BuildInternalIndex
syn keyword gFunction	CascadeWindows
syn keyword gFunction	Ceil
syn keyword gFunction	CenterLayout
syn keyword gFunction	CenterMap
syn keyword gFunction	ChangeLinkStatus
syn keyword gFunction	ChangeNetworkSettings
syn keyword gFunction	Char
syn keyword gFunction	CheckStopwatch
syn keyword gFunction	ChooseColor
syn keyword gFunction	ChooseDirectory
syn keyword gFunction	ChooseFile
syn keyword gFunction	ChooseFileName
syn keyword gFunction	ChooseFiles
syn keyword gFunction	ChooseFont
syn keyword gFunction	Circle
syn keyword gFunction	CleanMilepostView
syn keyword gFunction	ClearDXFInfo
syn keyword gFunction	ClearThemeValues
syn keyword gFunction	ClickAndDragLayout
syn keyword gFunction	ClickCircle
syn keyword gFunction	ClickCoord
syn keyword gFunction	ClickCurve
syn keyword gFunction	ClickDragAndShow
syn keyword gFunction	ClickEllipse
syn keyword gFunction	ClickEllipseScope
syn keyword gFunction	ClickLayout
syn keyword gFunction	ClickLine
syn keyword gFunction	ClickPolyline
syn keyword gFunction	ClickRect
syn keyword gFunction	ClickRectScope
syn keyword gFunction	ClickScope
syn keyword gFunction	ClickShape
syn keyword gFunction	ClickText
syn keyword gFunction	CloseDbox
syn keyword gFunction	CloseEditor
syn keyword gFunction	CloseFigure
syn keyword gFunction	CloseFile
syn keyword gFunction	CloseLayout
syn keyword gFunction	CloseMap
syn keyword gFunction	CloseView
syn keyword gFunction	ColorCIE
syn keyword gFunction	ColorHLS
syn keyword gFunction	ColorHSV
syn keyword gFunction	ColorRGB
syn keyword gFunction	ColumnAggregate
syn keyword gFunction	CombineMatrices
syn keyword gFunction	ComputeIntersectionPercentages
syn keyword gFunction	ComputeStatistics
syn keyword gFunction	ConcatMatrices
syn keyword gFunction	ConstructSnapshot
syn keyword gFunction	ConvertAutomaticToManualLabels
syn keyword gFunction	ConvertToAreaDatabase
syn keyword gFunction	ConvertToLineDatabase
syn keyword gFunction	Coord
syn keyword gFunction	CoordInArea
syn keyword gFunction	CoordInScope
syn keyword gFunction	CoordToLineDistance
syn keyword gFunction	CopyArray
syn keyword gFunction	CopyDatabase
syn keyword gFunction	CopyFigureToClipboard
syn keyword gFunction	CopyFile
syn keyword gFunction	CopyLayoutToClipboard
syn keyword gFunction	CopyMapToClipboard
syn keyword gFunction	CopyMapToOLE
syn keyword gFunction	CopyMatrix
syn keyword gFunction	CopyMatrixStructure
syn keyword gFunction	CopyPoint
syn keyword gFunction	CopyTableFiles
syn keyword gFunction	Cos
syn keyword gFunction	Cosh
syn keyword gFunction	CreateBuffers
syn keyword gFunction	CreateChartTheme
syn keyword gFunction	CreateContinuousTheme
syn keyword gFunction	CreateDatabase
syn keyword gFunction	CreateDesirelineDB
syn keyword gFunction	CreateDirectory
syn keyword gFunction	CreateDotTheme
syn keyword gFunction	CreateEditor
syn keyword gFunction	CreateEditorByQuery
syn keyword gFunction	CreateExpression
syn keyword gFunction	CreateFigure
syn keyword gFunction	CreateGeographyArchive
syn keyword gFunction	CreateGrid
syn keyword gFunction	CreateGroup
syn keyword gFunction	CreateGroupByTheme
syn keyword gFunction	CreateLayout
syn keyword gFunction	CreateLegend
syn keyword gFunction	CreateMap
syn keyword gFunction	CreateMatrix
syn keyword gFunction	CreateMatrixCurrency
syn keyword gFunction	CreateMatrixEditor
syn keyword gFunction	CreateMatrixFromView
syn keyword gFunction	CreateMatrixIndex
syn keyword gFunction	CreateMilepostTable
syn keyword gFunction	CreateNetwork
syn keyword gFunction	CreateNodeField
syn keyword gFunction	CreateProgressBar
syn keyword gFunction	CreateRouteSystem
syn keyword gFunction	CreateRouteSystemFromTables
syn keyword gFunction	CreateSet
syn keyword gFunction	CreateSnapshot
syn keyword gFunction	CreateStopSkipButtons
syn keyword gFunction	CreateStopwatch
syn keyword gFunction	CreateStreetCDF
syn keyword gFunction	CreateTable
syn keyword gFunction	CreateTableFromMatrix
syn keyword gFunction	CreateTheme
syn keyword gFunction	CreateTimer
syn keyword gFunction	CreateTransitNetwork
syn keyword gFunction	DayOfWeek
syn keyword gFunction	DecideJoinType
syn keyword gFunction	DeleteDatabase
syn keyword gFunction	DeleteFile
syn keyword gFunction	DeleteLink
syn keyword gFunction	DeleteMatrixIndex
syn keyword gFunction	DeleteNetworkInformationItem
syn keyword gFunction	DeleteNode
syn keyword gFunction	DeletePoint
syn keyword gFunction	DeleteRecord
syn keyword gFunction	DeleteRecordsInSet
syn keyword gFunction	DeleteRoute
syn keyword gFunction	DeleteRoutes
syn keyword gFunction	DeleteRouteStops
syn keyword gFunction	DeleteRouteSystem
syn keyword gFunction	DeleteSet
syn keyword gFunction	DeleteSnapshot
syn keyword gFunction	DeleteTableFiles
syn keyword gFunction	DestroyExpression
syn keyword gFunction	DestroyLegend
syn keyword gFunction	DestroyProgressBar
syn keyword gFunction	DestroyStopwatch
syn keyword gFunction	DestroyTheme
syn keyword gFunction	DestroyTimer
syn keyword gFunction	DetachTableTranslation
syn keyword gFunction	DisableItem
syn keyword gFunction	DisableMenuItems
syn keyword gFunction	DisableProgressBar
syn keyword gFunction	DivideMatrixElements
syn keyword gFunction	DragMapToOLE
syn keyword gFunction	DrawLayout
syn keyword gFunction	DrawMapAnnotations
syn keyword gFunction	DropAnnotation
syn keyword gFunction	DropAnnotations
syn keyword gFunction	DropLayer
syn keyword gFunction	DropLayerFromWorkspace
syn keyword gFunction	DropLegendItem
syn keyword gFunction	DropMatrixCore
syn keyword gFunction	DropSelectedAnnotations
syn keyword gFunction	DShortestPath
syn keyword gFunction	DuplicateAnnotation
syn keyword gFunction	EditorPrintSetup
syn keyword gFunction	EnableItem
syn keyword gFunction	EnableMenuItems
syn keyword gFunction	EnableProgressBar
syn keyword gFunction	EvaluateMatrixExpression
syn keyword gFunction	ExcludeArrayElements
syn keyword gFunction	Exit
syn keyword gFunction	Exp
syn keyword gFunction	ExpandGeographyArchive
syn keyword gFunction	ExportArcViewShape
syn keyword gFunction	ExportCSV
syn keyword gFunction	ExportDXF
syn keyword gFunction	ExportEditor
syn keyword gFunction	ExportGeography
syn keyword gFunction	ExportMatrix
syn keyword gFunction	ExportTableTranslation
syn keyword gFunction	ExportView
syn keyword gFunction	Factorial
syn keyword gFunction	FieldsSupportAggregations
syn keyword gFunction	FieldsSupportDescriptions
syn keyword gFunction	FigurePrintSetup
syn keyword gFunction	FileAtEOF
syn keyword gFunction	FileCheckUsage
syn keyword gFunction	FileGetPosition
syn keyword gFunction	FileReadDouble
syn keyword gFunction	FileReadFloat
syn keyword gFunction	FileReadLongInt
syn keyword gFunction	FileReadShortInt
syn keyword gFunction	FileReadString
syn keyword gFunction	FileSetPosition
syn keyword gFunction	FileWriteDouble
syn keyword gFunction	FileWriteFloat
syn keyword gFunction	FileWriteLongInt
syn keyword gFunction	FileWriteShortInt
syn keyword gFunction	FileWriteString
syn keyword gFunction	FillMatrix
syn keyword gFunction	FillStyle
syn keyword gFunction	FindOption
syn keyword gFunction	FindOptionValue
syn keyword gFunction	FindPhysicalStop
syn keyword gFunction	FitBezier
syn keyword gFunction	Floor
syn keyword gFunction	Format
syn keyword gFunction	GenerateBezier
syn keyword gFunction	GeneratePalette
syn keyword gFunction	GetAbsoluteWindowSize
syn keyword gFunction	GetAnnotation
syn keyword gFunction	GetAnnotations
syn keyword gFunction	GetArea
syn keyword gFunction	GetArrayScope
syn keyword gFunction	GetArrowheads
syn keyword gFunction	GetAVILength
syn keyword gFunction	GetBNAInfo
syn keyword gFunction	GetBorderColor
syn keyword gFunction	GetBorderStyle
syn keyword gFunction	GetBorderWidth
syn keyword gFunction	GetCentroid
syn keyword gFunction	GetClickControl
syn keyword gFunction	GetClickShift
syn keyword gFunction	GetColorCIE
syn keyword gFunction	GetColorHLS
syn keyword gFunction	GetColorHSV
syn keyword gFunction	GetColumnArray
syn keyword gFunction	GetCoordsFromLinks
syn keyword gFunction	GetDateAndTime
syn keyword gFunction	GetDBFiles
syn keyword gFunction	GetDBInfo
syn keyword gFunction	GetDBLayers
syn keyword gFunction	GetDEMInfo
syn keyword gFunction	GetDirectoryInfo
syn keyword gFunction	GetDiskSpace
syn keyword gFunction	GetDisplayedThemes
syn keyword gFunction	GetDisplayStatus
syn keyword gFunction	GetDistance
syn keyword gFunction	GetDLGInfo
syn keyword gFunction	GetDrives
syn keyword gFunction	GetDXFInfo
syn keyword gFunction	GetEditableFields
syn keyword gFunction	GetEditorFile
syn keyword gFunction	GetEditorHighlight
syn keyword gFunction	GetEditorOption
syn keyword gFunction	GetEditorSaveFlag
syn keyword gFunction	GetEditorType
syn keyword gFunction	GetEditorValues
syn keyword gFunction	GetEditorView
syn keyword gFunction	GetEndpoints
syn keyword gFunction	GetEnvironmentVariable
syn keyword gFunction	GetExpressionInfo
syn keyword gFunction	GetExpressions
syn keyword gFunction	GetField
syn keyword gFunction	GetFieldAggregations
syn keyword gFunction	GetFieldDecimals
syn keyword gFunction	GetFieldDescription
syn keyword gFunction	GetFieldFormat
syn keyword gFunction	GetFieldInfo
syn keyword gFunction	GetFieldProtection
syn keyword gFunction	GetFields
syn keyword gFunction	GetFieldType
syn keyword gFunction	GetFieldValues
syn keyword gFunction	GetFieldWidth
syn keyword gFunction	GetFigureFile
syn keyword gFunction	GetFigureSaveFlag
syn keyword gFunction	GetFileInfo
syn keyword gFunction	GetFillColor
syn keyword gFunction	GetFillStyle
syn keyword gFunction	GetFillStyleTransparency
syn keyword gFunction	GetFirstRecord
syn keyword gFunction	GetFontInfo
syn keyword gFunction	GetFontNames
syn keyword gFunction	GetGIRASInfo
syn keyword gFunction	GetGPSInfo
syn keyword gFunction	GetHardLinkClass
syn keyword gFunction	GetHatch
syn keyword gFunction	GetIcon
syn keyword gFunction	GetIconColor
syn keyword gFunction	GetIconSize
syn keyword gFunction	GetImageFileInfo
syn keyword gFunction	GetItemSelection
syn keyword gFunction	GetLabelExpression
syn keyword gFunction	GetLabelOptions
syn keyword gFunction	GetLastError
syn keyword gFunction	GetLastRecord
syn keyword gFunction	GetLayer
syn keyword gFunction	GetLayerAutoscale
syn keyword gFunction	GetLayerDB
syn keyword gFunction	GetLayerDBPos
syn keyword gFunction	GetLayerInfo
syn keyword gFunction	GetLayerNames
syn keyword gFunction	GetLayerPosition
syn keyword gFunction	GetLayers
syn keyword gFunction	GetLayerScale
syn keyword gFunction	GetLayerScope
syn keyword gFunction	GetLayerSetsLabel
syn keyword gFunction	GetLayerType
syn keyword gFunction	GetLayerVisibility
syn keyword gFunction	GetLayout
syn keyword gFunction	GetLayoutFile
syn keyword gFunction	GetLayoutOptions
syn keyword gFunction	GetLayoutPages
syn keyword gFunction	GetLayoutPrintSettings
syn keyword gFunction	GetLayoutPrintSize
syn keyword gFunction	GetLayoutSaveFlag
syn keyword gFunction	GetLayoutScale
syn keyword gFunction	GetLegend
syn keyword gFunction	GetLegendDisplayStatus
syn keyword gFunction	GetLegendOptions
syn keyword gFunction	GetLegendSettings
syn keyword gFunction	GetLine
syn keyword gFunction	GetLineColor
syn keyword gFunction	GetLineDistance
syn keyword gFunction	GetLineStyle
syn keyword gFunction	GetLineWidth
syn keyword gFunction	GetLinkLayer
syn keyword gFunction	GetLRSInfo
syn keyword gFunction	GetLRSLayers
syn keyword gFunction	GetManualLabelOptions
syn keyword gFunction	GetMap
syn keyword gFunction	GetMapBackground
syn keyword gFunction	GetMapDefaultScope
syn keyword gFunction	GetMapFile
syn keyword gFunction	GetMapLabelOptions
syn keyword gFunction	GetMapLayers
syn keyword gFunction	GetMapNames
syn keyword gFunction	GetMapNetworkFileName
syn keyword gFunction	GetMapOptions
syn keyword gFunction	GetMappableFieldIndices
syn keyword gFunction	GetMappableFields
syn keyword gFunction	GetMapProjection
syn keyword gFunction	GetMaps
syn keyword gFunction	GetMapSaveFlag
syn keyword gFunction	GetMapScope
syn keyword gFunction	GetMapTitle
syn keyword gFunction	GetMapUnitNames
syn keyword gFunction	GetMapUnits
syn keyword gFunction	GetMapWindowScope
syn keyword gFunction	GetMatrices
syn keyword gFunction	GetMatrix
syn keyword gFunction	GetMatrixBaseIndex
syn keyword gFunction	GetMatrixColumnLabels
syn keyword gFunction	GetMatrixCore
syn keyword gFunction	GetMatrixCoreNames
syn keyword gFunction	GetMatrixEditorColumnWidth
syn keyword gFunction	GetMatrixEditorCurrency
syn keyword gFunction	GetMatrixEditorFormat
syn keyword gFunction	GetMatrixEditorLabels
syn keyword gFunction	GetMatrixEditorSortOrder
syn keyword gFunction	GetMatrixFile
syn keyword gFunction	GetMatrixFileInfo
syn keyword gFunction	GetMatrixIndex
syn keyword gFunction	GetMatrixIndexIDs
syn keyword gFunction	GetMatrixIndexNames
syn keyword gFunction	GetMatrixInfo
syn keyword gFunction	GetMatrixMarginals
syn keyword gFunction	GetMatrixName
syn keyword gFunction	GetMatrixNames
syn keyword gFunction	GetMatrixReadOnly
syn keyword gFunction	GetMatrixRowLabels
syn keyword gFunction	GetMatrixValue
syn keyword gFunction	GetMatrixValues
syn keyword gFunction	GetMenu
syn keyword gFunction	GetMergedArea
syn keyword gFunction	GetMIFInfo
syn keyword gFunction	GetNetworkDBName
syn keyword gFunction	GetNetworkInfo
syn keyword gFunction	GetNetworkInformationItem
syn keyword gFunction	GetNetworkInformationLabels
syn keyword gFunction	GetNextRecord
syn keyword gFunction	GetNodeFromLinks
syn keyword gFunction	GetNodeFromRoute
syn keyword gFunction	GetNodeLayer
syn keyword gFunction	GetNodeLinks
syn keyword gFunction	GetNodesFromLinks
syn keyword gFunction	GetNTFInfo
syn keyword gFunction	GetNTFVolume
syn keyword gFunction	GetODBCDataSourceInfo
syn keyword gFunction	GetODBCDataSourceNames
syn keyword gFunction	GetODBCFields
syn keyword gFunction	GetODBCTables
syn keyword gFunction	GetOffset
syn keyword gFunction	GetOracleFields
syn keyword gFunction	GetOracleTables
syn keyword gFunction	GetPaperUnitNames
syn keyword gFunction	GetPaperUnits
syn keyword gFunction	GetPlatformVersion
syn keyword gFunction	GetPoint
syn keyword gFunction	GetPolygonArea
syn keyword gFunction	GetPrevRecord
syn keyword gFunction	GetPrinters
syn keyword gFunction	GetPrintMargins
syn keyword gFunction	GetProgram
syn keyword gFunction	GetProjectionScope
syn keyword gFunction	GetReadOnly
syn keyword gFunction	GetReadOnlyFields
syn keyword gFunction	GetRecord
syn keyword gFunction	GetRecordCount
syn keyword gFunction	GetRecordScope
syn keyword gFunction	GetRecordValues
syn keyword gFunction	GetRecordsValues
syn keyword gFunction	GetRouteAttributes
syn keyword gFunction	GetRouteID
syn keyword gFunction	GetRouteIDs
syn keyword gFunction	GetRouteLinks
syn keyword gFunction	GetRouteMilepost
syn keyword gFunction	GetRouteNam
syn keyword gFunction	GetRouteNames
syn keyword gFunction	GetRouteSide
syn keyword gFunction	GetRouteStops
syn keyword gFunction	GetRouteSystemChanneling
syn keyword gFunction	GetRouteSystemFields
syn keyword gFunction	GetRouteSystemFiles
syn keyword gFunction	GetRouteSystemInfo
syn keyword gFunction	GetRouteSystemLayer
syn keyword gFunction	GetRowOrder
syn keyword gFunction	GetSample
syn keyword gFunction	GetScale
syn keyword gFunction	GetScopeCorners
syn keyword gFunction	GetScopeRect
syn keyword gFunction	GetScreenResolution
syn keyword gFunction	GetSelectDisplay
syn keyword gFunction	GetSelectedAnnotations
syn keyword gFunction	GetSelectInclusion
syn keyword gFunction	GetSetCount
syn keyword gFunction	GetSetIDs
syn keyword gFunction	GetSetPosition
syn keyword gFunction	GetSets
syn keyword gFunction	GetSetScope
syn keyword gFunction	GetSnapshot
syn keyword gFunction	GetSnapshots
syn keyword gFunction	GetStopLocation
syn keyword gFunction	GetStopRouteName
syn keyword gFunction	GetStopsRouteNames
syn keyword gFunction	GetStreetLocation
syn keyword gFunction	GetSystemDirectory
syn keyword gFunction	GetTableModifyFlag
syn keyword gFunction	GetTableStructure
syn keyword gFunction	GetTempFileName
syn keyword gFunction	GetTempPath
syn keyword gFunction	GetTheme
syn keyword gFunction	GetThemeClassCounts
syn keyword gFunction	GetThemeClasses
syn keyword gFunction	GetThemeClassLabels
syn keyword gFunction	GetThemeClassValues
syn keyword gFunction	GetThemeFillColors
syn keyword gFunction	GetThemeFillStyles
syn keyword gFunction	GetThemeIconColors
syn keyword gFunction	GetThemeIcons
syn keyword gFunction	GetThemeIconSizes
syn keyword gFunction	GetThemeLineColors
syn keyword gFunction	GetThemeLineStyles
syn keyword gFunction	GetThemeLineWidths
syn keyword gFunction	GetThemeOptions
syn keyword gFunction	GetThemes
syn keyword gFunction	GetThemeSamples
syn keyword gFunction	GetThemeStatistics
syn keyword gFunction	GetTool
syn keyword gFunction	GetUnitSize
syn keyword gFunction	GetView
syn keyword gFunction	GetViewLayer
syn keyword gFunction	GetViewNames
syn keyword gFunction	GetViewReadOnly
syn keyword gFunction	GetViews
syn keyword gFunction	GetViewScope
syn keyword gFunction	GetViewStructure
syn keyword gFunction	GetViewTableInfo
syn keyword gFunction	GetWAVLength
syn keyword gFunction	GetWindowName
syn keyword gFunction	GetWindowPosition
syn keyword gFunction	GetWindows
syn keyword gFunction	GetWindowSize
syn keyword gFunction	GetWindowType
syn keyword gFunction	GreatCircleMidpoint
syn keyword gFunction	HideDbox
syn keyword gFunction	HideItem
syn keyword gFunction	HideLegend
syn keyword gFunction	HideMapLabels
syn keyword gFunction	HideTheme
syn keyword gFunction	IDToRecordHandle
syn keyword gFunction	ImportArcViewShape
syn keyword gFunction	ImportBNA
syn keyword gFunction	ImportBTS
syn keyword gFunction	ImportCSV
syn keyword gFunction	ImportDEM
syn keyword gFunction	ImportDLG
syn keyword gFunction	ImportDXF
syn keyword gFunction	ImportE00
syn keyword gFunction	ImportFromView
syn keyword gFunction	ImportGIRAS
syn keyword gFunction	ImportMatrix
syn keyword gFunction	ImportMIF
syn keyword gFunction	ImportNTF
syn keyword gFunction	ImportTiger
syn keyword gFunction	InsertArrayElements
syn keyword gFunction	IntToString
syn keyword gFunction	IsImageRegisterable
syn keyword gFunction	IsLayer
syn keyword gFunction	IsLayerExportable
syn keyword gFunction	IsMatrixSquare
syn keyword gFunction	IsWindow
syn keyword gFunction	JoinLinks
syn keyword gFunction	JoinNodes
syn keyword gFunction	JoinTableToLayer
syn keyword gFunction	JoinViews
syn keyword gFunction	Kurtosis
syn keyword gFunction	LaunchDocument
syn keyword gFunction	LaunchProgram
syn keyword gFunction	LayoutPrintSetup
syn keyword gFunction	LayoutProperties
syn keyword gFunction	Left
syn keyword gFunction	Len
syn keyword gFunction	LineStyle
syn keyword gFunction	ListTableFiles
syn keyword gFunction	LoadArray
syn keyword gFunction	LoadNetworkMovementTable
syn keyword gFunction	LoadResourceFile
syn keyword gFunction	LocateDBs
syn keyword gFunction	LocateNearestRecord
syn keyword gFunction	LocateNearestRecords
syn keyword gFunction	LocateRecord
syn keyword gFunction	Log
syn keyword gFunction	Log10
syn keyword gFunction	Lower
syn keyword gFunction	LPad
syn keyword gFunction	MapCoordToPixelXY
syn keyword gFunction	MapCoordToXY
syn keyword gFunction	MapPixelXYToCoord
syn keyword gFunction	MapPrintSetup
syn keyword gFunction	MapXYToCoord
syn keyword gFunction	MatrixCellbyCell
syn keyword gFunction	Max
syn keyword gFunction	MaximizeWindow
syn keyword gFunction	Mean
syn keyword gFunction	Median
syn keyword gFunction	MergeByValue
syn keyword gFunction	MergeGeography
syn keyword gFunction	MergeMatrixElements
syn keyword gFunction	MergeMilepostViews
syn keyword gFunction	MessageBox
syn keyword gFunction	Min
syn keyword gFunction	MinimizeWindow
syn keyword gFunction	Mod
syn keyword gFunction	ModifyRoute
syn keyword gFunction	ModifyRouteSystem
syn keyword gFunction	ModifyTable
syn keyword gFunction	MoveAlongGreatCircle
syn keyword gFunction	MoveAnnotation
syn keyword gFunction	MoveNode
syn keyword gFunction	MovePoint
syn keyword gFunction	MultiplyMatrix
syn keyword gFunction	MultiplyMatrixElements
syn keyword gFunction	NetworkEnableDisableLinksByConditions
syn keyword gFunction	NetworkEnableDisableLinksByExpression
syn keyword gFunction	NetworkForwardStar
syn keyword gFunction	NetworkGetTurnPenalty
syn keyword gFunction	NetworkLinkCosts
syn keyword gFunction	NetworkLinkID
syn keyword gFunction	NetworkLinkIDs
syn keyword gFunction	NetworkLinkLocate
syn keyword gFunction	NetworkLinks
syn keyword gFunction	NetworkLinkVarNames
syn keyword gFunction	NetworkMovementTableLoaded
syn keyword gFunction	NetworkNodeCosts
syn keyword gFunction	NetworkNodeID
syn keyword gFunction	NetworkNodeIDs
syn keyword gFunction	NetworkNodeLocate
syn keyword gFunction	NetworkNodes
syn keyword gFunction	NetworkNodeVarNames
syn keyword gFunction	NetworkVerifyExpression
syn keyword gFunction	NextDate
syn keyword gFunction	NextOccurrence
syn keyword gFunction	OneWayTable
syn keyword gFunction	OpenEditor
syn keyword gFunction	OpenEditorFromAnnotation
syn keyword gFunction	OpenFigure
syn keyword gFunction	OpenFigureFromAnnotation
syn keyword gFunction	OpenFile
syn keyword gFunction	OpenLayout
syn keyword gFunction	OpenMap
syn keyword gFunction	OpenMapFromAnnotation
syn keyword gFunction	OpenMatrix
syn keyword gFunction	OpenTable
syn keyword gFunction	OpenTableEx
syn keyword gFunction	OpenWorkspace
syn keyword gFunction	OptimizeDatabase
syn keyword gFunction	ParseString
syn keyword gFunction	PathCoords
syn keyword gFunction	PathDirections
syn keyword gFunction	Percentile
syn keyword gFunction	PlaySlideshow
syn keyword gFunction	PlaySound
syn keyword gFunction	Position
syn keyword gFunction	Pow
syn keyword gFunction	PrintEditor
syn keyword gFunction	PrintFigure
syn keyword gFunction	PrintLayout
syn keyword gFunction	PrintMap
syn keyword gFunction	Proper
syn keyword gFunction	PushAnnotationToBack
syn keyword gFunction	PutInRecycleBin
syn keyword gFunction	RandomNumber
syn keyword gFunction	ReadArray
syn keyword gFunction	ReadLine
syn keyword gFunction	ReadNetwork
syn keyword gFunction	ReadSizedArray
syn keyword gFunction	RealToInt
syn keyword gFunction	RealToString
syn keyword gFunction	RecordHandleToID
syn keyword gFunction	RedrawEditor
syn keyword gFunction	RedrawMap
syn keyword gFunction	RegisterImage
syn keyword gFunction	ReloadRouteSystem
syn keyword gFunction	RemoveDirectory
syn keyword gFunction	RemoveMenuItem
syn keyword gFunction	RenameDatabase
syn keyword gFunction	RenameField
syn keyword gFunction	RenameLayer
syn keyword gFunction	RenameMatrix
syn keyword gFunction	RenameSet
syn keyword gFunction	RenameTableFiles
syn keyword gFunction	ResetCursor
syn keyword gFunction	ReshapeLink
syn keyword gFunction	RestoreWindow
syn keyword gFunction	Return
syn keyword gFunction	Right
syn keyword gFunction	Round
syn keyword gFunction	RouteDirections
syn keyword gFunction	RPad
syn keyword gFunction	RubberSheet
syn keyword gFunction	RunDbox
syn keyword gFunction	RunMacro
syn keyword gFunction	RunProgram
syn keyword gFunction	SampleArea
syn keyword gFunction	SampleLine
syn keyword gFunction	SamplePoint
syn keyword gFunction	SampleValues
syn keyword gFunction	SaveArray
syn keyword gFunction	SaveEditor
syn keyword gFunction	SaveEditorToBitmap
syn keyword gFunction	SaveEditorToImage
syn keyword gFunction	SaveEditorToJPEG
syn keyword gFunction	SaveFigure
syn keyword gFunction	SaveFigureToBitmap
syn keyword gFunction	SaveFigureToImage
syn keyword gFunction	SaveFigureToJPEG
syn keyword gFunction	SaveFigureToMetafile
syn keyword gFunction	SaveLayout
syn keyword gFunction	SaveLayoutToBitmap
syn keyword gFunction	SaveLayoutToImage
syn keyword gFunction	SaveLayoutToJPEG
syn keyword gFunction	SaveLayoutToMetafile
syn keyword gFunction	SaveLegendToImage
syn keyword gFunction	SaveMap
syn keyword gFunction	SaveMapToBitmap
syn keyword gFunction	SaveMapToImage
syn keyword gFunction	SaveMapToJPEG
syn keyword gFunction	SaveMapToMetafile
syn keyword gFunction	SaveWorkspace
syn keyword gFunction	Scope
syn keyword gFunction	ScopeInScope
syn keyword gFunction	ScopeIntersect
syn keyword gFunction	ScopeOnScope
syn keyword gFunction	ScopeUnion
syn keyword gFunction	SelectAll
syn keyword gFunction	SelectAllAnnotations
syn keyword gFunction	SelectAnnotation
syn keyword gFunction	SelectByCircle
syn keyword gFunction	SelectByCoord
syn keyword gFunction	SelectByIDFile
syn keyword gFunction	SelectByIDs
syn keyword gFunction	SelectByMapWindow
syn keyword gFunction	SelectByQuery
syn keyword gFunction	SelectByQueryFile
syn keyword gFunction	SelectByScope
syn keyword gFunction	SelectByShape
syn keyword gFunction	SelectByVicinity
syn keyword gFunction	SelectConnectedLinks
syn keyword gFunction	SelectFromNetwork
syn keyword gFunction	SelectNearestFeatures
syn keyword gFunction	SelectNone
syn keyword gFunction	SelectRecord
syn keyword gFunction	SelfAggregate
syn keyword gFunction	SendMail
syn keyword gFunction	SendProgramMessage
syn keyword gFunction	SendProgramRequest
syn keyword gFunction	SetAlternateInterface
syn keyword gFunction	SetAND
syn keyword gFunction	SetAnnotation
syn keyword gFunction	SetArrowheads
syn keyword gFunction	SetBorderColor
syn keyword gFunction	SetBorderStyle
syn keyword gFunction	SetBorderWidth
syn keyword gFunction	SetCheck
syn keyword gFunction	SetColumnArray
syn keyword gFunction	SetCopy
syn keyword gFunction	SetCursor
syn keyword gFunction	SetDefaultDisplay
syn keyword gFunction	SetDefaults
syn keyword gFunction	SetDisplayStatus
syn keyword gFunction	SetEditorHighlight
syn keyword gFunction	SetEditorOption
syn keyword gFunction	SetEditorValues
syn keyword gFunction	SetEditorView
syn keyword gFunction	SetEnvironmentVariable
syn keyword gFunction	SetFieldDecimals
syn keyword gFunction	SetFieldFormat
syn keyword gFunction	SetFieldProtection
syn keyword gFunction	SetFieldWidth
syn keyword gFunction	SetFillColor
syn keyword gFunction	SetFillStyle
syn keyword gFunction	SetFillStyleTransparency
syn keyword gFunction	SetHatch
syn keyword gFunction	SetHelpFile
syn keyword gFunction	SetIcon
syn keyword gFunction	SetIconColor
syn keyword gFunction	SetIconSize
syn keyword gFunction	SetInvert
syn keyword gFunction	SetItem
syn keyword gFunction	SetItemSelection
syn keyword gFunction	SetLabelOptions
syn keyword gFunction	SetLabels
syn keyword gFunction	SetLayer
syn keyword gFunction	SetLayerPosition
syn keyword gFunction	SetLayerScale
syn keyword gFunction	SetLayerSetsLabel
syn keyword gFunction	SetLayerVisibility
syn keyword gFunction	SetLayoutOptions
syn keyword gFunction	SetLayoutPages
syn keyword gFunction	SetLayoutPrevious
syn keyword gFunction	SetLayoutPrintSettings
syn keyword gFunction	SetLayoutScale
syn keyword gFunction	SetLegendDisplayStatus
syn keyword gFunction	SetLegendItemPosition
syn keyword gFunction	SetLegendOptions
syn keyword gFunction	SetLegendSettings
syn keyword gFunction	SetLineColor
syn keyword gFunction	SetLineStyle
syn keyword gFunction	SetLineWidth
syn keyword gFunction	SetLinkDirections
syn keyword gFunction	SetManualLabels
syn keyword gFunction	SetMap
syn keyword gFunction	SetMapBackground
syn keyword gFunction	SetMapDefaultScope
syn keyword gFunction	SetMapFile
syn keyword gFunction	SetMapLabelOptions
syn keyword gFunction	SetMapNetworkFileName
syn keyword gFunction	SetMapOptions
syn keyword gFunction	SetMapPrevious
syn keyword gFunction	SetMapProjection
syn keyword gFunction	SetMapRedraw
syn keyword gFunction	SetMapSaveFlag
syn keyword gFunction	SetMapScope
syn keyword gFunction	SetMapTitle
syn keyword gFunction	SetMapUnits
syn keyword gFunction	SetMatrix
syn keyword gFunction	SetMatrixCore
syn keyword gFunction	SetMatrixCoreName
syn keyword gFunction	SetMatrixCoreNames
syn keyword gFunction	SetMatrixEditorColumnWidth
syn keyword gFunction	SetMatrixEditorCurrency
syn keyword gFunction	SetMatrixEditorFormat
syn keyword gFunction	SetMatrixEditorLabels
syn keyword gFunction	SetMatrixEditorSortOrder
syn keyword gFunction	SetMatrixIndex
syn keyword gFunction	SetMatrixIndexName
syn keyword gFunction	SetMatrixIndexNames
syn keyword gFunction	SetMatrixValue
syn keyword gFunction	SetMatrixValues
syn keyword gFunction	SetMRUFiles
syn keyword gFunction	SetNetworkInformationItem
syn keyword gFunction	SetOffset
syn keyword gFunction	SetOR
syn keyword gFunction	SetPaperUnits
syn keyword gFunction	SetPrintMargins
syn keyword gFunction	SetRandomSeed
syn keyword gFunction	SetRecord
syn keyword gFunction	SetRecordValues
syn keyword gFunction	SetRouteMilepost
syn keyword gFunction	SetRouteSystemChanneling
syn keyword gFunction	SetRowOrder
syn keyword gFunction	SetSampleText
syn keyword gFunction	SetScale
syn keyword gFunction	SetSearchPath
syn keyword gFunction	SetSelectDisplay
syn keyword gFunction	SetSelectInclusion
syn keyword gFunction	SetSetPosition
syn keyword gFunction	SetStatus
syn keyword gFunction	SetStatusBar
syn keyword gFunction	SetThemeClassLabel
syn keyword gFunction	SetThemeClassLabels
syn keyword gFunction	SetThemeFillColors
syn keyword gFunction	SetThemeFillStyles
syn keyword gFunction	SetThemeIconColors
syn keyword gFunction	SetThemeIcons
syn keyword gFunction	SetThemeIconSizes
syn keyword gFunction	SetThemeLineColors
syn keyword gFunction	SetThemeLineStyles
syn keyword gFunction	SetThemeLineWidths
syn keyword gFunction	SetThemeOptions
syn keyword gFunction	SetTool
syn keyword gFunction	SetView
syn keyword gFunction	SetViewReadOnly
syn keyword gFunction	SetVisibleRectangle
syn keyword gFunction	SetWindow
syn keyword gFunction	SetWindowPosition
syn keyword gFunction	SetWindowSize
syn keyword gFunction	SetWindowSizePixels
syn keyword gFunction	SetXOR
syn keyword gFunction	ShortestPath
syn keyword gFunction	ShortestPathTree
syn keyword gFunction	ShortestTurnPath
syn keyword gFunction	ShortestTurnPathTree
syn keyword gFunction	ShortestXferPath
syn keyword gFunction	ShortestXferPathTree
syn keyword gFunction	ShowArray
syn keyword gFunction	ShowBitmap
syn keyword gFunction	ShowDbox
syn keyword gFunction	ShowItem
syn keyword gFunction	ShowLegend
syn keyword gFunction	ShowMessage
syn keyword gFunction	ShowSnapshot
syn keyword gFunction	ShowTheme
syn keyword gFunction	Sign
syn keyword gFunction	Sin
syn keyword gFunction	Sinh
syn keyword gFunction	Skew
syn keyword gFunction	Sleep
syn keyword gFunction	SnapStopsToRouteSystem
syn keyword gFunction	SnapStopToLinks
syn keyword gFunction	SnapStopToRoute
syn keyword gFunction	SortArray
syn keyword gFunction	SortSet
syn keyword gFunction	SplitLink
syn keyword gFunction	SplitNode
syn keyword gFunction	SplitPath
syn keyword gFunction	SplitString
syn keyword gFunction	Sqrt
syn keyword gFunction	SqueezeDatabase
syn keyword gFunction	StartDebugger
syn keyword gFunction	StartGPS
syn keyword gFunction	Std
syn keyword gFunction	StopGPS
syn keyword gFunction	String
syn keyword gFunction	StringLength
syn keyword gFunction	StringToInt
syn keyword gFunction	StringToReal
syn keyword gFunction	Subarray
syn keyword gFunction	Substitute
syn keyword gFunction	Substring
syn keyword gFunction	Sum
syn keyword gFunction	TableHasTranslation
syn keyword gFunction	TagLayer
syn keyword gFunction	Tan
syn keyword gFunction	Tanh
syn keyword gFunction	TestMapProjection
syn keyword gFunction	TestTheme
syn keyword gFunction	TigerVersion
syn keyword gFunction	TileWindows
syn keyword gFunction	TimeWindowTSP
syn keyword gFunction	TransposeMatrix
syn keyword gFunction	Trim
syn keyword gFunction	TSP
syn keyword gFunction	TSPFromSet
syn keyword gFunction	TwoWayTable
syn keyword gFunction	TypeOf
syn keyword gFunction	UnRegisterImageFile
syn keyword gFunction	UnselectRecord
syn keyword gFunction	UpdateDbox
syn keyword gFunction	UpdateMatrixFromView
syn keyword gFunction	UpdateNetworkCost
syn keyword gFunction	UpdateProgressBar
syn keyword gFunction	Upper
syn keyword gFunction	Value
syn keyword gFunction	Var
syn keyword gFunction	VerifyExpression
syn keyword gFunction	VerifyIndex
syn keyword gFunction	VerifyQuery
syn keyword gFunction	VerifyRouteSystem
syn keyword gFunction	WeightedMatrixSum
syn keyword gFunction	Word
syn keyword gFunction	WriteArray
syn keyword gFunction	WriteArraySeparated
syn keyword gFunction	WriteLine
syn keyword gFunction	WriteNetwork
syn keyword gFunction	ZoomAndCenterMap
syn keyword gFunction	ZoomLayout
syn keyword gFunction	ZoomMap
