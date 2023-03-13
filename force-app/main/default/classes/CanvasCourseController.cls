/**
* @description Primary Controller class for 
* @author Zakk Tapp, Craftsman Technology Group
* @group Canvas Integration
* @created 2023-03-05
*/

public class CanvasCourseController {

    private final CanvasFactory.CoursesWrapper coursesWrapper;

    private CanvasFactory factory;
    private List<CourseWrapper> wrappers = new List<CourseWrapper>();
    private Map<String, Canvas_Term__mdt> picklistToTerm;


    public CanvasCourseController(CanvasFactory factory) {
        this.coursesWrapper = factory.getCoursesWrapper();
        this.picklistToTerm = coursesWrapper.getTermsMap();
        this.makeWrappers();
        this.factory = factory;
        System.debug('*** this.factory: ' + this.factory);
        System.debug('*** this.coursesWrapper: ' + this.coursesWrapper);
    }

    private void makeWrappers() {
        for (Course_Version__c course : this.coursesWrapper.getCourseVersions()) {
            CourseWrapper wrapper = new CourseWrapper(course);
            wrapper.setTerm(picklistToTerm.get(course.Canvas_Term__c));
            this.wrappers.add(wrapper);
        }
    }

    public List<CourseWrapper> getWrappers() {
        return this.wrappers;
    }

    public void doCourseUpdate(List<CourseWrapper> wrappers) {
        List<Course_Version__c> courses = new List<Course_Version__c>();

        for (CourseWrapper wrapper : wrappers) {
            courses.add(wrapper.getCourse());
        }

        this.factory.updateCourses(courses);
    }

    public class CourseWrapper {

        private String accountId;
        private Course_Version__c course;
        private Canvas_Term__mdt term;

        private String resBody;
        private JSONParse parser;

        public CourseWrapper(Course_Version__c course) {
            this.course = course;
        }

        public Boolean hasResponse() {
            return !String.isEmpty(this.resBody);
        }

        public Boolean hasNoCanvasId() {
            return String.isEmpty(this.course.Canvas_ID__c);
        }

        public String getAccountId() {
            return this.accountId;
        }

        public void setTerm(Canvas_Term__mdt term) {
            this.term = term;
        }

        public Course_Version__c getCourse() {
            return this.course;
        }

        public void setPostResponse(String resBody) {
            this.resBody = resBody;
            this.parser = new JSONParse(resBody);
        }

        public void updateCourse() {
            if(this.parser.isObject() && this.parser.exists('id')) {
                this.course.Canvas_ID__c = String.valueOf(this.parser.get('id').getIntegerValue());
                this.course.Last_Canvas_Sync__c = DateTime.now();
                this.course.Canvas_Sub_Account_Id__c = String.valueOf(this.parser.get('account_id').getIntegerValue());
                this.course.Canvas_UUID__c = this.parser.get('uuid').getStringValue();
                this.course.Sync_Status__c = Parameter.STATUS_SYNCED;
            }
        }

        public void resetCourse() {
            this.course.Sync_Status__c = Parameter.STATUS_SYNCED;
        }

        public CanvasCourse getCanvasCourse() {
            System.debug('*** this.course: ' + this.course);
            System.debug('*** this.term.Id__c: ' + this.term.Id__c);
            CanvasCourse canvasCourse = new CanvasCourse();
            canvasCourse.Course co = new CanvasCourse.Course();
            co.name = this.course.Long_Name__c;
            co.course_code = this.course.Name;
            co.is_public = false;
            co.open_enrollment = false;
            co.sis_course_id = this.course.SIS_ID__c;
            co.enrollment_term_id = String.valueOf(this.term.Id__c);
            co.integration_id = this.course.Id;
            canvasCourse.Course = co;
            return canvasCourse;
        }

    }
    
}