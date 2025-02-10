public with sharing class TransporterSelector {

    @AuraEnabled(cacheable=true)
    public static List<Carrier_Price__c> getBestCarrierByCriteria(String country, String customerType) {
        if (String.isEmpty(country)) {
            throw new IllegalArgumentException('Country parameter cannot be empty.');
        }

        //Récupérer les transporteurs pour le pays et le type de client qui correspond
        List<Carrier_Price__c> carrierPrices = [
                            SELECT Id, Account__r.Id, Account__r.Name, Account__r.RecordType.Name, 
                                Account__r.Customer_Type__c, Country__c, Price__c, Delivery_Time__c
                            FROM Carrier_Price__c
                            WHERE Account__r.RecordType.Name = 'Carrier' 
                            AND Country__c = :country 
                            AND Account__r.Customer_Type__c INCLUDES (:customerType)
                            ORDER BY Price__c ASC, Delivery_Time__c ASC
                        ];
        
        //Aucun transporteur trouvé
        if (carrierPrices.isEmpty()) {
            return null;
        }
        return carrierPrices;
    }
    @TestVisible
    private static Carrier_Price__c getCarrierPriceById(ID carrierPriceId) {
        if (carrierPriceId == null) {
            throw new IllegalArgumentException('Id parameter cannot be null.');
        }   
        return [SELECT Id,Price__c,Delivery_Time__c,Account__r.Name FROM Carrier_Price__c WHERE Id = :carrierPriceId];
    }

    @AuraEnabled
    public static void createDelivery(String carrierPriceId,String orderId){
        Carrier_Price__c carrierPrice  = getCarrierPriceById(carrierPriceId);
        Order order= OrderService.getOrderById(orderId);

        Delivery__c delivery = new Delivery__c();
        delivery.Name=carrierPrice.Account__r.Name;
        delivery.Delivery_Date__c = Date.today().addDays(Integer.valueOf(carrierPrice.Delivery_Time__c));
        delivery.Status__c = 'En cours';
        delivery.Carrier_Price__r = carrierPrice;
        delivery.Order__r = order; 

        try{
            insert delivery;
           // System.debug('Delivery  :'+delivery);
        }catch(Exception e){
            //System.debug('ERROR :'+ e.getMessage());    
            throw new AuraHandledException(e.getMessage());
        } 
    }
}
    
