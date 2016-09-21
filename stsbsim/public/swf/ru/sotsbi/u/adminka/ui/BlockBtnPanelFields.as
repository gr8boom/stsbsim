package ru.sotsbi.u.adminka.ui {
    public class BlockBtnPanelFields extends PanelFields
    {
		private var _attributes:Array;
		public function BlockBtnPanelFields(a:Array = null)
        {
			if(a == null){
				a = new Array();
			}
			if(!a['label']){
				a['label'] = '';
			}
			if(!a['text']){
				a['text'] = '';
			}			
			attributes = a;
        }
		override public function get attributes(){
			_attributes['label'] = labelTA.text;
			_attributes['text'] = textTA.text;
			var w:uint = uint(widthTI.text);
			if(w<20){
				w = 20;
			}
			_attributes['width'] = uint(widthTI.text);
			return _attributes;
		}
		override public function set attributes(a:Array){
			_attributes = a;
			idTxt.text = a['id'];
			labelTA.text = a['label'];
			textTA.text = a['text'];
			widthTI.text = a['width'];
		}
    } 
}