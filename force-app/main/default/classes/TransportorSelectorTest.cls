@isTest
private class TransportorSelectorTest {

    @isTest
    static void testGetBestCarrierByCriteria() {
        Account testCarrier = new Account(Name = 'Test Carrier', RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Carrier' LIMIT 1].Id, Customer_Type__c = 'Particulier');
        insert testCarrier;
        
        Carrier_Price__c testCarrierPrice = new Carrier_Price__c(Account__c = testCarrier.Id, Country__c = 'France', Price__c = 10, Delivery_Time__c = '2');
        insert testCarrierPrice;
        
        Test.startTest();
        List<Carrier_Price__c> carriers = TransporterSelector.getBestCarrierByCriteria('France', 'Particulier');
        Test.stopTest();
        
        System.assertNotEquals(null, carriers, 'Le résultat ne doit pas être null');
        System.assertEquals(1, carriers.size(), 'Il doit y avoir un transporteur trouvé');
    }
    
    @isTest
    static void testCreateDelivery() {      
        Account testCarrier = new Account(Name = 'Test Carrier', RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Carrier' LIMIT 1].Id);
        insert testCarrier;

        Carrier_Price__c carrierPrice = new Carrier_Price__c(Account__c = testCarrier.Id, Country__c = 'France', Price__c = 10, Delivery_Time__c = '2');
        insert carrierPrice;

        Account testAccount = new Account(Name = 'Test Account', Customer_Type__c = 'Particulier');
        insert testAccount;

        Order testOrder = new Order(AccountId = testAccount.Id, Status = 'Draft', EffectiveDate = Date.today());
        insert testOrder;

        // Vérifier que carrierPrice et testOrder existent
        System.assertNotEquals(null, carrierPrice, 'carrierPrice ne doit pas être null');
        System.assertNotEquals(null, testOrder, 'testOrder ne doit pas être null');
        System.assertNotEquals(null, testOrder.Id, 'testOrder.Id ne doit pas être null');

        // Tester la création de la livraison
        Test.startTest();
        Delivery__c delivery = TransporterSelector.createDelivery(carrierPrice, testOrder.Id);
        Test.stopTest();

        // Vérifier que la livraison a bien été créée
        System.assertNotEquals(null, delivery, 'La livraison ne doit pas être null');
        System.assertNotEquals(null, delivery.Id, 'La livraison doit avoir un ID');
    }
}