package ru.sotsbi.u.adminka.ui {
	import 	fl.controls.RadioButtonGroup;
	import 	fl.controls.RadioButton;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	import flash.display.MovieClip;	
	
	public class ArrowBtnPanelFields extends PanelFields {
		private var _attributes:Array;
		private var _radioButtonGroup:RadioButtonGroup;
		
		public function ArrowBtnPanelFields(a:Array = null){
			iconTF.mouseEnabled = false;
			_attributes = new Array();
			if(a == null){
				a = new Array();
			}
			if(!a['label']){
				a['label'] = '';
			}
			if(!a['text']){
				a['text'] = '';
			}
			if(!a['mc']){
				a['mc'] = 'a12';
			}

			attributes = a;
			addEventListener(Event.ENTER_FRAME, enterFrameHnd);
		}
		
		private function enterFrameHnd(e:Event) {
			redraw();
			removeEventListener(Event.ENTER_FRAME, enterFrameHnd);
		}
		
		private function redraw() {
			_radioButtonGroup = firstRadioButton.group as RadioButtonGroup;
			trace('redraw ' + _radioButtonGroup + _radioButtonGroup.numRadioButtons);
			idTxt.text = _attributes['id'];
			labelTA.text = _attributes['label'];
			textTI.text = _attributes['text'];
			widthTI.text = _attributes['width'];
			if (_attributes['icon']) {
				iconCB.selected = true;
			}
			var btn:RadioButton;
			for (var i:uint = 0; i < _radioButtonGroup.numRadioButtons; i++) {
				btn = _radioButtonGroup.getRadioButtonAt(i);
				if (btn.value == _attributes['mc']) {
					btn.selected = true;
				}
			}
		}
		
		override public function get attributes(){
			_attributes['label'] = labelTA.text;
			_attributes['text'] = textTI.text;
			_attributes['mc'] = _radioButtonGroup.selectedData;
			_attributes['icon'] = iconCB.selected?_attributes['mc']:'';
			var w:uint = uint(widthTI.text);
			if(w<20){
				w = 20;
			}
			_attributes['width'] = w;
			return _attributes;
		}
		
		override public function set attributes(a:Array){
			_attributes = a;
		}
	}
}