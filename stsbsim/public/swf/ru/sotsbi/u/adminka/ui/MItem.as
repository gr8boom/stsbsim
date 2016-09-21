package ru.sotsbi.u.adminka.ui{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import ru.sotsbi.u.adminka.data.UObject;
	
	public class MItem extends MovieClip {
		public static const TYPE_BLOCK:String='block';
		public static const TYPE_ARROW:String='arrow';
		public static const TYPE_NODE:String='node';
		public static const TYPE_NO:String='no_type';

		private var _submenu:Submenu;
		private var _removable:Boolean;
		private var _answerMode:Boolean;
		//private var _isTop:Boolean;
		//private var _isBottom:Boolean;
		private var _innerWidth:Number;
		private var _innerHeight:Number;
		private var _type:String;
		private var _label:String;
		private var _attributes:Object;
		private var	_defAttr:Object;
		public function MItem(attr:Object = null) {
			//public function MItem(xml:XML, tp:String = TYPE_NO) {
			_answerMode=false;
			_attributes = new Array();
			_defAttr = {
				type: TYPE_NO,
				lbl: 'New item',
				w: 80
			}
			removable=true;

			labelTF.multiline=true;
			labelTF.wordWrap=true;
			labelTF.autoSize=TextFieldAutoSize.LEFT;
			labelTF.mouseEnabled=false;

			attributes = UObject.merge(_defAttr, attr);
			for(var s:String in attributes){
				trace('mitem attr['+s+']='+attributes[s]);
			}
			trace('----------------');

			icon.mouseEnabled=false;
			btns.visible=false;
			bgdBtn.doubleClickEnabled=true;
			
			answerMode = true; //sets events listeners
//			trace('-type='+type);
		}
		private function redrawItem() {
			bgdBtn.width = _attributes['w'];
			labelTF.width = bgdBtn.width-labelTF.x-3;
			labelTF.text = _attributes['lbl'];
			bgdBtn.height = 2 * labelTF.y + labelTF.height;
			if(_attributes['icon'] != undefined && _attributes['icon']!=''){
				icon.gotoAndStop(_attributes['icon']);
				icon.y = bgdBtn.height / 2;
				icon.visible = true;
			}else {
				if (_type == TYPE_BLOCK) {
					icon.visible = true;
					icon.gotoAndStop('block');
				}else{
					icon.visible = false;
				}
			}
			trace(bgdBtn);
			for(var p:String in bgdBtn){
				trace('bgdBtn['+p+']='+bgdBtn[p]);
			}
			if (_type==TYPE_NODE) {
				_submenu.x = bgdBtn.width;
				folderMark.visible = true;
				folderMark.height = bgdBtn.height;
				folderMark.x = bgdBtn.x + bgdBtn.width;
			}else{
				folderMark.visible = false;
			}
			_innerWidth=bgdBtn.width;
			_innerHeight=bgdBtn.height;
		}
		public function createSubmenu() {
			_submenu = new Submenu();
			_submenu.visible=false;
			this.addChildAt(_submenu,0);
			swapChildren(_submenu, bgdBtn);
			btns.moreBtn.visible=false;
//			trace('cs1');
			_type=TYPE_NODE;
//			trace('cs2');
			_submenu.addEventListener(MenuEvent.EMPTY_SUBMENU, emptySubmenuHnd);
			return _submenu;
		}
		private function emptySubmenuHnd(e:MenuEvent) {
			type = TYPE_NO;
			btns.moreBtn.visible=true;
		}
		private function clickHnd(e:MouseEvent) {
			if (_submenu) {
				if (_submenu.visible) {
					_submenu.visible=false;
					//dispatchEvent(new MenuEvent(MenuEvent.ITEM_CLICK, true));
				} else {
					_submenu.visible=true;
					dispatchEvent(new MenuEvent(MenuEvent.SUBMENU_OPEN, true));
				}
			}
		}
		private function answerModeClickHnd(e:MouseEvent) {
			if (_submenu) {
				if (_submenu.visible) {
					_submenu.visible=false;
				} else {
					_submenu.visible=true;
					dispatchEvent(new MenuEvent(MenuEvent.SUBMENU_OPEN, true));
				}
			} else {
				dispatchEvent(new MenuEvent(MenuEvent.ANSWER_CLICK, true));
			}
		}
		private function dblClickHnd(e:MouseEvent) {
			dispatchEvent(new MenuEvent(MenuEvent.ITEM_DOUBLE_CLICK, true));
		}
		private function moreHnd(e:MouseEvent) {
			trace('moreHnd');
			type = TYPE_NODE;
			var item:MItem=_submenu.addItem();
			showSubmenu=true;
			dispatchEvent(new MenuEvent(MenuEvent.SUBMENU_OPEN));
		}
		private function addBeforeHnd(e:MouseEvent) {
			dispatchEvent(new MenuEvent(MenuEvent.ADD_BEFORE_CLICK, true));
		}
		private function addAfterHnd(e:MouseEvent) {
			dispatchEvent(new MenuEvent(MenuEvent.ADD_AFTER_CLICK, true));
		}
		private function removeHnd(e:MouseEvent) {
			dispatchEvent(new MenuEvent(MenuEvent.REMOVE_CLICK, true));
		}
		private function rollOverHnd(e:MouseEvent) {
			btns.x=bgdBtn.x+bgdBtn.width;
			btns.y=bgdBtn.y+bgdBtn.height/2;
			btns.visible=true;
			dispatchEvent(new MenuEvent(MenuEvent.CUSTOM_ROLL_OVER,true));
		}
		private function rollOutHnd(e:MouseEvent) {
			dispatchEvent(new MenuEvent(MenuEvent.CUSTOM_ROLL_OUT));
			btns.visible=false;
		}

		public function set showSubmenu(b:Boolean) {
			if (_submenu) {
				_submenu.visible=b;
			}
		}
		public function get showSubmenu() {
			return _submenu.visible;
		}
		public function get type() {
			return _type;
		}

		public function set type(s:String) {
//			trace('type='+s);
			switch (s) {
				case TYPE_BLOCK :
					_type=TYPE_BLOCK;
					icon.visible = true;
					icon.gotoAndStop('block');
					btns.moreBtn.visible=true;
					break;
				case TYPE_ARROW :
					_type=TYPE_ARROW;
					icon.visible=false;
					btns.moreBtn.visible=true;
					break;
				case TYPE_NODE :
					if (_type!=TYPE_NODE) {
						_type=TYPE_NODE;
						createSubmenu();
						redrawItem();
					}
					break;
				default :
					_type=TYPE_NO;
					icon.visible=false;
			}
			_attributes['type'] = s;
		}

		public function get removable() {
			return _removable;
		}
		public function set removable(v:Boolean) {
			if (! v) {
				btns.xBtn.enabled=false;
				btns.xBtn.visible=false;
			}
			_removable=v;
		}
		public function get innerWidth() {
			return _innerWidth;
		}
		public function get innerHeight() {
			return _innerHeight;
		}
		public function set attributes(a:Object) {
			_attributes=a;
			if (a['type']) {
				type=a['type'];
			}
			redrawItem();
		}
		public function get attributes() {
			return _attributes;
		}
		public function get submenu() {
			return _submenu;
		}
		public function set answerMode(b:Boolean){
			if(_answerMode == b) return;
			_answerMode = b;
			if(b){
				bgdBtn.removeEventListener(MouseEvent.CLICK, clickHnd);
				bgdBtn.addEventListener(MouseEvent.CLICK, answerModeClickHnd);
				bgdBtn.removeEventListener(MouseEvent.DOUBLE_CLICK,  dblClickHnd );
				bgdBtn.removeEventListener(MouseEvent.ROLL_OVER, rollOverHnd);
				bgdBtn.removeEventListener(MouseEvent.ROLL_OUT, rollOutHnd);
				btns.removeEventListener(MouseEvent.ROLL_OVER, rollOverHnd);
				btns.removeEventListener(MouseEvent.ROLL_OUT, rollOutHnd);
				btns.xBtn.removeEventListener(MouseEvent.CLICK, removeHnd);
				btns.moreBtn.removeEventListener(MouseEvent.CLICK, moreHnd);
				btns.upPlusBtn.removeEventListener(MouseEvent.CLICK, addBeforeHnd);
				btns.downPlusBtn.removeEventListener(MouseEvent.CLICK, addAfterHnd);
			}else{
				bgdBtn.removeEventListener(MouseEvent.CLICK, answerModeClickHnd);
				bgdBtn.addEventListener(MouseEvent.CLICK, clickHnd);
				bgdBtn.addEventListener(MouseEvent.DOUBLE_CLICK,  dblClickHnd );
				bgdBtn.addEventListener(MouseEvent.ROLL_OVER, rollOverHnd);
				bgdBtn.addEventListener(MouseEvent.ROLL_OUT, rollOutHnd);
				btns.addEventListener(MouseEvent.ROLL_OVER, rollOverHnd);
				btns.addEventListener(MouseEvent.ROLL_OUT, rollOutHnd);
				btns.xBtn.addEventListener(MouseEvent.CLICK, removeHnd);
				btns.moreBtn.addEventListener(MouseEvent.CLICK, moreHnd);
				btns.upPlusBtn.addEventListener(MouseEvent.CLICK, addBeforeHnd);
				btns.downPlusBtn.addEventListener(MouseEvent.CLICK, addAfterHnd);
			}
			if (_submenu) {
				_submenu.answerMode = b;
			}
		}
		public function get answerMode(){
			return _answerMode;
		}
		public function get value() {
			switch(_type) {
				case TYPE_ARROW:
				case TYPE_BLOCK:
					return String(_attributes['id']);
				break;
				default:
					return 'ERROR';
			}
		}
		public function get text() {
			return String(_attributes['text']);
		}
	}
}