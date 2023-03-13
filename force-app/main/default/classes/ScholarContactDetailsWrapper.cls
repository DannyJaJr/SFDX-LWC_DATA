public class ScholarContactDetailsWrapper {
    
    @auraEnabled public contact con;
    @auraEnabled public string contentVersionId;
    public ScholarContactDetailsWrapper(contact con,string contentVersionId){
        this.con=con;
        this.contentVersionId=contentVersionId;
        
    }

}