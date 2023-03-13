/**
* @description Primary controller for the Enrollments Object
* @author Zakk Tapp, Craftsman Technology Group
* @group Canvas Integration
* @created 2023-02-28
*/

public class CanvasEnrollmentController {

    private final CanvasFactory.EnrollmentsWrapper enrollments;
    private final CanvasFactory.UsersWrapper users;
    private List<EnrollWrapper> wrappers = new List<EnrollWrapper>();
    private CanvasFactory factory;

    public CanvasEnrollmentController(CanvasFactory factory) {
        this.factory = factory;
        this.enrollments = factory.getEnrollmentsWrapper();
        this.users = factory.getUsersWrapper(this.enrollments.getContactIds());
        this.makeWrappers();
    }

    /**
    * @description handles creating Enrollment Wrapper classes
    */
    private void makeWrappers() {

        Map<Id, User> mapUsers = this.users.getUserMap();
        Map<Id, List<Enrollment__c>> mapEnrolls = this.enrollments.getEnrollmentsMap();

        for (Id conId : mapusers.keySet()) {
            User sfUser = mapUsers.get(conId);
            for (Enrollment__c enroll : mapEnrolls.get(conId)) {
                this.wrappers.add(
                    new EnrollWrapper(sfUser, enroll)
                );
            }
        }
    }

    /**
    * @description access EnrollmentWrappers
    */
    public List<EnrollWrapper> getWrappers() {
        return this.wrappers;
    }

    /**
    * @description Handles updating enrollments
    */
    public void doEnrollmentUpdate(List<EnrollWrapper> wrappers) {
        List<Enrollment__c> enrolls = new List<Enrollment__c>();

        for (EnrollWrapper wrapper : wrappers) {
            enrolls.add(wrapper.getEnrollment());
        }

        factory.updateEnrollments(enrolls);
    }

    /**
    * @description Primary wrapper class - this should be used for constructing
    * Enrollments to go to Canvas
    */
    public class EnrollWrapper {
        
        private String sisUserId;
        private String sisCourseId;
        private User sfUser;
        private Enrollment__c enrollment;

        private String resBody;
        private JSONParse parser;

        public EnrollWrapper(User sfUser, Enrollment__c enrollment) {
            this.sisUserId = sfUser.CanvasID__c;
            this.sisCourseId = enrollment.Course_Version__r.SIS_ID__c;
            this.sfUser = sfUser;
            this.enrollment = enrollment;
        }

        /**
        * @description get SIS Id - used in constructing
        * the Enrollment object
        */
        public String getSisUserId() {
            return this.sisUserId;
        }

        /**
        * @description get SIS Id - used in constructing
        * the Enrollment object
        */
        public String getSisCourseId() {
            return this.sisCourseId;
        }

        /**
        * @description Get Enrollment__c object for wrapper
        */
        public Enrollment__c getEnrollment() {
            return this.enrollment;
        }

        public Boolean hasResponse() {
            return !String.isEmpty(this.resBody);
        }

        public Boolean hasNoCanvasId() {
            return String.isEmpty(this.enrollment.Canvas_ID__c);
        }

        /**
        * @description Sets the response on the wrapper
        */
        public void setPostResponse(String resBody) {
            this.resBody = resBody;
            this.parser = new JSONParse(this.resBody);
        }

        public void updateEnrollment() {
            if (this.parser.isObject() && this.parser.exists('id')) {
                this.enrollment.Canvas_ID__c = String.valueOf(this.parser.get('id').getIntegerValue());
                this.enrollment.Last_Canvas_Sync__c = DateTime.now();
                this.enrollment.Sync_Status__c = Parameter.STATUS_SYNCED;
                this.enrollment.Status__c = Parameter.STATUS_ENROLLED;
            }
        }

        public void resetEnrollment() {
            this.enrollment.Sync_Status__c = Parameter.STATUS_SYNCED;
        }

        /**
        * @description Builds enrollment objects for insert
        */
        public CanvasEnrollment getCanvasEnrollment() {
            CanvasEnrollment canvasEnroll = new CanvasEnrollment();
            CanvasEnrollment.Enrollment enroll = new CanvasEnrollment.Enrollment();
            enroll.user_id = 'sis_user_id:' + this.sisUserId;
            enroll.type = Parameter.ENROLLMENT_TYPE;
            enroll.enrollment_state = Parameter.ENROLLMENT_STATE;
            enroll.notify = Parameter.ENROLLMENT_NOTIFY;
            enroll.self_enrolled = Parameter.ENROLLMENT_SELF_ENROLL;
            canvasEnroll.enrollment = enroll;
            return canvasEnroll;
        }
    }
}