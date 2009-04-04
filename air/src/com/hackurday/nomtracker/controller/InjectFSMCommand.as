package com.hackurday.nomtracker.controller {
	
	import com.hackurday.nomtracker.NTFacade;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.utilities.statemachine.FSMInjector;
	
	/**
	 * InjectFSM command.
	 *
	 * @langversion ActionScript 3.0
	 * @author Justin Brown &lt;justin&#64;smartlogicsolutions.com&gt;
	 * @date 04/04/2009
	 * @version 0.1
	 */
	public class InjectFSMCommand extends SimpleCommand {
	   
		override public function execute(note:INotification):void {
			var fsm:XML =
			<fsm initial={NTFacade.STATE_LOGIN}>
			     <state name={NTFacade.STATE_LOGIN} changed={NTFacade.CHANGED_LOGIN} entering={NTFacade.ENTER_LOGIN} exiting={NTFacade.EXIT_LOGIN}>
			         <transition action={NTFacade.ACTION_TRY_LOGIN} target={NTFacade.STATE_TRY_LOGIN} />
			     </state>
			     <state name={NTFacade.STATE_TRY_LOGIN} changed={NTFacade.CHANGED_TRY_LOGIN} entering={NTFacade.ENTER_TRY_LOGIN} exiting={NTFacade.EXIT_TRY_LOGIN}>
			         <transition action={NTFacade.ACTION_LOADING} target={NTFacade.STATE_LOADING} />
			         <transition action={NTFacade.ACTION_IDLE} target={NTFacade.STATE_IDLE} />
			     </state>
			     <state name={NTFacade.STATE_LOADING} changed={NTFacade.CHANGED_LOADING} entering={NTFacade.ENTER_LOADING} exiting={NTFacade.EXIT_LOADING}>
			         <transition action={NTFacade.ACTION_IDLE} target={NTFacade.STATE_IDLE} />
			     </state>
			     <state name={NTFacade.STATE_IDLE} changed={NTFacade.CHANGED_IDLE} entering={NTFacade.ENTER_IDLE} exiting={NTFacade.EXIT_IDLE}>
			         <transition action={NTFacade.ACTION_LOGIN} target={NTFacade.STATE_LOGIN} />
			     </state>
			</fsm>;
			
			var injector:FSMInjector = new FSMInjector(fsm);
			injector.inject();
		}
		
	}
	
}
