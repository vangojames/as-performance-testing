package
{
	import com.vango.performanceui.view.display.PerformanceUIView;

	import flash.display.Sprite;

	/**
	 * @author James
	 */
	public class Main extends Sprite
	{
		//{	Fields
		
		private var _testViewer:PerformanceUIView;
		
		//}
		
		//{	Constructor
		
		/**
		 * Constructor
		 */
		public function Main()
		{
			super();
			
			// create test viewer
			_testViewer = new PerformanceUIView();
			
			// add tests
			_testViewer.addTest("concat", Concat, 1000);
			_testViewer.addTest("Push", Push, 1000);
			
			// add test viewer to the stage
			addChild(_testViewer);
		}
		
		//}
	}
}
