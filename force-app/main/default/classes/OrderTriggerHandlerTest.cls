@isTest
private class OrderTriggerHandlerTest {

    @testSetup
    static void setupTestData() {

        // Création Account par
        Account accParticulier = new Account(Name = 'Test Particulier', Customer_Type__c = 'Particulier');
        insert accParticulier;
        
        // Création Account pro
        Account accPro = new Account(Name = 'Test Professionnel', Customer_Type__c = 'Professionnel');
        insert accPro;
        
        // Création orders
        Order orderParticulier = new Order(Name = 'Ordre Particulier', Status = 'Draft', AccountId = accParticulier.Id, EffectiveDate = Date.today());
        Order orderPro = new Order(Name = 'Ordre Professionnel', Status = 'Draft', AccountId = accPro.Id, EffectiveDate = Date.today());
        insert new List<Order>{ orderParticulier, orderPro };
        
        Product2 product = new Product2(Name = 'Test Product', IsActive = true);
        insert product;

        PricebookEntry pbe = new PricebookEntry(
            Product2Id = product.Id,
            Pricebook2Id = Test.getStandardPricebookId(),
            UnitPrice = 100.0,
            IsActive = true
        );
        insert pbe;

        orderParticulier.Pricebook2Id = Test.getStandardPricebookId();
        orderPro.Pricebook2Id = Test.getStandardPricebookId();
        update new List<Order>{ orderParticulier, orderPro };

        // Création d'OrderItems
        OrderItem item1 = new OrderItem(OrderId = orderParticulier.Id, Quantity = 1, PricebookEntryId = pbe.Id,UnitPrice = 100 );
        OrderItem item2 = new OrderItem(OrderId = orderPro.Id, Quantity = 1, PricebookEntryId = pbe.Id,UnitPrice = 100 );
       
        insert new List<OrderItem>{ item1, item2 };
    }
    
    @isTest
    static void testCheckValidateOrder() {
        // Récupération des ordres créés en setup
        List<Order> ordersToUpdate = [SELECT Id, Status FROM Order];
        for (Order ord : ordersToUpdate) {
            ord.Status = 'Validated';
        }
        
        Test.startTest();
        try {
            update ordersToUpdate;
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('L\'order doit contenir au moins 3 order items'), 'Le message d\'erreur attendu ne s\'est pas affiché');
        }
        Test.stopTest();
    }

}