package com.vango.performanceui.controller.signals
{
	import org.osflash.signals.Signal;

	/**
	 * @author James
	 */
	public class AddTestSignal extends Signal
	{
		public function AddTestSignal()
		{
			super(String, Class, int);
		}
	}
}
