public class RenewalHistoryController {
    /**************************************
Method :: getRenewalHistory 
return type :: Void 
params:: void
purpose :: getting renewal History for Community User
**************************************************/
    
    @AuraEnabled
    public static List<renewal> getRenewalHistory(){
        
        User u = [select id, contactId from User where id = : UserInfo.getUserId()];
        id getContactId = u.contactId;
        List<renewal> lstRenewal = new List<renewal>();
        if(getContactId != null){
        for(Renewal__c reNew : [SELECT Id, Name, Term__c, Status__c, Amount__c,School_Year__c,Renewal_Date_Formula__c,CreatedDate,Student__c
                                FROM Renewal__c where Student__c =: getContactId order by CreatedDate Desc] ){
                                    renewal renewalRecord = new renewal();
                                    Datetime dt = reNew.CreatedDate; 
                                    renewalRecord.createddate= dt.format('MM/dd/yyyy');
                                    renewalRecord.term = reNew.Term__c;
                                    renewalRecord.status = reNew.Status__c;
                                    renewalRecord.amount = reNew.Amount__c;
                                    Datetime paymentdate = reNew.Renewal_Date_Formula__c;
                                    renewalRecord.paymentdate = paymentdate.format('MM/dd/yyyy');
                                    renewalRecord.schoolyear=reNew.School_Year__c;
                                    renewalRecord.gpa = '';
                                    
                                    lstRenewal.add(renewalRecord);   
                                }
        //: getContactId  order by CreatedDate Desc];
        }
        System.debug('response.getReturnValue() : '+ lstRenewal);
        return lstRenewal;       
        
    }   
    
    public class renewal{
        @AuraEnabled
        public String createddate;
        @AuraEnabled
        public string term;        
        @AuraEnabled
        public string status;
        @AuraEnabled
        public Decimal amount;
        @AuraEnabled
        public String paymentdate;
        @AuraEnabled
        public string gpa;
        @AuraEnabled
        public string schoolyear;
        
    }
}