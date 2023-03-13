public with sharing class FileUploadController {
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data,String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data);
        } 
        return Id.valueOf(fileId);
    }
 
    public static Id saveTheFile(Id parentId, String fileName, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        contentversion objContent = new contentversion();
        objContent.title=fileName;
        objContent.VersionData=EncodingUtil.base64Decode(base64Data);
        objContent.FirstPublishLocationId= parentId;
        objContent.PathOnClient=fileName;
        objContent.IsMajorVersion=true;
        insert objContent;
       
        return objContent.Id;
    }
 
   
}