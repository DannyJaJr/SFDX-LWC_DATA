import { LightningElement, api, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { getRecord, getFieldValue, createRecord } from 'lightning/uiRecordApi';
//import user id
import USER_ID from '@salesforce/user/Id';
//import course version id
import COURSE_VERSION_FIELD from '@salesforce/schema/Course_Version__c.Id';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';



export default class EnrollCourses extends LightningElement {
    //@wire(getRecord, { recordId: '$recordId', fields})
    //POST /api/v1/courses/:course_id/enrollment
   @wire(CurrentPageReference) currentPageReference;

   


    //wire decorator to the getRecord from the uiRecordAPi to get the user
    //based on the curentPage Reference
    @wire(getRecord, {
        recordId: USER_ID,
        fields: []
    })
    currentUser;

    @wire(getRecord, {
        recordId: '$currentPageReference.state.c__courseVersionId',
        fields: [COURSE_VERSION_FIELD]
    })
    courseVersion;


    @wire(getRecord, {
        recordId: '$currentPageReference.state.c__courseVersionId',
        fields: [COURSE_VERSION_FIELD]
    })
    courseNewVersion;


    

    get userId() {
        return this.currentUser.data ? this.currentUser.data.fields.Id.value : null;
    }

    get courseVersionId() {
        return this.courseVersion.data ? this.courseVersion.data.fields.Id.value : null;
    }





    async enrollInCourse() {
        // const courseId = 'INSERT_COURSE_ID_HERE'; // Replace with the actual course ID     
        const courseId = currentUser; // Replace with the actual course ID
        const canvasEndpoint = `/API/VI/courses/${courseId}/enrollments`;

        try {
           // const canvasVersionRecord = await getRecord(this.pageRef.attributes.recordId, { fields: ['Canvas_Version__c'] });
           const canvasVersionRecord = await courseNewVersion;
            const canvasVersion = canvasVersionRecord.fields.Canvas_Version__c.value;
            const accessToken = await this.getAccessToken(canvasVersion);

            const response = await fetch(canvasEndpoint, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${accessToken}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    'enrollment': {
                        'user_id': '$CURRENT_USER_ID_HERE', // Replace with the current user ID
                        'type': 'StudentEnrollment',
                        'enrollment_state': 'active'
                    }
                })
            });

            if (!response.ok) {
                throw new Error(response.statusText);
            }

            const createdEnrollment = await response.json();

            // Create a record in Salesforce to track the enrollment
            const enrollmentRecord = {
                apiName: 'Enrollment__c',
                fields: {
                    Course__c: courseId,
                    User__c: '$CURRENT_USER_ID_HERE', // Replace with the current user ID
                    Canvas_Version__c: canvasVersion,
                    Canvas_Enrollment_ID__c: createdEnrollment.id
                }
            };
            await createRecord(enrollmentRecord);

            // Show success message
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Enrollment created successfully',
                    variant: 'success'
                })
            );
        } catch (error) {
            console.error(error);

            // Show error message
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: `An error occurred: ${error.message}`,
                    variant: 'error'
                })
            );
        }
    }

    async getAccessToken(canvasVersion) {
        // Retrieve the Canvas OAuth credentials from a custom setting or a custom metadata type
        const canvasCredentials = {
            clientId: 'INSERT_CLIENT_ID_HERE',
            clientSecret: 'INSERT_CLIENT_SECRET_HERE',
            redirectUri: 'INSERT_REDIRECT_URI_HERE',
            username: 'INSERT_USERNAME_HERE',
            password: 'INSERT_PASSWORD_HERE'
        };

        const response = await fetch(`https://${canvasVersion}.instructure.com/login/oauth2/token`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: new URLSearchParams({
                grant_type: 'password',
                client_id: canvasCredentials.clientId,
                client_secret: canvasCredentials.clientSecret,
                username: canvasCredentials.username,
                password: canvasCredentials.password
            })
        });
    }

}