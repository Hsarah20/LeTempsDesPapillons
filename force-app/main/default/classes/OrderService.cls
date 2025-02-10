public with sharing class OrderService {
    
    @AuraEnabled(cacheable=true)
    public static Order getOrderById(Id orderId){
        if (orderId == null) {
            throw new AuraHandledException('Erreur : OrderId est null.');
        }
        return [
            SELECT Id,
                OrderNumber,
                AccountId,
                ShippingCountry,
                Status
            FROM Order
            WHERE Id = :orderId
            LIMIT 1
        ];
       
    }

    @AuraEnabled(cacheable=true)
    public static Boolean validateOrder(Order orderToValidate) {
        if (orderToValidate.AccountId == null) {
            throw new AuraHandledException('An order must be associated with an account.');
        }
        Account acc = AccountSelector.getAccountById(orderToValidate.AccountId);
        List<OrderItem> items = [SELECT Id FROM OrderItem WHERE OrderId = :orderToValidate.Id];   

        if ((acc.Customer_Type__c.contains('Particulier') && items.size() >= 3) ||
            (acc.Customer_Type__c.contains('Professionnel') && items.size() >= 5)) {
            return true;
        }
        
        return false;
    }

}