package com.hackurday.nomtracker.model.vo {
	
	[RemoteClass(alias="Transaction")]
	[Bindable]
	public class Transaction {
		
		public var amount:Number;
		public var createdAt:Date;
		public var fromUser:User;
		public var id:int;	
		public var toUser:User;
		public var updatedAt:Date;
		
	}
	
}