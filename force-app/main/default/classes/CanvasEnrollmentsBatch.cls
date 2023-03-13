/**
* @description Batch class responsible for creating enrollments in Cavnas
* @author Zakk Tapp, Craftsman Technology Group
* @group Canvas Integration
* @created 2023-03-02
*/

public class CanvasEnrollmentsBatch 
    implements Database.Batchable<CanvasEnrollmentController.EnrollWrapper>, 
    Database.AllowsCallouts,
    Database.Stateful {

    private CanvasEnrollmentController controller;
    private List<CanvasEnrollmentController.EnrollWrapper> wrappers = new List<CanvasEnrollmentController.EnrollWrapper>();
    private List<CanvasEnrollmentController.EnrollWrapper> wrappersToUpdate = new List<CanvasEnrollmentController.EnrollWrapper>();
    private Canvas_API api = new Canvas_API();

    public List<CanvasEnrollmentController.EnrollWrapper> start(Database.BatchableContext objBC) {
        this.controller = new CanvasEnrollmentController(new CanvasFactory());
        this.wrappers = controller.getWrappers();
        return this.wrappers;
    }

    public void execute(Database.BatchableContext objBC, List<CanvasEnrollmentController.EnrollWrapper> records) {

        for (CanvasEnrollmentController.EnrollWrapper record : records) {
            System.debug('*** record: ' + record);
            if (record.hasNoCanvasId()) {
                String sisCourseId = record.getSisCourseId();
                String body = JSON.serialize(record.getCanvasEnrollment());

                String resBody = api.postEnrollment(body, sisCourseId);
                record.setPostResponse(resBody);
            }

            this.wrappersToUpdate.add(record);
        }
    }

    public void finish(Database.BatchableContext objBC) {

        for (CanvasEnrollmentController.EnrollWrapper wrapper : this.wrappersToUpdate) {

            System.debug('*** wrapper: ' + wrapper);
            if (wrapper.hasResponse()) {
                wrapper.updateEnrollment();
            } else if (!wrapper.hasNoCanvasId()) {
                wrapper.resetEnrollment();
            }
        }

        this.controller.doEnrollmentUpdate(this.wrappersToUpdate);
    }

    @InvocableMethod(
        label='Canvas Enrollment Sync'
        description='Gathers any Enrollments with an \'In Batch Queue\' status and POSTs them to Canvas. Check Logger Console for errors'
        category='Other'
    )
    public static void doCanvasEnrollmentSync() {
        Id jobId = Database.executeBatch(new CanvasEnrollmentsBatch(), 1);
    }
}