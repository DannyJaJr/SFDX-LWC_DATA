public class ScholarContactsDetails {
    @AuraEnabled
    Public static ScholarContactDetailsWrapper conData(){
        
        User u = [select id, contactId from User where id = : UserInfo.getUserId()];
        id getContactId = u.ContactId;
        String contentId;
        Contact con = new  Contact();
        set<id> contentVersionId = new set<id>();
        set<id> contentDocumentIds = new set<id>();
        set<string> lstImageFormat = new set<string>();
        lstImageFormat.add('PNG');
        lstImageFormat.add('JPG');
        lstImageFormat.add('JPEG ');
        if(getContactId != null){
            con = [select id,Name,Email,photo__c,Photo_Attachment_Id__c,MobilePhone from contact where id=:getContactId];
            list<contentdocumentlink> lstContentDoc=[SELECT ContentDocumentId, systemModstamp FROM ContentDocumentLink WHERE LinkedEntityId =:getContactId];
            
            for(contentdocumentlink contDoc : lstContentDoc){
                contentDocumentIds.add(contDoc.ContentDocumentId);
            }
            list<ContentVersion> lstContentVersion =[SELECT CreatedDate, Id, ContentDocumentId,FileType,systemModstamp,FirstPublishLocationId, IsLatest, ContentUrl, Title FROM ContentVersion where ContentDocumentId in: contentDocumentIds 
                     and FileType in: lstImageFormat order by systemModstamp desc limit 1];
            if(lstContentVersion.size() != 0){
                for(ContentVersion objContent : lstContentVersion){
                   contentId =  objContent.Id;
                }
            }
        }
        ScholarContactDetailsWrapper scholarWrap = new ScholarContactDetailsWrapper(con,contentId);
        return scholarWrap;
    }
    
}