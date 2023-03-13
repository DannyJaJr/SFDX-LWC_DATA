/**
 * @description Post API
 * @author Danny Lafontant, Craftsman Technology Group
 * @group Canvas Integration
 * @created 2023-02-27
 */

public class CanvasPost_API {
    //metadata for account_id value
    private static String accountId; 
   
        public static void createCourse() {
              //Custom settings that store data for Aouth
      CanvasSuport__c cst = CanvasSuport__c.getInstance();
      // Get the values of the "token_c" and "url_c" fields
      String tokenValue = cst.canvasToken__c;
      String urlValue = cst.canvasUrl__c;

        //Map all relevant data to complete the endpoint
        Map<String, Canvas_Support__mdt> allData = Canvas_Support__mdt.getAll(); 
        for(String tokenUrlAccess :  allData.keySet()){
            accountId = allData.get(tokenUrlAccess).accountID__c;
        }
        //complete the endpoint url
        String endpoint =urlValue  + accountId + '/courses?access_token=' + tokenValue;
            
             // Define a list to store the Course records
         List<Course__c> courseList = [SELECT Id, Name, Course_Code__c, SIS_Course_ID__c FROM Course__c LIMIT 1];
        // Construct a JSON payload containing the course data
        List<Map<String, Object>> courses = new List<Map<String, Object>>();
        for (Course__c course : courseList) {
          Map<String, Object> courseData = new Map<String, Object>();
          courseData.put('name', course.Name);
          courseData.put('code', course.Course_Code__c);
          courseData.put('sis_code', course.SIS_Course_ID__c);
          courses.add(courseData);
          }
          String payload = JSON.serialize(courses);
          System.debug(courses);
            
        //      //create the JSON format for courses
       //   String requestBody = '';
       //  for (Map<String, Object> courseData : courses) {
       //   String name = (String) courseData.get('name');
      //    String code = (String) courseData.get('code');
     //   String sis_code = (String) courseData.get('sis_code');
     //  requestBody += '{"course": {"name": "' + name + '", "course_code": "' + code + '", "sis_course_id": "' + sis_code + '"}},';
      // }  
      //      // Remove the trailing comma
      //   if (requestBody.endsWith(',')) {
       //  requestBody = requestBody.substring(0, requestBody.length() - 1);
       // } 
       // 
           // Create the JSON format for the first course
           String myBody = ''; 
          if (!courses.isEmpty()) {
          Course__c firstCourse = courseList[0];
          String name = (String) firstCourse.Name;
           String code = (String) firstCourse.Course_Code__c;
           String sis_code = (String) firstCourse.SIS_Course_ID__c;
          myBody = '{"course": {"name": "' + name + '", "course_code": "' + code + '", "sis_course_id": "' + sis_code + '"}}';
          }     
         System.debug(myBody);

       Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint );
        request.setMethod('POST');
       request.setHeader('Content-Type', 'application/json');
        request.setBody(myBody); // replace with your own JSON payload
       HttpResponse response = http.send(request);
            // Handle the response
        if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
            System.debug('Course created successfully' + response.getStatusCode());
             System.debug(response.getBody());
        } else {
            System.debug('Failed to create course: ' + response.getStatus() + response.getStatusCode());
           }
            
       
        }
}