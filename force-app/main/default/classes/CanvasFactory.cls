/**
* @description Primary factory class for Canvas Integration
* @author Zakk Tapp, Craftsman Technology Group
* @group Canvas Integration
* @created 2023-03-02
*/

public virtual class CanvasFactory {

    private List<Course_Version__c> customCourses = new List<Course_Version__c>();
    private List<Enrollment__c> customEnrolls = new List<Enrollment__c>();
    private List<Canvas_Term__mdt> terms = new List<Canvas_Term__mdt>();

    /**
    * @description Gets all enrollments created for batch
    */
    public virtual List<Enrollment__c> getEnrollments() {
        return [
            SELECT Id, Name, Course_Version__c, Canvas_ID__c,
            Course_Version__r.Canvas_ID__c, Course_Version__r.SIS_ID__c,
            Status__c, Contact__c
            FROM Enrollment__c
            WHERE Sync_Status__c = 'In Batch Queue'
        ];
    }

    /**
    * @description updates enrollments in 
    */
    public virtual void updateEnrollments(List<Enrollment__c> enrollments) {
        try {
            update enrollments;
        } catch (DmlException e) {
            Logger.error(Parameter.ENROLLMENT_DML_EX + e.getMessage());
            Logger.saveLog();
        }
    }

    /**
    * @description public access to method
    */
    public virtual EnrollmentsWrapper getEnrollmentsWrapper() {
        return new EnrollmentsWrapper(this);
    }

    /**
    * @description enrollments class
    */
    public class EnrollmentsWrapper {

        private List<Enrollment__c> enrollments = new List<Enrollment__c>();

        private Map<Id, List<Enrollment__c>> conIdEnrollments = new Map<id, List<Enrollment__c>>();
        private Set<Id> contactIds = new Set<Id>();

        public EnrollmentsWrapper(CanvasFactory factory) {
            this.enrollments = factory.getEnrollments();
            this.makeEnrollmentMap();
        }

        private void makeEnrollmentMap() {
            for (Enrollment__c enrollment : this.enrollments) {
                Id conId = enrollment.Contact__c;
                this.contactIds.add(conId);
                if (this.conIdEnrollments.containsKey(conId)) {
                    List<Enrollment__c> tempEnrolls = conIdEnrollments.get(conId);
                    tempEnrolls.add(enrollment);
                    this.conIdEnrollments.put(conId, tempEnrolls);
                } else {
                    this.conIdEnrollments.put(conId, new List<Enrollment__c>{enrollment});
                }
            }
        }

        public Set<Id> getContactIds() {
            return this.contactIds;
        }

        public Map<Id, List<Enrollment__c>> getEnrollmentsMap() {
            return this.conIdEnrollments;
        }
    }

    /**
    * @description Gets all courses created for batch
    */
    public virtual List<Course_Version__c> getCourses() {
        return [
            SELECT Id, Name, Canvas_ID__c, Active__c,
            Canvas_Status__c, Canvas_Subaccount_Name__c,
            Canvas_Subaccount_SIS_ID__c, Term_Name__c,
            Term_SIS_ID__c, Start_Date__c, SIS_ID__c, Long_Name__c,
            Canvas_Term__c, Last_Canvas_Sync__c, End_Date__c
            FROM Course_Version__c
            WHERE Sync_Status__c = 'In Batch Queue'
        ];
    }

    /**
    * @description Handles getting Term Metadata for Course Creation
    */
    public virtual List<Canvas_Term__mdt> getAllTerms() {
        return [
            SELECT Id, DeveloperName, Canvas_Name__c,
            Canvas_Workflow_State__c, Course_Version_Picklist_Value__c,
            End_At__c, Id__c, SIS_Term_ID__c, Start_At__c
            FROM Canvas_Term__mdt
            WHERE Canvas_Workflow_State__c = 'active'
        ];
    }

    /**
    * @description setter for Course Versions
    */
    public virtual void setCourses(List<Course_Version__c> courses) {
        this.customCourses = courses;
    }

    /**
    * @description returns a list of Course Versions instantiated
    * with the Controller when it was created - useful if there's a need to
    * handle a custom list of courses.
    */
    public virtual List<Course_Version__c> getCustomCourses() {
        return this.customCourses;
    }

    /**
    * @description public access method
    */
    public virtual CoursesWrapper getCoursesWrapper() {
        return new CoursesWrapper(this);
    }

    /**
    * @description updates Course Versions
    */
    public virtual void updateCourses(List<Course_Version__c> courses) {
        try {
            update courses;
        } catch (DmlException e) {
            Logger.error(Parameter.ENROLLMENT_DML_EX + e.getMessage());
            Logger.saveLog();
        }
    }

    /**
    * @description Wrapper class
    */
    public class CoursesWrapper {

        private final List<Course_Version__c> courses;
        private final List<Canvas_Term__mdt> terms;
        private Map<String, Canvas_Term__mdt> picklistToTerm = new Map<String, Canvas_Term__mdt>();
        
        public CoursesWrapper(CanvasFactory factory) {
            this.courses = factory.customCourses.size() != 0 ? factory.getCustomCourses() : factory.getCourses();
            this.terms = factory.getAllTerms();
            System.debug('*** this.courses: ' + this.courses);
        }

        public List<Course_Version__c> getCourseVersions() {
            return this.courses;
        }

        public Map<String, Canvas_Term__mdt> getTermsMap() {
            this.makeTermMap();
            return this.picklistToTerm;
        }

        private void makeTermMap() {
            for (Canvas_Term__mdt term : this.terms) {
                picklistToTerm.put(term.Course_Version_Picklist_Value__c, term);
            }
        }
    }

    /**
    * @description Gets all Users for a list of ContactIds
    */
    public virtual List<User> getUsers(Set<Id> contactIds) {
        return [
            SELECT Id, ContactId, CanvasID__c
            FROM User
            WHERE ContactId IN :contactIds
            AND CanvasID__c != ''
        ];
    }

    /**
    * @description public access method
    */
    public virtual UsersWrapper getUsersWrapper(Set<Id> contactIds) {
        return new UsersWrapper(this, contactIds);
    }


    /**
    * @description Wrapper class
    */
    public class UsersWrapper {

        private final List<User> users;
        private final Map<Id, User> conIdUser = new Map<Id, User>();

        public UsersWrapper(CanvasFactory factory, Set<Id> contactIds) {
            this.users = factory.getUsers(contactIds);
            this.makeUserMap();
        }

        private void makeUserMap() {
            for (User user : this.users) {
                this.conIdUser.put(user.ContactId, user);
            }
        }

        public Map<Id, User> getUserMap() {
            return this.conIdUser;
        }

    }

}