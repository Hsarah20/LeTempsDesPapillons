@isTest
private class OrderServiceTest {

    @isTest
    static void testGetOrderById() {
        Account testAccount = new Account(Name = 'Test Account', Customer_Type__c = 'Particulier');
        insert testAccount;
        
        Order testOrder = new Order(AccountId = testAccount.Id, Status = 'Draft', ShippingCountry = 'France', EffectiveDate = Date.today());
        insert testOrder;
        
        Test.startTest();
        Order result = OrderService.getOrderById(testOrder.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'L\'order ne doit pas être null');
        System.assertEquals(testOrder.Id, result.Id, 'L\'ID doit correspondre');
    }
    
    @isTest
    static void testValidateOrder() {
        Account testAccount = new Account(Name = 'Test Account', Customer_Type__c = 'Particulier');
        insert testAccount;
        
        Order testOrder = new Order(AccountId = testAccount.Id, Status = 'Draft', EffectiveDate = Date.today());
        insert testOrder;
        
        Test.startTest();
        Boolean isValid = OrderService.validateOrder(testOrder);
        Test.stopTest();
        
        System.assertEquals(false, isValid, 'La validation devrait échouer car aucun OrderItem');
    }
}