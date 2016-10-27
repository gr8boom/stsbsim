package ru.sotsbi.u.adminka.data{
	import ru.sotsbi.u.adminka.ui.answer.AError;

	public class Answer extends Object {

		private var _blocks:Array;
		private var _arrows:Array;
		private var _nBlocks:uint;

		public function Answer(s:String = '', nBlocks:uint = 0) {
			trace('parse answer "' + s + '"'+nBlocks);
			_blocks  = new Array();
			_arrows  = new Array();
			_nBlocks = nBlocks;

			if (s=='') return;
			var l:uint = s.length;
			var quot:Boolean;
			var from:uint = 1;
			var answ:String = '';
			var id:uint = 0;
			if ( s.charAt(0) != '(' ) {
				throw new AError('( at 0 not found');
				return;
			}
			if ( s.charAt(l-1) != ')') {
				trace(l + s.charAt(l));
				throw new AError(') at the end of string not found');
				return;
			}
			for (var i:uint = 1; i < l; i++) {
				if (s.charAt(i)=='"') {
					quot=! quot;
					answ+='"';
				}
				if (quot) {
					continue;
				}
				switch (s.charAt(i)) {
					case '"' :
						break;
					case '(' :
						throw new AError('( not at 0 position, pos='+i);
						return;
						break;
					case ')' :
						if (i!=l-1) {
							throw new AError(') not at the end of string, at pos='+i);
							return;
						}
						//!!! no break, go down
					case '|' :
						answ=s.substr(from,i-from);
						if (id < nBlocks) { //use nBlock exept _nBlock becouse _nblock inctreases in addBlock()
							addBlock();
							setBlock(id, answ);
						} else {
							if(answ !=''){
								addArrow();
								setArrow(id - nBlocks, answ);
							}
						}
						from=i+1;
						id++;
						break;
				}
			}
			trace('parse answer end bl"' + _blocks + '" arr"'+_arrows);
			//add blocks to answer if it was not enough in answer string
			for(var j:int = _blocks.length; j<nBlocks; j++){
				addBlock();
			}
		}

		public function toString() {
			var s:String = '('+_blocks.concat(_arrows).join('|')+')'
			return s;
		}

		public function addBlock(n:int = -1) {
			if (n===-1) {
				_blocks.push('');
			} else {
				_blocks.splice(n,0,'');
			}
			_nBlocks++;
		}

		public function removeBlock(n:uint) {
			_blocks.splice(n,1);
			_nBlocks--;
		}

		public function setBlock(n:uint, value:String) {
			_blocks[n] = value;
		}
		
		public function getBlock(n:uint) {
			trace('getBlock ' + n + ' from ' + _blocks);
			return _blocks[n];
		}

		public function addArrow(n:int = -1) {
			var t:int;
			if (n===-1) {
				t = _arrows.push('');
				return t-1;
			} else {
				_arrows.splice(n,0,'');
				return n;
			}
		}

		public function removeArrow(n:int = -1) {
			if (n===-1) {
				_arrows.splice(-1,1);
			} else {
				_arrows.splice(n,1);
			}
		}
		
		public function setArrow(n:uint, value:String) {
			_arrows[n]=value;
		}

		public function getArrow(n:uint) {
			return _arrows[n];
		}

		public function removeByValue(s:String) {
			var b:uint=_blocks.indexOf(s);
			if (b>=0) {
				removeBlock(b);
			}
			var a:uint=_arrows.indexOf(s);
			if (a>=0) {
				removeBlock(b);
			}
			if (b>=0||a>=0) {
				return true;
			}
			return false;
		}
		public function get length(){
			return _arrows.length + _blocks.length;
		}
	}

}