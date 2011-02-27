package com.vango.performanceui.view.display
{
	import com.bit101.components.ScrollPane;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import com.vango.performance.vo.TestConfiguration;

	import flash.display.DisplayObject;

	/**
	 * @author James
	 */
	public class TestsView extends LiquidComponent
	{
		//{	Fields
		
		private var _window:Window;
		private var _contentPanel:ScrollPane;
		private var _renderContainer:VBox;
		private var _testRenderers:Array = [];
		
		//}
		
		//{	Public Methods
		
		/**
		 * Adds a test to the view
		 */
		public function addTest(testConfig:TestConfiguration):void
		{
			// create a new test renderer
			var tr:TestRenderer = new TestRenderer();
			_testRenderers.push(tr);
			tr.isOdd = Boolean((_testRenderers.length & 1) == 1);
			tr.setData(testConfig);
			_renderContainer.addChild(tr);
			
			// force a redraw
			doDraw();
		}
		
		//}
		
		//{	Private Methods
		
		/**
		 * Initialises the class
		 */
		override protected function init():void
		{
			// build the panel that will contain the tests
			_window = new Window(this, 0, 0, "Tests");
			_window.draggable = false;
			_window.shadow = false;
			_contentPanel = new ScrollPane(_window.content, 0, 0);
			_contentPanel.dragContent = false;
			_renderContainer = new VBox(_contentPanel.content);
			_renderContainer.spacing = 5;
			
			super.init();
		}
		
		/**
		 * Draws the component when the size has been updated
		 */
		override protected function doDraw():void
		{
			for each (var tr:DisplayObject in _testRenderers)
				tr.width = width - 10;
			
			_window.width = width;
			_window.height = height;
			_contentPanel.width = width;
			_contentPanel.height = height - _window.titleBar.height;
			
			_window.draw();
			_renderContainer.draw();
			_contentPanel.draw();
		}
		
		//}
	}
}
