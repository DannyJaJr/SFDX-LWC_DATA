/**
 * @description       : Used for storing common contants and parameters ceterally
 * @author            : Zachery Tapp Craftsman Technology Group
 * @group             : Core Michigan Community Capital
 * @last modified on  : 02-21-2023
 * @last modified by  : Zachery Tapp, Craftsman Technology Group
 **/

public class Parameter {

  /**
   * @description useful parameter for determining if a Sandbox or not;
   */
  public static Boolean isSandbox {

    get {
      return [SELECT Id, isSandbox FROM Organization LIMIT 1].IsSandbox;
    }
  }

  /**
  * @description return default Cavnas Setting
  */
  public static Canvas_Setting__c getCanvasSetting {
      get {
          return Canvas_Setting__c.getOrgDefaults();
      }
  }

  /**
   * @description errors and exceptions related to not finding the appropriate information from various APIs
   */
  public static final String CUSTOM_METADATA_NOT_FOUND = 'Unable to query custom metadata. Make sure you\'ve passed the correct developer name.';
  public static final String MOCK_NOT_FOUND = 'Response Mock not found for the current request URL';
  public static final String TOKEN_NOT_REFRESHED = 'The RM Token was not successfully refreshed';
  public static final String BAD_CANVAS_RESPONSE = 'The response recieved by Salesforce & Canvas was not as expected - please contact your Adminstrator.';
  public class HTTPServiceException extends Exception {
  }

  public static final String ENROLLMENT_DML_EX = 'There was an error updating enrollments - please review any relevant logs. Error Message: ';

  public static final String INCORRECT_MAP_STRCUCTURE_ARRAY = 'The mapping structure appears to be incorrect - this should be an array';
  public static final String INCORRECT_MAP_STRCUCTURE_OBJECT = 'The mapping structure appears to be incorrect - this should be an innter object';
  public static final String UNHANLDED_SOURCE_KEY = 'The source key doesn\'t have any valid handling options';
  public class DataMapperException extends Exception {
  }

  public class APIDMLException extends Exception {
  }

  public class POSTUnitException extends Exception {
  }

  public static final String REFRESH_RECORD_ERROR = 'There\'s been an error in the RM_RefreshSingleRecord_Queueable class - please contact your adminstrator. Note: some records my not have been updated successfully.';

  public static final String ENROLLMENT_TYPE = 'StudentEnrollment';
  public static final String ENROLLMENT_STATE = 'active';
  public static final Boolean ENROLLMENT_NOTIFY = false;
  public static final Boolean ENROLLMENT_SELF_ENROLL = false;

  public static final String CREATE_ENROLLMENT_CONFIG = 'Create_Canvas_Enrollment';
  public static final String CREATE_COURSE_CONFIG = 'Create_Canvas_Course';


  public static final String STATUS_SYNCED = 'Synced';
  public static final String STATUS_IN_BATCH = 'In Batch Queue';
  public static final String STATUS_ENROLLED = 'Enrolled';
}