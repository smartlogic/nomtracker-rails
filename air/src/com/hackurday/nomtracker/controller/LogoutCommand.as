package com.hackurday.nomtracker.controller {
	
	import com.hackurday.nomtracker.NTFacade;
	import com.hackurday.nomtracker.model.SessionProxy;
	
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncCommand;
	import org.puremvc.as3.utilities.statemachine.StateMachine;
	
	/**
	 * Logout command.
	 *
	 * @langversion ActionScript 3.0
	 * @author Justin Brown &lt;justin&#64;smartlogicsolutions.com&gt;
	 * @date 04/04/2009
	 * @version 0.1
	 */
	public class LogoutCommand extends AsyncCommand {
	   
	    private var ro:RemoteObject;
	   
		override public function execute(note:INotification):void {
			trace('[LogoutCommand::execute]');
			ro = new RemoteObject('rubyamf');
			ro.source = 'SessionsController';
			ro.destroy.addEventListener(ResultEvent.RESULT, onSessionDestroyed);
			//ro.destroy.send();
			
			/* BYPASS REMOTE SERVICE */
			onSessionDestroyed(null);
		}
		
		private function onSessionDestroyed(evt:ResultEvent):void {
			trace('[LogoutCommand::onSessionDestroyed]');
			if( facade.hasProxy(SessionProxy.NAME) ) {
				facade.removeProxy(SessionProxy.NAME);
			}
			
			sendNotification(StateMachine.ACTION, null, NTFacade.ACTION_LOGIN);			
			
			try {
				commandComplete();
			} catch (e:Error) {
				
			}
			
		}
		
	}
	
}
