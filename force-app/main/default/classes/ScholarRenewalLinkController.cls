public class ScholarRenewalLinkController {
    
    @AuraEnabled
    Public static List<scholar__c> Renewallink(){
     
        User u = [select id, contactId from User where id = : UserInfo.getUserId()];
        id getContactId = u.contactId;
        
        List<scholar__c> lstScholar = new List<scholar__c>();
        
        if(getContactId != null){
          lstScholar = [select id,name,Scholar_Renewal_Link__c,Contact__c from scholar__c where Contact__c=:getContactId];
        }
        
        return lstScholar;
    }
    
}