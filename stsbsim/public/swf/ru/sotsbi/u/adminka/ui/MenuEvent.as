package ru.sotsbi.u.adminka.ui {
	import flash.events.Event;
    public class MenuEvent extends Event
    {
		public static const ADD_BEFORE_CLICK:String = 'addBeforeMenuItem';
		public static const ADD_AFTER_CLICK:String = 'addAfterMenuItem';
		public static const EXTEND_CLICK:String = 'extendMenuItem';
		public static const REMOVE_CLICK:String = 'removeMenuItem';
		public static const SUBMENU_OPEN:String = 'submenuOpen';
		public static const CUSTOM_ROLL_OVER:String = 'customRollOver';
		public static const CUSTOM_ROLL_OUT:String = 'customRollOut';
		public static const SAVE_PANEL:String = 'savePanel';
		public static const CONVERT_TO_NODE:String = 'convertToNode';
		public static const CLOSE_PANEL:String = 'closePanel';
		public static const	ITEM_CLICK:String = 'itemClick';
		public static const	ITEM_DOUBLE_CLICK:String = 'itemDblClick';
		public static const	ANSWER_CLICK:String = 'answerClick';
		public static const	EMPTY_SUBMENU:String = 'emptySubmenu';
		public static const	REDRAW:String = 'redraw';
		public static const	ADD_ITEM:String = 'addItem';
		public static const	XML_ERROR:String = 'xmlError';
		public static const	SELECTED:String = 'selected';
		public function MenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	
		public override function clone():Event
		{
			return new MenuEvent(type, bubbles, cancelable);
		}
	}
}