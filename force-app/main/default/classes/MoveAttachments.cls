global class MoveAttachments implements Database.Batchable<sObject> {
    global Map<Id, Scholar_Contact_Map__c> contactMap;
    global Map<Id, User> users;
    global Id ownerId;

/*  Photo Attachments id is stored on the Contact record. As of 5/1/2015 the attachment ids are (mostly) correct
    but the attachments are attached to the Scholar record. We need to migrate the attachments that are listed
    as Contact.Photo_Attachment_Id__c who's parent is a Scholar record to the Contact record.

	This code just ignores them if they are still on the Contact.
*/

    global MoveAttachments(Id oid) {
        List<Scholar_Contact_Map__c> scholars = [Select Contact__c, Scholar__c, Photo_Attachment_Id__c From Scholar_Contact_Map__c];
        
        // build a map based on contact id
        contactMap = new Map<Id, Scholar_Contact_Map__c>();
        for (Scholar_Contact_Map__c s : scholars) {
            contactMap.put(s.Contact__c, s);
        }
        
        ownerId = oid;
        users = new Map<Id, User>([Select Id, IsActive From User]);
    }
    
    global Database.queryLocator start(Database.BatchableContext ctx) {
        return Database.getQueryLocator('Select Id, ParentId, Name, ContentType, Body, OwnerId, Description From Attachment');
    }
    
    global void execute(Database.BatchableContext ctx, List<sObject> scope) {
        List<Attachment> inserts = new List<Attachment>();
        List<Attachment> deletes = new List<Attachment>();
        for (sObject sobj : scope) {
            Attachment a = (Attachment) sobj;
            if (a.ParentId.getSObjectType() == Schema.Contact.SObjectType  ) {
                System.debug('Found contact attachment');
                if (contactMap.containsKey(a.ParentId)) {
                    System.debug('Found contact in map');
                    Scholar_Contact_Map__c s = contactMap.get(a.ParentId);
                    if (a.Id != s.Photo_Attachment_Id__c) {
		                Attachment att = new Attachment(
		                    ParentId = s.Scholar__c,
		                    Name = a.Name,
		                    ContentType = a.ContentType,
		                    Body = a.Body,
		                    Description = a.Description
		                );
		                // see if the current owner is active
		                // if so uset it, otherwise use the passed user id
		                // or the user running the job will get it by default
		                User u = users.get(a.OwnerId);
		                if (u.IsActive) {
		                    att.OwnerId = a.OwnerId;
		                } else if(ownerId != null) {
		                    att.OwnerId = ownerId;
		                }
		                inserts.add(att);
		                deletes.add(a);
                    }
                }
            }
        }
            
        if (inserts.size() > 0) {
            System.debug('Migrating ' + inserts.size() + ' attachments');
            insert inserts;
            delete deletes;
        }
    }
    
    global void finish(Database.BatchableContext ctx) {
        
    }
}