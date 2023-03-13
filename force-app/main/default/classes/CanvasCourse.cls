/**
 * @description       : Generated by JSON2Apex http://json2apex.herokuapp.com/
 * @author            : Zachery Tapp Craftsman Technology Group
 * @group             : Canvas Integration
 * @last modified on  : 03-01-2023
 * @last modified by  : Zachery Tapp, Craftsman Technology Group
**/

public class CanvasCourse {

    public Course course;

	public class Course {
		public String name;
		public String course_code;
		public Boolean is_public;
		public Boolean open_enrollment;
		public String sis_course_id;
		public String  enrollment_term_id;
		public String integration_id;
	}
	
	public static CanvasCourse parse(String json) {
		return (CanvasCourse) System.JSON.deserialize(json, CanvasCourse.class);
	}
}