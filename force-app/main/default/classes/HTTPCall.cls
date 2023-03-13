/*********************************************************************************************
* Class: CanvasAssignment
* Methods: "Get" call that display all many assignments based on a course from "/courses/xx/assignments"
---------------------------------------------------------------------------------------------
* Utility Test Data: 
---------------------------------------------------------------------------------------------
* Version History: (All changes and TA reworks should be entered as new row )
* VERSION    DEVELOPER NAME         Updated              Initial Draft
* 1.0        Craftsman Tech                               02/10/2023
**********************************************************************************************/
public with sharing class HTTPCall {

     //String to store authentication
     private static String token;
     private static String endPointUrl;
     private static String myEmail= UserInfo.getUserEmail();

     @AuraEnabled  
         public static string getCourseData(){


             try { 
                 String endpoint = endPointUrl + '/users/sis_user_id:'+myEmail+'/courses?access_token=' + token;
                 // String endpoint = '';
                 Http http = new Http();
                 HttpRequest req = new HttpRequest();
                 req.setEndpoint(endpoint);
                 req.setMethod('GET');
                 HttpResponse resp = http.send(req);
                 if (resp.getStatusCode() == 403) {
                     // handle the unauthorized access
                     System.debug('Unauthorized access: ' + resp.getBody());
                 } else {
                     // handle the successful request
                     System.debug('Successful request: ' + resp.getBody());
                 }
                 System.debug('the status code is =====>: ' + resp);
                 System.debug(resp.getBody());
                 return resp.getBody();

             } catch (Exception e) {
                 throw new AuraHandledException(e.getMessage());
             }    
         }

    @AuraEnabled
    public static string getEnrollment(){
     //Create fed Id from 'Fed_ID_from_User__c'
   

        // Map<String, Canvas_Support__mdt> allData = Canvas_Support__mdt.getAll(); 
        // for(String tokenUrlAccess :  allData.keySet()){
        //     token = allData.get(tokenUrlAccess).canvasToken__c;
        //     endPointUrl = allData.get(tokenUrlAccess).canvasUrl__c;
        // }
        
        //Start a Get call to see data
        try {
            String endpoint = endPointUrl + '/users/sis_user_id:'+myEmail+'/enrollments?access_token=' + token;
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            HttpResponse resp = http.send(req);
            if (resp.getStatusCode() == 403) {
                // handle the unauthorized access
                System.debug('Unauthorized access: ' + resp.getBody());
            } else {
                // handle the successful request
                System.debug('Successful request: ' + resp.getBody());
            }
            System.debug('the status code is =====>: ' + resp);
            System.debug(resp.getBody());
            return resp.getBody();
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
       
    }


}