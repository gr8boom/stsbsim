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
		
	public class SWorkspace extends I18MovieClip {
		private var inited:Boolean;
		private var answer:Answer;
		private var arrows:Array;
		private var arrowsPos:Array;
		private var blocks:Array;
		private var arrowsContainer:MovieClip;
		private var blocksContainer:MovieClip;
		private var scrBar:UIScrollBar;
		private var selectedBlock:ABlock;
		private var selectedArrow:AArrow;
		private var needArrow:Arrow;
		private var _relations:Relations;
		private var _disabled:Boolean;
		public static const Y_STEP:uint = 35; 

		public function SWorkspace() {
			_disabled = false;
			arrowsPos = new Array();
			answer = new Answer();
			_relations = new Relations();
			arrows = new Array();
			blocks = new Array();
			
			arrowsContainer = new MovieClip();
			blocksContainer = new MovieClip();
			addChild(arrowsContainer);
			addChild(blocksContainer);
			scrBar = scrBarObj;

			addEventListener(Event.SELECT, selectHnd);
			addEventListener(Event.CLEAR, selectHnd);
			addEventListener(AEvent.TEXT_CHANGED, textChangedHnd);
			addEventListener(AEvent.REMOVE_CLICK, removeArrow_clickHnd);
			scrBar.addEventListener(ScrollEvent.SCROLL, scrollHnd);
		}
		public function init(workspaceArr:Array, answStr:String = '') {
			trace('answStr'+answStr);
			arrowsPos['y'] = workspaceArr['y'];
			arrowsPos['x1'] = workspaceArr['x1'];
			arrowsPos['x2'] = workspaceArr['x2'];
			arrowsPos['x3'] = workspaceArr['x3'];
			trace('x1x2x3 '+[arrowsPos['x1'],arrowsPos['x2'],arrowsPos['x3'],arrowsPos['y']]);
			needArrow = new Arrow(arrowsPos['x3'] - arrowsPos['x1'], 'n', 'right');
			needArrow.x = arrowsPos['x1'];
			needArrow.label = 'Добавьте элемент';
			needArrow.visible = false;
			arrowsContainer.addChild(needArrow);
			
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
				answStr = '('+tmpAnsw+')';
			}
			answer = new Answer(answStr, blocks.length);
			drawAnswer();
		}
		private function drawAnswer() {
			var answerLen:uint = answer.length;
			var nBlocks = blocks.length;
			for each(var arrow:MovieClip in arrows){
				arrowsContainer.removeChild(arrow);
			}
			arrows = new Array();
			for(var i:uint =0; i < answerLen; i++) {
				if (i < nBlocks) {
					selectedBlock = blocks[i];
					setBlock(answer.getBlock(i));
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
			var id:int = answer.getArrow(n);
			var r:Object;
			var arrow:AArrow;
			r = _relations.getRelationById(answer.getArrow(n));
			trace('draw Arrow ' + r);
			if (arrows[n] != undefined) {
				arrowsContainer.removeChild(arrows[n]);
				arrows[n] = undefined;
			}
			trace(r.txt);
			arrow = new AArrow(r, arrowsPos);
			arrows.splice(n, 1, arrow);
			arrowsContainer.addChild(arrow);
			arrow.y = arrowsPos['y'] + n * Y_STEP;
			trace('arrow drawed ' + arrow);
			return arrow;
		}
		public function addArrow(value:String) {
			var n:int;
			if (selectedArrow) { // insert before
				n = arrows.indexOf(selectedArrow);
				answer.addArrow(n);
			}else { // insert after all
				n = answer.addArrow();			
			}
			answer.setArrow(n, value);
			redrawScrollBar();
			return n;
		}
		
		public function setArrow(value:String) {
			trace('set Arrow ' + value + ' '+selectedArrow);
			var r:Array;
			var n:int;
			if (selectedArrow) {// update selected arrow
				n = arrows.indexOf(selectedArrow);
				answer.setArrow(n, value);
//				redrawArrow(n);
				drawAnswer();
			}else { // insert after all
				n = addArrow(value);
				redrawArrow(n);
			}
			hideNeedMore();
		}
		
		private function removeArrow() {
			
		}
		
		public function setBlock(value:String) {
			var n:uint;
			var r:Object;
			if (selectedBlock) {
				if(value){
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
							selectedBlock.value = '"'+r['txt']+'"';	
						}else{
							selectedBlock.value = r['id'];
						}
						trace('selectedBlock.value '+selectedBlock.value);
						try{
							selectedBlock.text = r['txt'];	
						}catch(err:Error){
							selectedBlock.text = '';	
						}
					}
					trace('index ='+blocks.indexOf(selectedBlock))
					answer.setBlock(blocks.indexOf(selectedBlock), value);
					hideNeedMore();
				}else{
					selectedBlock.showDefaultLabel();
				}
			}
		}
		public function getAnswerSting() {
			return answer.toString();
		}
		private function selectHnd(e:Event) {
			var k:String;
			if(e.target is ABlock){
				selectedBlock = null;
				var block:ABlock;
				for (k in blocks) {
					block = blocks[k];
					if (e.target == block) {
						if(block.selected){
							selectedBlock = block;
						}
					}else{
						block.selected = false;
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
			answer.setBlock(blocks.indexOf(selectedBlock), e.target.value);
		}
		private function removeArrow_clickHnd(e:AEvent) {
			if(_disabled) return;
			if (selectedArrow) {
				answer.removeArrow(arrows.indexOf(selectedArrow));
			}
			drawAnswer();
			dispatchEvent(new Event(Event.CHANGE, true));
		}
		public function showErrors(a:Array, finish:Boolean = false){
			selectedArrow = undefined;
			selectedBlock = undefined;
			var i:int = 0;
			var id:String;
			var needMore:Boolean = true;
			for(id in blocks){
				if(a[i] != 1){
					blocks[id].wrong = true;
					needMore = false;
				}else{
					blocks[id].wrong = false;
				}
				i++;
			}
			for(id in arrows){
//				dbgTF.appendText('\n'+needMore+' '+a[i]);
				if(a[i] != 1){
					arrows[id].wrong = true;
					needMore = false;
				}else{
					arrows[id].wrong = false;
				}
				i++;
			}
//			dbgTF.appendText('\n'+needMore+' '+a[i]);
			if(needMore && a[i] == undefined && finish == false){
				showNeedMore();
			}
		}
		private function showNeedMore(){
			needArrow.visible = true;
			needArrow.y = arrowsPos['y'] + arrows.length * Y_STEP
		}
		private function hideNeedMore(){
			needArrow.visible = false;
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
		
		public function set relations(a:Relations) {
			_relations = a;
		}
		
		public function get relations() {
			return _relations;
		}
		public function set disabled(b:Boolean){
			_disabled = b;
		}
		public function get disabled(){
			return _disabled;
		}
	}
}