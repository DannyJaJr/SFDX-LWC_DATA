@isTest
public class AttachmentUploadController_TEST {
	
    public static testmethod void Test() {
        Contact cont = new Contact(LastName = 'Test');
        insert cont;
        
        AttachmentUploadController ctrl = new AttachmentUploadController(new ApexPages.StandardController(cont));
        Attachment att = ctrl.attachment;
        att.Body = EncodingUtil.convertFromHex('4A4B4C');
        ctrl.upload();
    }
}