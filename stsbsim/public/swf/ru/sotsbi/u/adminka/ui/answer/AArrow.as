package ru.sotsbi.u.adminka.ui.answer{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextFieldType;
	import flash.geom.ColorTransform;
	import ru.sotsbi.u.adminka.data.UObject;
	
	public class AArrow extends MovieClip {
		private var _selected:Boolean;
		private var _attributes:Object;
		private var	_defAttr:Object;
		private var _value:String;
		private var arrowNum:int;
		private var arrow:Arrow;
		public function AArrow(a:Object = null, pos:Array = null) {
			trace('arrow mc=' + a['mc'] + ' txt=' + a['txt']);
			_defAttr = {
				txt: '**',
				mc: 'a12'
			}
			attributes = UObject.merge(_defAttr, a);
			redraw(a['mc'], pos);
			arrow.label = attributes.txt;
			selected = false;
			bckgndBtn.addEventListener(MouseEvent.CLICK, bckgndBtn_clickHnd);
			deleteBtn.addEventListener(MouseEvent.CLICK, deleteBtn_clickHnd);
		}
		private function redraw(mc:String, pos:Array) {
			trace('arrow redraw '+mc);
			if (arrow) {
				removeChild(arrow);
			}
			var type:String = mc.substr(0, 1);
			trace('arrow mc=' + mc + ' type=' + type);
			var x1:Number = pos['x1'];
			var x2:Number = pos['x2'];
			var w1:Number = (pos['x2']-pos['x1']);
			var w2:Number = (pos['x3']-pos['x2']);
			
			if (mc.indexOf('0') >= 0 || mc.indexOf('3') >= 0) {
				arrowNum = 2;
			}else {
				arrowNum = 1;
			}
			switch(mc.substr(1)){
				case '12':
					arrow = new Arrow(w1, type, 'right');
					arrow.x = x1;
					break;
				case '21':
					arrow = new Arrow(w1, type, 'left');
					arrow.x = x1;
					break;
				case '13':
					arrow = new Arrow(w1+w2, type, 'right');
					arrow.x = x1;
					break;
				case '31':
					arrow = new Arrow(w1+w2, type, 'left');
					arrow.x = x1;
					break;
				case '23':
					arrow = new Arrow(w2, type, 'right');
					arrow.x = x2;
					break;
				case '32':
					arrow = new Arrow(w2, type, 'left');
					arrow.x = x2;
					break;
			}
			addChild(arrow);
			swapChildren(arrow, deleteBtn);
			swapChildren(arrow, bckgndBtn);
			bckgndBtn.width = arrow.width;
			bckgndBtn.x = arrow.x;
			deleteBtn.x = bckgndBtn.x + bckgndBtn.width;
			deleteBtn.visible = false;
		}
		private function bckgndBtn_clickHnd(e:MouseEvent) {
			if (arrow) {
				arrow.selected = true;
			}
			if (_selected) {
				selected = false;
				dispatchEvent(new Event(Event.CLEAR, true));
			}else{
				selected = true;
				dispatchEvent(new Event(Event.SELECT, true));
			}
		}
		private function deleteBtn_clickHnd(e:MouseEvent) {
			if (arrow) {
				dispatchEvent(new AEvent(AEvent.REMOVE_CLICK, true));
			}
		}
		public function get attributes() {
			return _attributes;
		}
		public function set attributes(a:Object) {
			_attributes=a;
		}
		public function get selected() {
			return _selected;
		}
		public function set selected(b:Boolean) {
			_selected = b;
			if(arrow){
				arrow.selected = b;
				deleteBtn.visible = b;
			}
		}
		public function set wrong(b:Boolean) {
			if(arrow){
				arrow.selected = false;
				arrow.wrong = b;
			}
		}		
		public function set label(s:String) {
			if (arrow) {
				arrow.label = s;
			}
		}
		public function set value(v:String) {
			_value = v;
		}
		public function get value() {
			return _value;
		}
	}
}