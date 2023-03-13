public class UserProfileScholarPortalController {
    
    @AuraEnabled 
    Public Static contact getProfileData(){
        
        User u = [select id, contactId from User where id = '00517000002ZBYl'];  //: UserInfo.getUserId()];
        id getContactId = u.contactId;
        Contact con = new  Contact();
        if(getContactId != null){
            con = [ SELECT Id, Name, Title, Department, CreatedDate, Marital_Status__c, Skills__c,Photo_Attachment_Id__c, LinkedIn_Profile__c,Phone, 
                   College__c, Full_Name__c,C4G_High_School_or_Organization__c,Email,Fax,MobilePhone,MailingAddress, Biography__c,Description, Number_of_Internships__c, 
                   Number_of_Scholar_Records__c,Corporate_Relationship_Manager__r.name,Volunteer_Notes__c,Languages_Spoken__c,
                   Volunteer_Preference__c, npsp__Primary_Affiliation__c FROM Contact where id=:getContactId];
            
        }
        return con;
    }
}