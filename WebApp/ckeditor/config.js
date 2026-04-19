
CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	//config.language = 'vn';
	//config.uiColor = '#AADC6E';
	//config.extraPlugins = 'imageuploader';
	config.extraPlugins = 'pastebase64';	
	config.height = 200;
	config.toolbarCanCollapse = true;
	config.extraPlugins = 'autogrow';
	config.autoGrow_minHeight = 200;
	config.autoGrow_maxHeight = 600;
	config.autoGrow_bottomSpace = 0;

	config.toolbarGroups = [
		{ name: 'styles', groups: [ 'styles' ] },
		{ name: 'clipboard', groups: [ 'clipboard', 'undo' ] },
		{ name: 'editing', groups: [ 'find', 'selection', 'spellchecker', 'editing' ] },
		{ name: 'forms', groups: [ 'forms' ] },
		{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
		{ name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi', 'paragraph' ] },
		{ name: 'links', groups: [ 'links' ] },
		{ name: 'insert', groups: [ 'insert' ] },
		{ name: 'colors', groups: [ 'colors' ] },
		{ name: 'tools', groups: [ 'tools' ] },
		{ name: 'others', groups: [ 'others' ] },
		{ name: 'about', groups: [ 'about' ] },
		{ name: 'document', groups: [ 'mode', 'document', 'doctools' ] }
	];

	config.removeButtons = 'Save,NewPage,Preview,Print,Templates,Cut,Copy,Paste,PasteText,PasteFromWord,Find,Replace,Redo,SelectAll,Scayt,Form,Checkbox,Radio,TextField,Textarea,Select,Button,ImageButton,HiddenField,Strike,Subscript,Superscript,CopyFormatting,RemoveFormat,CreateDiv,BidiLtr,BidiRtl,Language,About,ShowBlocks,Maximize,Iframe,PageBreak,Flash,EasyImageUpload,SpecialChar,Anchor,Unlink,JustifyLeft,JustifyCenter,JustifyRight,JustifyBlock,Styles,Font,FontSize,Smiley,Undo';

};
