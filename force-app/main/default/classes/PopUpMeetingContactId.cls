public class PopUpMeetingContactId {
 
    @AuraEnabled
    public static void concatContactId(String meetingRecordId){
        User u = [Select id,name,contactid from User Where Id = : Userinfo.getUserId()];
        if(meetingRecordId != null){
            system.debug('meetingRecordId'+meetingRecordId);
            Meeting_Request__c meetReq = [select id,name,contact__c from Meeting_Request__c where id =:meetingRecordId];
            system.debug('meetReq'+meetReq);
            meetReq.contact__c = u.ContactId;
            update meetReq;
        }
    }
}