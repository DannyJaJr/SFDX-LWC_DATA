public class meetingRequesttriggerHandler {
 
    public static boolean isExternalUser;
    // this method is used for transfering the data  from Meeting object to Event Object
    
    public static void onBeforeInsert(List<Meeting_request__c> meetingList){
        
        List<Event> eventList = new List<Event>();
        
         User u = [Select id,name,contactid from User Where Id = : Userinfo.getUserId()];
         
        if(u.ContactId==NULL)
             return ;
        
        User u2 = [Select id,name from User Where Name like 'Nate%'];
        system.debug('name'+u2.Name);
        for(Meeting_request__c meetingRecord  : meetingList ){
            event evt = new Event();
            evt.Subject = meetingRecord.Meeting_Purpose__c;
            evt.StartDateTime = meetingRecord.Preferred_Date__c;
            evt.DurationInMinutes=30;
            evt.OwnerId = u2.id; //   User
            evt.WhoId  =  u.ContactId; //Contact
            eventList.add(evt);
        }
        
        System.debug('Event to Be created : ' + eventList);
        Insert  eventList;
    }    
}