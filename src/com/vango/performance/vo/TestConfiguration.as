package com.vango.performance.vo
{
	import flash.utils.describeType;
	
	/**
	 * @author James
	 */
	public class TestConfiguration
	{
		//{	Properties
		
		/**
		 * The name of the test
		 */
		public function get name():String { return _name; }
		private var _name:String;
		
		/**
		 * The number of times to run the test
		 */
		public function get testCount():int { return _testCount; }
		private var _testCount:int;
		
		/**
		 * The test class to run
		 */
		public function get testClass():Class { return _testClass; }
		private var _testClass:Class;
		
		/**
		 * Methods to run before the test
		 */
		public function get beforeMethods():Array { return _beforeMethods; }
		private var _beforeMethods:Array;
		
		/**
		 * Methods to run for the test
		 */
		public function get testMethods():Array { return _testMethods; }
		private var _testMethods:Array;
		
		/**
		 * Methods to run after the test
		 */
		public function get afterMethods():Array { return _afterMethods; }
		private var _afterMethods:Array;
		
		/**
		 * The unique identifier for this test
		 */
		public function get id():int { return _id; }
		private var _id:int = -1;
		
		//}
		
		//{	Static methods
		
		private static var _idCounter:int = 0;
		
		//}
		
		//{	Constructor
		
		/**
		 * Constructor
		 */
		public function TestConfiguration(name:String, testClass:Class, testCount:int)
		{
			// reference test class and test count
			this._testClass = testClass;
			this._testCount = testCount;
			this._name = name;
			
			// increase id counter and set unique id
			_idCounter++;
			this._id = _idCounter;
			
			// initialise arrays
			_beforeMethods = [];
			_testMethods = [];
			_afterMethods = [];
			
			// parse the test class
			parseTestClass(testClass);
		}
		
		//}
		
		//{	Public Methods
		
		/**
		 * Returns a new instance of the test class
		 */
		public function getInstance():Object
		{
			return new testClass();
		}
		
		//}
		
		//{	Private Methods
		
		/**
		 * Parses the test class metadata for execution information
		 */
		private function parseTestClass(testClass:Class):void
		{
			var def:XML = describeType(testClass);
			for each (var method:XML in def.factory.method)
			{
				for each (var meta:XML in method.metadata)
				{
					var metaKey:String = meta.@name;
					var order:int = 0;
					for each (var arg:XML in meta.arg)
					{
						if (arg.@key == "order") order = parseInt(arg.@value);
					}
					
					switch(metaKey)
					{
						case "Before":
							insertInToArray(_beforeMethods, method.@name, order);
							break;
						case "Test":
							insertInToArray(_testMethods, method.@name, order);
							break;
						case "After":
							insertInToArray(_afterMethods, method.@name, order);
							break;
					}
				}
			}
			
			// now clean the null values out of each array
			_beforeMethods = cleanArray(_beforeMethods);
			_testMethods = cleanArray(_testMethods);
			_afterMethods = cleanArray(_afterMethods);
		}
		
		/**
		 * Inserts a value into the array at the specified position
		 */
		private function insertInToArray(array:Array, value:*, index:int):void
		{
			// make sure array is of correct length with empty arrays
			var arrayLength:int = index + 1;
			while (array.length < arrayLength) array.push([]);
			// reference sub array
			var subArray:Array = array[index];
			// now push the item into the sub array
			subArray.push(value);
		}
		
		/**
		 * Cleans an array of all null values
		 */
		private function cleanArray(array:Array):Array
		{
			var returnArray:Array = [];
			var l:int = array.length;
			for (var i:int = 0; i < l; i++)
			{
				if (array[i].length > 0) returnArray.push(array[i]);
			}
			return returnArray;
		}
		
		//}
	}
}
