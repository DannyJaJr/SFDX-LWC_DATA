public class MeetingRequestController {
    
    @AuraEnabled
    public static List <Meeting_Request__c> onInit(){
        User u = [select id, contactId from User where id = : UserInfo.getUserId()];
        id getContactId = u.ContactId;
        if(getContactId != NULL){
            List <Meeting_Request__c> MeetingList =  [SELECT Id, Name, Description__c, Preferred_Date__c,Status__c,What_would_you_like__c FROM Meeting_Request__c Where Contact__c =:getContactId]; 
            return MeetingList;
        }
        else{
            return Null;
        }
       
    }
}