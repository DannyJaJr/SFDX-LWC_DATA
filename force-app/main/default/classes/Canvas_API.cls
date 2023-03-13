/**
 * @description       : Rent Manager Integration - API
 * @author            : Zachery Tapp Craftsman Technology Group
 * @group             : Canvas Integration
 * @last modified on  : 02-18-2023
 * @last modified by  : Zachery Tapp, Craftsman Technology Group
 **/

public class Canvas_API {

    private String AUTH_HEADER;
    private Canvas_Setting__c setting = Parameter.getCanvasSetting;
    private Map<String, String> mapParams = new Map<String, String>();

    /**
    * @description callout for courses
    */
    public String getAllCourses() {
        HTTPService callout = new HTTPService('PostCourses');
       
        callout.buildHTTPRequest();
        HttpResponse objRes = callout.sendRequest();
        return handleResponse(objRes);
    }

    /**
    * @description Handles POSTing Enrollments to Canvas
    * @param body - the body of the POST call
    * @param sisCourseId - the SIS Course Id to enroll - this is required
    * @return the response from the call
    */
    public String postEnrollment(String body, String sisCourseId) {
        HTTPService callout = new HTTPService(Parameter.CREATE_ENROLLMENT_CONFIG);
        callout.setHeaderParameter('Authorization', 'Bearer ' + Parameter.getCanvasSetting.Token_Production__c);
        callout.setHeaderParameter('Content-Type', 'application/json');

        String uri = callout.getEndpoint() + 'sis_course_id:' + sisCourseId + '/enrollments';
        callout.setEndpoint(uri);
        callout.setBody(body);
        callout.buildHTTPRequest();

        Logger.info('URL: ' + uri);
        Logger.info('Body: ' + body);
        Logger.info('Header:' + callout.getHeaderParameters());
        Logger.info(String.valueOf(callout));

        HttpResponse response = callout.sendRequest();
        return this.handleResponse(response);
    }

    /**
    * @description Handles posting courses to Canvas
    * @param body - the body of the POST call
    * @return the response from the call
    */
    public String postCourse(String body) {
        HTTPService callout = new HTTPService(Parameter.CREATE_COURSE_CONFIG);
        callout.setHeaderParameter('Authorization', 'Bearer ' + Parameter.getCanvasSetting.Token_Production__c);
        callout.setHeaderParameter('Content-Type', 'application/json');

        String uri = callout.getEndpoint() + '53/courses';
        callout.setEndpoint(uri);
        callout.setBody(body);
        callout.buildHTTPRequest();

        Logger.info('URL: ' + uri);
        Logger.info('Body: ' + body);
        Logger.info('Header:' + callout.getHeaderParameters());
        Logger.info(String.valueOf(callout));

        HttpResponse response = callout.sendRequest();
        return this.handleResponse(response);
    }

    /**
    * @description Generic response handler
    * @param objRes - an HTTPResponse object to evaluate
    * @return String of the response if it's valid
    */
    private String handleResponse(HTTPResponse objRes) {
        if (objRes.getStatusCode() == 200 && String.isNotEmpty(objRes.getBody())) {

            // Handles success
            Logger.info('Success Body: ' + objRes.getBody());
            Logger.info('Success Header: ' + objRes.getHeaderKeys());
            Logger.saveLog();
            return objRes.getBody();
        } else if (objRes.getStatusCode() == 403) {

            // handle the unauthorized access
            Logger.error('Error Body: ' + objRes.getBody());
            Logger.error('Error Status: ' + objRes.getStatusCode());
            Logger.error(Parameter.BAD_CANVAS_RESPONSE + '403');
            Logger.saveLog();
        } else {

            // Handles error
            Logger.error('Error Body: ' + objRes.getBody());
            Logger.error('Error Status: ' + objRes.getStatusCode());
            Logger.error(Parameter.BAD_CANVAS_RESPONSE);
            Logger.saveLog();
            throw new Parameter.HTTPServiceException(Parameter.BAD_CANVAS_RESPONSE + '404');
        }

        return objRes.getBody();
    }
}