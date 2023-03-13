@isTest
public class MoveAttachments_TEST {
    public static testMethod void testBatch() {
		CreateTestData.create();
        
        Test.StartTest();
        User owner = [Select Id From User Where IsActive = true Limit 1];
        MoveAttachments ma = new MoveAttachments(owner.Id);
        ID batchprocessid = Database.executeBatch(ma);
        Test.StopTest();
        
        List<Attachment> attachments = [Select Id, ParentId From Attachment];
        Integer schCount = 0;
        for (Attachment a : attachments) {
            if (a.ParentId.getSObjectType() == Schema.Scholar__c.SObjectType) schCount++;
        }
        
        System.assertEquals(6, schCount);
   }
}