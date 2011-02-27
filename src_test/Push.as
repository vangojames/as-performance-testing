package
{
	/**
	 * @author james.vango
	 */
	public class Push
	{
		//{	Fields
		
		private var _arrayOne:Array;
		private var _arrayTwo:Array;
		
		//}
		
		//{	Public Methods
		
		[Before]
		public function setupOne():void
		{
			_arrayOne = [];
			_arrayTwo = [];
			
			for(var i:int = 0; i < 10000; i++)
				_arrayOne.push(Math.random());
			for(i = 0; i < 10000; i++)
				_arrayTwo.push(Math.random());
		}
		
		[Test]
		public function test():void
		{
			var l:int = _arrayTwo.length;
			for (var i:int = 0; i < l; i++)
				_arrayOne.push(_arrayTwo[i]);
		}
		
		[After]
		public function tearDown():void
		{
			_arrayOne.length = 0;
			_arrayTwo.length = 0;
		}
		
		//}
	}
}
