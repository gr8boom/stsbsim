package ru.sotsbi.u.adminka.ui.answer{
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import fl.controls.UIScrollBar;
	import fl.events.ScrollEvent;
	import ru.sotsbi.u.adminka.ui.answer.AEvent;
	import ru.sotsbi.u.adminka.ui.answer.AToolbar;
	import ru.sotsbi.u.adminka.ui.answer.AArrow;
	import ru.sotsbi.u.adminka.data.Answer;
	import ru.sotsbi.u.adminka.data.AnswerList;
	import ru.sotsbi.u.adminka.data.Relations;
	import ru.sotsbi.u.adminka.debug.Dbg;
	import ru.sotsbi.u.adminka.debug.DbgEvent;
	import ru.sotsbi.u.adminka.i18.I18MovieClip;
		
	public class AWorkspace extends I18MovieClip {
		private var _active:Boolean;
		private var inited:Boolean;
		private var answers:AnswerList;
		private var curAnswer:Answer;
		private var arrows:Array;
		private var arrowsPos:Array;
		private var blocks:Array;
		private var arrowsContainer:MovieClip;
		private var blocksContainer:MovieClip;
		private var scrBar:UIScrollBar;
		private var selectedBlock:ABlock;
		private var selectedArrow:AArrow;
		private var _simMode:Boolean;
		private var _relations:Relations;

		public function AWorkspace() {
			aToolbar.addTF.mouseEnabled = false;
			aToolbar.deleteTF.mouseEnabled = false;
			arrowsPos = new Array();
			answers = new AnswerList();
			_active = true;
			_relations = new Relations();
			arrows = new Array();
			blocks = new Array();
			
			arrowsContainer = new MovieClip();
			blocksContainer = new MovieClip();
			addChild(arrowsContainer);
			addChild(blocksContainer);
			scrBar = scrBarObj;

			addEventListener(Event.SELECT, selectHnd);
			addEventListener(AEvent.TEXT_CHANGED, textChangedHnd);
			aToolbar.addEventListener(AEvent.ADD_CLICK, addAnswer_clickHnd);
			aToolbar.addEventListener(AEvent.REMOVE_CLICK, removeAnswer_clickHnd);
			addEventListener(AEvent.REMOVE_CLICK, removeArrow_clickHnd);
			addEventListener(AEvent.NEXT_CLICK, nextClickHnd);
			addEventListener(AEvent.PREV_CLICK, prevClickHnd);
			scrBar.addEventListener(ScrollEvent.SCROLL, scrollHnd);
		}
		public function init(workspaceArr:Array, answStr:String = '') {
			trace('answStr'+answStr);
			arrowsPos['y'] = workspaceArr['y'];
			arrowsPos['x1'] = workspaceArr['x1'];
			arrowsPos['x2'] = workspaceArr['x2'];
			arrowsPos['x3'] = workspaceArr['x3'];
			trace('x1x2x3 '+[arrowsPos['x1'],arrowsPos['x2'],arrowsPos['x3'],arrowsPos['y']]);

			for each(var block:MovieClip in blocks){
				blocksContainer.removeChild(block);
			}
			blocks = new Array();
			var id:int;
			var tmpAnsw = '';
			for each(var attrs:Array in workspaceArr.blocks){
				id = blocks.push(new ABlock(attrs));
				blocksContainer.addChild(blocks[id - 1]);
				tmpAnsw+= '|';
			}
			if(answStr == ''){
				answStr = '[('+tmpAnsw+')]';
			}
			if (answers.length == 0) {
				parseAnswers(answStr);
			}else {
				drawAnswer();
			}
		}
		public function parseAnswers(answStr:String) {
			answers = new AnswerList(answStr, blocks.length);
//			Dbg.trc(_relations.asArray);
//			trace(answers.toString());
			aToolbar.currentItem = 0;
			aToolbar.totalItems = answers.length;
			drawAnswer();
		}
		private function drawAnswer() {
			if(!curAnswer){
				curAnswer = answers.getAnswer(0);
			}
			var answerLen:uint = curAnswer.length;
			var nBlocks = blocks.length;
			for each(var block:MovieClip in blocks) {
				block.text = '';
			}
			for each(var arrow:MovieClip in arrows){
				arrowsContainer.removeChild(arrow);
			}
			arrows = new Array();
			for(var i:uint =0; i < answerLen; i++) {
				if (i < nBlocks) {
					selectedBlock = blocks[i];
					setBlock(curAnswer.getBlock(i));
				}else {
					redrawArrow(i - nBlocks);
				}
			}
			selectedBlock = undefined;
			selectedArrow = undefined;
			redrawScrollBar();
		}
		public function redrawArrow(n:int) {
			trace('draw Arrow ' + n);
			var id:int = curAnswer.getArrow(n);
			var r:Array;
			var arrow:AArrow;
			r = _relations.getRelationById(curAnswer.getArrow(n));
			trace('draw Arrow ' + r);
			if (arrows[n] != undefined) {
				arrowsContainer.removeChild(arrows[n]);
				arrows[n] = undefined;
			}
			arrow = new AArrow(r, arrowsPos);
			arrows.splice(n, 1, arrow);
			arrowsContainer.addChild(arrow);
			arrow.y = arrowsPos['y'] + n * 35;
			trace('arrow drawed ' + arrow);
			return arrow;
		}
		public function addArrow(value:String) {
			var n:int;
			if (selectedArrow) { // insert before
				n = arrows.indexOf(selectedArrow);
				curAnswer.addArrow(n);
			}else { // insert after all
				n = curAnswer.addArrow();			
			}
			curAnswer.setArrow(n, value);
			redrawScrollBar();
			return n;
		}
		
		public function setArrow(value:String) {
			trace('set Arrow ' + value + ' '+selectedArrow);
			var r:Array;
			var n:int;
			if (selectedArrow) {// update selected arrow
				n = arrows.indexOf(selectedArrow);
				curAnswer.setArrow(n, value);
//				redrawArrow(n);
				drawAnswer();
			}else { // insert after all
				n = addArrow(value);
				redrawArrow(n);
			}
		}
		
		private function removeArrow() {
			
		}
		
		public function setBlock(value:String) {
			trace('setBlock ' + value );
			var n:uint;
			var r:Array;
			if (selectedBlock) {
				if (value.charAt(0) == '"') {
					selectedBlock.value = value;					
					selectedBlock.text = value.substr(1,value.length-2);
				}else {
//					Dbg.trc(_relations.asArray);
//					trace('val = ' + value);//*/
					r = _relations.getRelationById(value);
//					Dbg.trc(r);
//					trace('eof trc '+r.length);//*/
/*					for (var k:String in r) {
						trace('rel[' + k + ']=' + r[k]);
					}*/
					if (selectedBlock.manualInput) {
						selectedBlock.value = '"'+r['text']+'"';	
					}else{
						selectedBlock.value = r['id'];
					}
					try{
						selectedBlock.text = r['text'];	
					}catch(err:Error){
						selectedBlock.text = '';	
					}
				}
				trace('index ='+blocks.indexOf(selectedBlock))
				curAnswer.setBlock(blocks.indexOf(selectedBlock), value);
			}
		}
		public function getAnswerSting() {
			return answers.toString();
		}
		private function selectHnd(e:Event) {
			var k:String;
			if(e.target is ABlock){
				var block:ABlock;
				for (k in blocks) {
					block = blocks[k];
					if (e.target == block) {
						selectedBlock = block;
					}else {
						block.selected=false;
					}
				}
				var topChild = blocksContainer.getChildAt(blocksContainer.numChildren-1);
				blocksContainer.swapChildren(e.target as DisplayObject, topChild);
			}
			if (e.target is AArrow) {
				var arrow:AArrow;
				for (k in arrows) {
					arrow = arrows[k];
					if (e.target == arrow) {
						selectedArrow = arrow;
					}else {
						arrow.selected = false;
					}
				}
			}
		}
		private function textChangedHnd(e:AEvent) {
			curAnswer.setBlock(blocks.indexOf(selectedBlock), e.target.value);
		}
		private function addAnswer_clickHnd(e:AEvent) {
			var l:uint = answers.length;
			curAnswer = answers.addAnswer(aToolbar.currentItem + 1, '', blocks.length);
			drawAnswer();
			aToolbar.totalItems = l+1;
			aToolbar.currentItem = aToolbar.currentItem+1;
//			trace('=addClickHnd '+answers.length+' ' +aToolbar.totalItems+' '+aToolbar.currentItem+' '+aToolbar.currentItem);
			dispatchEvent(new Event(Event.CHANGE, true));
		}
		private function removeArrow_clickHnd(e:AEvent) {
			if (selectedArrow) {
				curAnswer.removeArrow(arrows.indexOf(selectedArrow));
			}
			drawAnswer();
			dispatchEvent(new Event(Event.CHANGE, true));
		}
		private function removeAnswer_clickHnd(e:AEvent) {
			var l:uint = answers.length;
			var n:uint = aToolbar.currentItem;
			answers.removeAnswer(n);
			if (n > 0) n--;
			curAnswer = answers.getAnswer(n);
			aToolbar.totalItems = l - 1;
			aToolbar.currentItem = n;
			drawAnswer();
			dispatchEvent(new Event(Event.CHANGE, true));
		}
		private function redrawScrollBar() {
			var h:Number = arrowsContainer.getRect(arrowsContainer).bottom;
			if(h > 450){
				scrBar.setScrollProperties(450, 0, h-450,250);
				scrBar.visible = true;
			}else{
				scrBar.visible = false;
			}
		}
		private function scrollHnd(e:ScrollEvent) {
			arrowsContainer.y = -scrBar.scrollPosition;
		}
		private function nextClickHnd(e:AEvent) {
			var n:uint = aToolbar.currentItem;
			aToolbar.currentItem = n + 1;
			curAnswer = answers.getAnswer(n + 1);
			drawAnswer();
		}
		private function prevClickHnd(e:AEvent) {
			var n:uint = aToolbar.currentItem;
			aToolbar.currentItem = n - 1;
			curAnswer = answers.getAnswer(n - 1);
			drawAnswer();
		}
		public function set simMode(b:Boolean) {
			_simMode = b;
			if(b){
				aToolbar._visible = false;
			}else{
				aToolbar._visible = true;
			}
		}
		
		public function get simMode() {
			return _simMode
		}
		
		public function set relations(a:Relations) {
			_relations = a;
		}
		
		public function get relations() {
			return _relations;
		}
	}
}