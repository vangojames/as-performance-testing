package com.vango.performanceui.controller.signals
{
	import com.vango.performance.vo.TestConfiguration;

	import org.osflash.signals.Signal;

	/**
	 * @author James
	 */
	public class TestAddedSignal extends Signal
	{
		public function TestAddedSignal()
		{
			super(TestConfiguration);
		}
	}
}
