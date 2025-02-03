public with sharing class TransporterSelector {

    @AuraEnabled(cacheable=true)
    public static List<Carrier_Price__c> getBestCarrierByCriteria(String country, String customerType) {
        if (String.isEmpty(country)) {
            throw new IllegalArgumentException('Country parameter cannot be empty.');
        }

        //Récupérer l'ID du Record Type "Carrier" de l'object Account
        RecordType carrierRecordType = [
            SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Carrier' LIMIT 1
        ];
       
        //Récupérer les transporteurs pour le pays et le type de client qui correspond
        List<Carrier_Price__c> carrierPrices = [
                            SELECT Id, Account__r.Id, Account__r.Name, Account__r.RecordType.Name, 
                                Account__r.Customer_Type__c, Country__c, Price__c, Delivery_Time__c
                            FROM Carrier_Price__c
                            WHERE Account__r.RecordType.Id = :carrierRecordType.Id 
                            AND Country__c = :country 
                            AND Account__r.Customer_Type__c INCLUDES (:customerType)
                            ORDER BY Price__c ASC, Delivery_Time__c ASC
                        ];
        
        //Aucun transporteur trouvé
        if (carrierPrices.isEmpty()) {
            return null;
        }
        
       // return carrierPrices.get(0).Account__r;
        return carrierPrices;
    }
}
    
