package ru.sotsbi.u.adminka.ui.answer{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import ru.sotsbi.u.adminka.ui.answer.AEvent;
	public class AToolbar extends MovieClip {
		private var _enabled:Boolean;
		private var _currentItem:uint;
		private var _totalItems:uint;

		public function AToolbar() {
			trace('AToolbar init');
			_currentItem = 0;
			_totalItems = 1;
			_enabled = true;
			redraw();
			nextBtn.addEventListener(MouseEvent.CLICK, nextBtn_clickHnd);
			prevBtn.addEventListener(MouseEvent.CLICK,  prevBtn_clickHnd );
			addBtn.addEventListener(MouseEvent.CLICK, addBtn_clickHnd);
			removeBtn.addEventListener(MouseEvent.CLICK, removeBtn_clickHnd);
		}
		private function nextBtn_clickHnd(e:MouseEvent) {
			dispatchEvent(new AEvent(AEvent.NEXT_CLICK, true));
		}
		private function prevBtn_clickHnd(e:MouseEvent) {
			dispatchEvent(new AEvent(AEvent.PREV_CLICK, true));
		}
		private function addBtn_clickHnd(e:MouseEvent) {
			trace('addBtn_clickHnd');
			dispatchEvent(new AEvent(AEvent.ADD_CLICK, true));
		}
		private function removeBtn_clickHnd(e:MouseEvent) {
			dispatchEvent(new AEvent(AEvent.REMOVE_CLICK, true));
		}
		private function redraw() {
			textTxt.text = String(_currentItem + 1) + '/' + String(_totalItems);
			if (_currentItem <= 0) {
				prevBtn.visible = false;
			}else {
				prevBtn.visible = true;
			}
			if (_currentItem >= _totalItems-1) {
				nextBtn.visible = false;
			}else {
				nextBtn.visible = true;
			}
			if (_totalItems <= 1) {
				removeBtn.visible = false;
			}else {
				removeBtn.visible = true;
			}
		}
		public function set active(b:Boolean) {
			if (_enabled==b) {
				return;
			}

			_enabled=b;
			if (b) {
				addBtn.enabled=true;
				removeBtn.enabled=true;
				nextBtn.enabled=true;
				prevBtn.enabled=true;
			} else {
				addBtn.enabled=false;
				removeBtn.enabled=false;
				nextBtn.enabled=false;
				prevBtn.enabled=false;
			}
		}
		public function get active() {
			return _enabled;
		}
		public function set text(s:String) {
			textTxt.text=s;
		}
		public function get text() {
			return textTxt.text;

		}
		public function set currentItem(n:uint) {
			_currentItem = n;
			redraw();
		}
		public function get currentItem() {
			return _currentItem;
		}
		public function set totalItems(n:uint) {
			_totalItems = n;
			redraw();
		}
		public function get totalItems() {
			return _totalItems;
		}
	}
}