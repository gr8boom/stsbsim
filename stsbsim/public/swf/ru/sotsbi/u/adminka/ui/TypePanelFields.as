package ru.sotsbi.u.adminka.ui {
	import 	fl.controls.RadioButtonGroup;
	import 	fl.controls.RadioButton;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	import flash.display.MovieClip;	
    public class TypePanelFields extends PanelFields
    {
		private var _attributes:Array;
		private var _radioButtonGroup:RadioButtonGroup;
		
		public function TypePanelFields(a:Array = null)
        {
			if(a == null){
				a = new Array();
				a['type'] = MItem.TYPE_NO;
			}
			attributes = a;
			_radioButtonGroup = typeRBGroup.firstRadioButton.group as RadioButtonGroup;
 			_radioButtonGroup.addEventListener(Event.CHANGE, selectTypeHnd);
//todo: i dont understand why radiobuttongroup dont dispatch event CHANGE
//      it works only if i pack radiobuttons into one movieclip
		}
		private function selectTypeHnd(e:Event){
			_attributes['type'] = _radioButtonGroup.selectedData;
			trace(_radioButtonGroup.selectedData);
		}
		override public function get attributes(){
			return _attributes;
		}
		override public function set attributes(a:Array){
			_attributes = a;
		}
    } 
}