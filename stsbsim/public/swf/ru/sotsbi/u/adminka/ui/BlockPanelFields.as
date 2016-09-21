package ru.sotsbi.u.adminka.ui {
	import flash.events.Event;

	public class BlockPanelFields extends PanelFields
    {
		private var _attributes:Array;
		public function BlockPanelFields(a:Array = null)
        {
			if(a == null){
				a = new Array();
			}
			if(!(a['txt'] is String)){
				a['txt'] = '';
			}
			if(a['c']<0 || !(a['c'] is int)){
				a['c'] = uint('0xCCCCCC');
			}			
			if(!(a['x']is Number)){
				a['x'] = 0;
			}			
			if(!(a['y']is Number)){
				a['y'] = 0;
			}			
			if(!(a['width']is Number)){
				a['width'] = 80;
			}			
			if(!(a['height']is Number)){
				a['height'] = 40;
			}
			if (a['brdr'] !== 1) {
				a['brdr'] = 0
			}
			if(!(a['manual']is Boolean)){
				a['manual'] = false;
			}
			trace('aaaaalensa '+a['len']);		
			if(a['len']<0 || !(a['len'] is int) || a['len']!=Math.floor(a['len'])){
				a['len'] = 1;
			}			
			if((a['chars']==undefined )){//"is String" not work correct, dont know why
				a['chars'] = '';
			}
			trace('aaaaacharsa '+a['chars']);			
 			manualCB.addEventListener(Event.CHANGE, manualCB_changeHnd);
			addEventListener(Event.ENTER_FRAME, enterFrameHnd);
			attributes = a;
		}
		/*
		I dont know why, but setting "manualCB.selected" at constructor does not work, 
		thats why we will set it by onenterframe
		
		borderCB has same problem
		*/
		private function enterFrameHnd(e:Event) {
			borderCB.selected = (_attributes['brdr'] == 1)?true:false;
			manualCB.selected = (_attributes['len']>0);
			removeEventListener(Event.ENTER_FRAME, enterFrameHnd);
			//временно отключено дабы не смущать пользователей не работающей фичей
			manualLbl.visible = false;
			manualCB.visible = false;
			answer.visible = false;
/*			if(manualCB.selected){
				answer.visible = true;
			}else{
				answer.visible = false;
			}*/
		}
		private function manualCB_changeHnd(e:Event){
			trace('changed '+manualCB.selected);
			if(manualCB.selected){
				answer.visible = true;
				if(answer.lengthTI.text==0){
					answer.lengthTI.text = 1;
				}
			}else{
				answer.visible = false;
			}
		}
		override public function get attributes(){
			_attributes['txt'] = labelTA.text;
			if (manualCB.selected) {
				_attributes['len'] =  uint(answer.lengthTI.text);
			}else{
				_attributes['len'] =  0;
			}
			trace('lenlen '+ _attributes['len']+' [[]] '+ answer.lengthTI.text);
			_attributes['chars'] = answer.charsTA.text;
			_attributes['c'] = colorCP.selectedColor;
			_attributes['x'] = int(xTI.text);
			_attributes['y'] = int(yTI.text);
			_attributes['width'] = uint(wTI.text);
			_attributes['height'] = uint(hTI.text);
			_attributes['brdr'] = (borderCB.selected)?1:0;
			return _attributes;
		}
		override public function set attributes(a:Array) {
			_attributes = a;
			labelTA.text = a['txt'];
			answer.lengthTI.text = a['len'];
			answer.charsTA.text = a['chars'];
			colorCP.selectedColor = a['c'];
			xTI.text = a['x'];
			yTI.text = a['y'];
			wTI.text = a['width'];
			hTI.text = a['height'];
		}
    } 
}