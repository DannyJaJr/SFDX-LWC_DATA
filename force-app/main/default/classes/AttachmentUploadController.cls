public with sharing class AttachmentUploadController {
    
    private Contact contact;
    
    public AttachmentUploadController(ApexPages.StandardController stdController) {
        contact = (Contact) stdController.getRecord();
    }
    
    public Attachment attachment {
        get {
            if (attachment == null) {
                attachment = new Attachment();
                attachment.Name = 'Photo';
            }
            return attachment;
        }
        set;
    }
    
    public PageReference upload() {
        
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = contact.Id;
        attachment.IsPrivate = false;
        attachment.ContentType = 'image/jpeg';
        
        try {
            insert attachment;
            contact.Photo_Attachment_Id__c = attachment.Id;
            update contact;
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
            return null;
        } finally {
            attachment = new Attachment(); 
        }
        
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
        return null;
    }
}