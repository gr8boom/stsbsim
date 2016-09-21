package ru.sotsbi.u.adminka.ui {
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;	
	import ru.sotsbi.u.adminka.i18.I18MovieClip;
    public class EditPanel extends I18MovieClip
    {
		public static const TYPE_BLOCK:String = 'block';
		public static const TYPE_ARROW:String = 'arrow';
		public static const TYPE_NODE:String = 'node';
		public static const TYPE_NO:String = 'no';
		public static const TYPE_FIELD:String = 'field';
//		public static const TYPE_CORNER:String = 'corner';
//		public static const TYPE_QUEST:String = 'quest';
		
		private var _xml:XML;
		private var _targetObj:Object;
		private var _type:String;
		private var _fields:PanelFields;
		public function EditPanel(target:Object, type:String, a:Array){
			saveTF.mouseEnabled = false;
			cancelTF.mouseEnabled = false;
			_targetObj = target;
			_type = type;
trace('aaaaalensa '+a['len']);
			switch(type){
				case TYPE_BLOCK:
					_fields = new BlockBtnPanelFields(a);
				break;
				case TYPE_ARROW:
					_fields = new ArrowBtnPanelFields(a);
				break;
				case TYPE_NODE:
					_fields = new NodeBtnPanelFields(a);
				break;
				case TYPE_NO:
					_fields = new TypePanelFields(a);
				break;
				case TYPE_FIELD:
					_fields = new BlockPanelFields(a);
				break;
			}
			addChild(_fields);
			bgd.width = _fields.width;
			if(bgd.width < 220){
				bgd.width = 220;
			}
			bgd.height = _fields.height + saveBtn.height + 5;
			saveTF.x = saveBtn.x = bgd.width/2 - saveBtn.width - 5;
			cancelTF.x = cancelBtn.x = bgd.width/2 + 5;
			saveBtn.y = cancelBtn.y = bgd.height - saveBtn.height - 5;
			saveTF.y = cancelTF.y = saveBtn.y+3;
			saveBtn.addEventListener(MouseEvent.CLICK, saveHnd);
			cancelBtn.addEventListener(MouseEvent.CLICK, cancelHnd);
        }
		
		public function redrawPanel(){
			trace(_xml.child(0).name);
		}
		public function saveHnd(e:MouseEvent){
			trace('save mthrfckr!');
//			var dbg:Dbg = new Dbg();
//			dbg.dt(attributes);
			dispatchEvent(new MenuEvent(MenuEvent.SAVE_PANEL, true));
		}
		public function cancelHnd(e:MouseEvent){
			dispatchEvent(new MenuEvent(MenuEvent.CLOSE_PANEL, true));
		}
		public function get attributes(){
			trace('fields.att='+_fields.attributes['length']);
			return _fields.attributes;
		}
		public function get target(){
			return _targetObj;
		}
		public function get type(){
			return _type;
		}
    } 
}