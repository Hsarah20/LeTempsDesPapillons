@isTest
private class TransportorSelectorTest {
    
    @testSetup
    static void setupTestData() {
        // Création d'un transporteur
        Account carrier = new Account(
            Name = 'Test Carrier',
            RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Carrier' LIMIT 1].Id,
            Customer_Type__c = 'Particulier'
        );
        insert carrier;

        // Création d'un prix transporteur
        Carrier_Price__c carrierPrice = new Carrier_Price__c(
            Account__c = carrier.Id,
            Country__c = 'France',
            Price__c = 10.0,
            Delivery_Time__c = '3'
        );
        insert carrierPrice;
    }
    
    @isTest
    static void testGetBestCarrierByCriteria() {
        Test.startTest();
        List<Carrier_Price__c> result = TransporterSelector.getBestCarrierByCriteria('France', 'Particulier');
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'La liste des transporteurs ne doit pas être nulle.');
        System.assertEquals(1, result.size(), 'Il doit y avoir un seul transporteur.');
    }
    
    @isTest
    static void testGetBestCarrierByCriteriaWithEmptyCountry() {
        try {
            TransporterSelector.getBestCarrierByCriteria('', 'Particulier');
            System.assert(false, 'Une exception aurait dû être levée.');
        } catch (Exception e) {
            System.assertEquals('Country parameter cannot be empty.', e.getMessage());
        }
    }
    
    @isTest
    static void testGetCarrierPriceById() {
        Carrier_Price__c carrierPrice = [SELECT Id FROM Carrier_Price__c LIMIT 1];
    
        Test.startTest();
        Carrier_Price__c result = TransporterSelector.getCarrierPriceById(carrierPrice.Id);
        Test.stopTest();
    
        System.assertNotEquals(null, result, 'Le prix du transporteur ne doit pas être nul.');
    }
    
    @isTest
    static void testCreateDelivery() {
        // Création d'un compte client
        Account carrier = new Account(
            Name = 'Test Customer',
            RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Carrier' LIMIT 1].Id
        );
        insert carrier;
    
        // Création d'une commande liée à ce compte
        Order order = new Order(
            Name = 'Test Order',
            Status = 'Draft',
            EffectiveDate = Date.today(),            
            AccountId = carrier.Id // Association du compte client
        );

        insert order;
    
        // Récupération d'un Carrier_Price__c existant
        Carrier_Price__c carrierPrice = [SELECT Id FROM Carrier_Price__c LIMIT 1];
    
        Test.startTest();
        TransporterSelector.createDelivery(carrierPrice.Id, order.Id);
        Test.stopTest();
    
        // Vérification de la livraison créée
        List<Delivery__c> deliveries = [SELECT Id, Status__c FROM Delivery__c WHERE Order__c = :order.Id LIMIT 1];
        System.assertNotEquals(0, deliveries.size(), 'Aucune livraison n\'a été créée.');
        Delivery__c delivery = deliveries[0];
        System.assertNotEquals(null, delivery, 'La livraison doit être créée.');
        System.assertEquals('En cours', delivery.Status__c, 'Le statut de la livraison doit être \"En cours\".');
    }

 }