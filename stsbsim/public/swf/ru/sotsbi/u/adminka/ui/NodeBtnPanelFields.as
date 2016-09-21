package ru.sotsbi.u.adminka.ui {
	import 	fl.controls.RadioButtonGroup;
	import 	fl.controls.RadioButton;
	import flash.events.Event;
	
    public class NodeBtnPanelFields extends PanelFields
    {
		private var _attributes:Array;
		private var _radioButtonGroup:RadioButtonGroup;
		
		public function NodeBtnPanelFields(a:Array = null)
        {
			
			if(a == null){
				a = new Array();
				a['label'] = 'null';
			}
			attributes = a;
			addEventListener(Event.ENTER_FRAME, enterFrameHnd);
			iconCB.addEventListener(Event.CHANGE, iconCB_changeHnd);
		}
		
		private function enterFrameHnd(e:Event) {
			_radioButtonGroup = arrows.firstRadioButton.group as RadioButtonGroup;
			_radioButtonGroup.addEventListener(Event.CHANGE, rbGroup_changeHnd);
			redraw();
			removeEventListener(Event.ENTER_FRAME, enterFrameHnd);
        }
		
		private function iconCB_changeHnd(e:Event) {
			arrows.visible = iconCB.selected;
		}
		
		private function rbGroup_changeHnd(e:Event) {
			_attributes['icon'] = (iconCB.selected)?_radioButtonGroup.selectedData:'';
		}
		
		private function redraw() {
			labelTA.text = _attributes['label'];
			widthTI.text = _attributes['width'];
			if (_attributes['icon']) {
				iconCB.selected = true;
				arrows.visible = true;
			}else {
				iconCB.selected = false;
				arrows.visible = false;
			}
			var btn:RadioButton;
			for (var i:uint = 0; i < _radioButtonGroup.numRadioButtons; i++) {
				btn = _radioButtonGroup.getRadioButtonAt(i);
				if (btn.value == _attributes['icon']) {
					btn.selected = true;
				}
			}			
		}

		override public function get attributes(){
			_attributes['label'] = labelTA.text;
			_attributes['width'] = uint(widthTI.text);
			var w:uint = uint(widthTI.text);
			if(w<20){
				w = 20;
			}
			_attributes['icon'] = iconCB.selected?_radioButtonGroup.selectedData:'';
			return _attributes;
		}
		override public function set attributes(a:Array){
			_attributes = a;
		}
    } 
}