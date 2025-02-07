@isTest
private class AccountSelectorTest {

    @isTest
    static void testGetAccountById() {
        Account testAccount = new Account(Name = 'Test Account', Type = 'Customer', Industry = 'Tech', BillingCity = 'Paris', BillingCountry = 'France', Phone = '123456789', Website = 'www.test.com', Customer_Type__c = 'Particulier');
        insert testAccount;

        Test.startTest();
        Account result = AccountSelector.getAccountById(testAccount.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'L\'account ne doit pas être null');
        System.assertEquals(testAccount.Id, result.Id, 'L\'ID doit correspondre');
    }
}