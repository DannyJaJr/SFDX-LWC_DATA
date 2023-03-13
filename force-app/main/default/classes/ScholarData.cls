public class ScholarData {
    
    @AuraEnabled
    Public static Scholar__c getScholarData(){
        // Cause of lack of data and objects it is random Query to get sample Data
        // 
        Scholar__c lstScholar = [Select Name,of_Renewals__c,Region__c,Class_Rank__c,College__c,Contact__r.Name from Scholar__c where id='a0117000008w2fS'];
        return lstScholar;
        
    }

}