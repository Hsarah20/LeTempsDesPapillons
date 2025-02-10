@isTest
private class PermissionControllerTest {
    
    @isTest
    static void test_UserhasPermissiontoSendOrder_PermissionGranted() {
        Test.startTest();
        System.assertEquals(true, PermissionController.UserhasPermissiontoSendOrder());

        Test.stopTest();
    } 
}
