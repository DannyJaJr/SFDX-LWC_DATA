/**
 * @description       : Generated with JSON2Apex http://json2apex.herokuapp.com
 * @author            : Zachery Tapp Craftsman Technology Group
 * @group             : Canvas Integration
 * @last modified on  : 03-01-2023
 * @last modified by  : Zachery Tapp, Craftsman Technology Group
**/

@isTest
public class CanvasEnrollment_Test {

	static testMethod void testParse() {
		String json = '{'+
		'        \"enrollment\" : {'+
		'            \"user_id\" : \"sis_user_id:lily.chinmartin@craftsmantech.com\",'+
		'            \"type\" : \"StudentEnrollment\",'+
		'            \"enrollment_state\" : \"active\",'+
		'            \"notify\" : false,'+
		'            \"self_enrolled\" : false'+
		'        }'+
		'    }';

		CanvasEnrollment obj = CanvasEnrollment.parse(json);
		System.assert(obj != null);
	}
}