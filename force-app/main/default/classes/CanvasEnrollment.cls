/**
 * @description       : Generated with JSON2Apex http://json2apex.herokuapp.com/
 * @author            : Zachery Tapp Craftsman Technology Group
 * @group             : Canvas Integration
 * @last modified on  : 03-01-2023
 * @last modified by  : Zachery Tapp, Craftsman Technology Group
**/

public class CanvasEnrollment {

	public Enrollment enrollment;

	public class Enrollment {
		public String user_id;
		public String type;
		public String enrollment_state;
		public Boolean notify;
		public Boolean self_enrolled;
	}

	
	public static CanvasEnrollment parse(String json) {
		return (CanvasEnrollment) System.JSON.deserialize(json, CanvasEnrollment.class);
	}
}