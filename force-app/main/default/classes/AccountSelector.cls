//Exemple de selector
public with sharing class AccountSelector {

    @AuraEnabled(cacheable=true)
    public static Account getAccountById(Id accountId) {
        if (accountId == null) {
            throw new AuraHandledException('An accountId must be provided.');
        }
        
        return [
                SELECT Id, Name, Type, Industry, BillingCity, BillingCountry, Phone, Website,Customer_Type__c
                FROM Account
                WHERE Id = :accountId
        ];
    }
}