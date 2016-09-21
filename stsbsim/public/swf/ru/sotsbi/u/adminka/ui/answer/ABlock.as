package ru.sotsbi.u.adminka.ui.answer{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import flash.geom.ColorTransform;
	import ru.sotsbi.u.adminka.data.UObject;
	
	public class ABlock extends MovieClip {
		private var _selected:Boolean;
		private var _wrong:Boolean;
		private var _attributes:Object;
		private var	_defAttr:Object;
		private var _value:String;
		private var inputOk:Boolean;
		private var colorTrans = new ColorTransform();
		public function ABlock(a:Object = null) {
			_defAttr = {
				c: uint('0xAAAAAA'),
				lbl: '',
				x: 20,
				y: 20,
				w: 120,
				h: 50,
				len: 0,
				chars:  'a-zA-Zа-яА-Я0-9',
				brdr:  1
			};
			attributes = UObject.merge(_defAttr, a);
			inputOk = false;
			textTF.multiline=true;
			textTF.wordWrap=true;
			textTF.autoSize = TextFieldAutoSize.CENTER;
			attributes = a;
			if (a['len'] > 0) {
				textTF.type = TextFieldType.INPUT;
				textTF.selectable = true;
			}else{
				textTF.type = TextFieldType.DYNAMIC;
				textTF.selectable = false;
			}
			selected=false;
			bgd.addEventListener(MouseEvent.MOUSE_DOWN, textTF_mousedownHnd);
			textTF.addEventListener(MouseEvent.MOUSE_DOWN, textTF_mousedownHnd);
			textTF.addEventListener(TextEvent.TEXT_INPUT,textTF_textInputHnd);
			textTF.addEventListener('change',textTF_changedHnd);
		}
		private function textTF_mousedownHnd(e:MouseEvent) {
//			trace('textTF_mousedownHnd');
			if (textTF.type == TextFieldType.DYNAMIC) {
//TODO: stage.focus does not work
				stage.focus = textTF;
				textTF.stage.focus = textTF;
			}
			if (_selected) {
				selected = false;
				dispatchEvent(new Event(Event.CLEAR, true));
			}else{
				selected = true;
				dispatchEvent(new Event(Event.SELECT, true));
			}
		}
		private function textTF_textInputHnd(e:TextEvent) {
			var exp:String = '[' + _attributes['chars'] + ']*';
//			trace('textTF_textInputHnd ' + e.text +' '+textTF.text+ ' '+exp+' '+_attributes['len']);
			var regex:RegExp = new RegExp(exp);
			var obj:Object = regex.exec(e.text);
			trace([obj[0],obj[1],obj[2]]);
			if(obj == null || obj[0]!= e.text){
				e.preventDefault();
				return;
			}
			inputOk = true;
		}
		private function textTF_changedHnd(e:Event) {
			if(inputOk){
				inputOk = false;
				_value = '"' + e.target.text + '"';
				dispatchEvent(new AEvent(AEvent.TEXT_CHANGED, true));
			}
		}
		public function get attributes() {
			return _attributes;
		}
		public function set attributes(a:Object) {
			if (a['c']) {
				colorTrans.color=a['c'];
				bgd.transform.colorTransform=colorTrans;
			}
			if (a['txt']) {
//				textTF.text=a['txt'];
			}
			if (a['x']) {
				var tx:int=int(a['x']);
				if (tx<0) {
					tx=0;
				}
				if (tx>640) {
					tx=640;
				}
				x=tx;
			}
			if (a['y']) {
				var ty:int=int(a['y']);
				if (ty<0) {
					ty=0;
				}
				if (ty>500) {
					ty=500;
				}
				y=ty;
			}
			if (a['h']) {
				var th:uint=uint(a['h']);
				if (th<20) {
					ty=20;
				}
				if (th>500) {
					th=500;
				}
				textTF.height=th;
				bgd.height=th;
				border.height=th;
			}
			if (a['w']) {
				var tw:uint=uint(a['w']);
				if (tw<15) {
					tw=15;
				}
				if (tw>640) {
					tw=640;
				}
				bgd.width=tw;
				textTF.width=tw;
				border.width=tw;
			}
			border.visible = (a['brdr'] == 0)?false:true;
			_attributes=a;
		}
		private function updateState() {
			var c:uint;
			if (_selected) {
				c = 0xFFFFFF;
				border.visible=true;
			}else if (_wrong) {
				c =	0xFF0000;
			}else {
				c = uint(_attributes['c']);
				border.visible=(_attributes['brdr']==0)?false:true;
			}
			colorTrans.color = c;
			bgd.transform.colorTransform = colorTrans;
		}				
		public function get selected() {
			return _selected;
		}
		public function set selected(b:Boolean) {
			_selected=b;
			updateState();
		}
		public function get wrong() {
			return _wrong;
		}
		public function set wrong(b:Boolean) {
			_selected = false;
			_wrong = b;
			updateState();
		}
		public function set text(v:String) {
			if(v == null)
				v = '';
			textTF.height = 0;
			textTF.text = v;
			//dont touch this trace without it code above doesnt work
			trace([bgd.height, textTF.height]);
			textTF.y = (bgd.height - textTF.height) / 2;
		}
		public function set value(v:String) {
			_value = v;
		}
		public function get value() {
			return _value;
		}
		public function get manualInput() {
			return _attributes['len']>0;
		}
	}
}