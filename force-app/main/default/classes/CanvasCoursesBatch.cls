/**
* @description Batch class Implements CanvasCourseController and API classes
* @author Zakk Tapp, Craftsman Technology Group
* @group Canvas Integration
* @created 2023-03-05
*/

public class CanvasCoursesBatch 
    implements Database.Batchable<CanvasCourseController.CourseWrapper>,
    Database.AllowsCallouts,
    Database.Stateful {

    private CanvasCourseController controller;
    private List<CanvasCourseController.CourseWrapper> wrappers = new List<CanvasCourseController.CourseWrapper>();
    private List<CanvasCourseController.CourseWrapper> wrappersToUpdate = new List<CanvasCourseController.CourseWrapper>();
    private Canvas_API api = new Canvas_API();

    public List<CanvasCourseController.CourseWrapper> start(Database.BatchableContext objBC) {
        this.controller = new CanvasCourseController(new CanvasFactory());
        this.wrappers = this.controller.getWrappers();
        return this.wrappers;
    }

    public void execute(Database.BatchableContext objBC, List<CanvasCourseController.CourseWrapper> records) {

        for (CanvasCourseController.CourseWrapper record : records) {
            System.debug('*** record: ' + record);
            if (record.hasNoCanvasId()) {
                String body = JSON.serialize(record.getCanvasCourse());

                String resBody = api.postCourse(body);
                record.setPostResponse(resBody);
            } else {
                // TODO: Logic to handle PUT
            }

            this.wrappersToUpdate.add(record);
        }
    }

    public void finish(Database.BatchableContext objBC) {
        for (CanvasCourseController.CourseWrapper wrapper : this.wrappersToUpdate) {
            System.debug('*** wrapper: ' + wrapper);
            if (wrapper.hasResponse()) {
                wrapper.updateCourse();
            }
        }

        this.controller.doCourseUpdate(this.wrappersToUpdate);
    }

    @InvocableMethod(
        label='Canvas Course Sync'
        description='Gathers any Courses with an \'In Batch Queue\' status and POSTs them to Canvas. Check Logger Console for errors'
        category='Other'
    )
    public static void doCanvasCourseSync() {
        Id jobId = Database.executeBatch(new CanvasCoursesBatch(), 1);
    }
}