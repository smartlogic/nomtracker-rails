package com.hackurday.nomtracker.controller {
	
	import com.hackurday.nomtracker.NTFacade;
	import com.hackurday.nomtracker.model.SessionProxy;
	import com.hackurday.nomtracker.model.vo.User;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncCommand;
	import org.puremvc.as3.utilities.statemachine.StateMachine;
	
	/**
	 * Login command.
	 *
	 * @langversion ActionScript 3.0
	 * @author Justin Brown &lt;justin&#64;smartlogicsolutions.com&gt;
	 * @date 04/04/2009
	 * @version 0.1
	 */
	public class LoginCommand extends AsyncCommand {
	   	
	   	private var ro:RemoteObject;
	   	
		override public function execute(note:INotification):void {
			trace('[LoginCommand::execute]');
			
			if(note.getBody() == null)
				throw new Error('The body of the LOGIN note must be a login hash!');
			
			ro = new RemoteObject('rubyamf');
			ro.source = 'SessionsController';
			ro.addEventListener(FaultEvent.FAULT, onFault);
			var login:Object = note.getBody();
			
			ro.create.addEventListener(ResultEvent.RESULT, onSessionCreated);
			//ro.create.send(login);
			
			/* BYPASS LOGIN FOR NOW */
			var user:User = new User();
			user.email = "justin@smartlogicsolutions.com";
			user.name = "Justin Brown";
			var re:ResultEvent = new ResultEvent(ResultEvent.RESULT, false, true, user);
			onSessionCreated(re);
		}
		
		private function onFault(evt:FaultEvent):void {
			trace('[LoginCommand::onFault]');
			sendNotification(StateMachine.ACTION, null, NTFacade.ACTION_LOGIN);
		}
		
		private function onSessionCreated(evt:ResultEvent):void {
			trace('[LoginCommand::onSessionCreated]');
			var user:User = evt.result as User;
			// Session created successfully!
			if(user) {
				facade.registerProxy( new SessionProxy(user) );	
				
				sendNotification(StateMachine.ACTION, user, NTFacade.ACTION_IDLE);
			}
			// User not found! Send them back to the login screen.
			else {
				sendNotification(StateMachine.ACTION, null, NTFacade.ACTION_LOGIN);
			}
		}
		
	}
	
}
