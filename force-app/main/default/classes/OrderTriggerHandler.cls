public with sharing class OrderTriggerHandler{

    public static void checkValidateOrder(List<order> updatedOrders) {
       
        list<Order> validateOrders = new List<Order>();

        for(Order ord :updatedOrders){
            if(ord.Status == 'Validated'){
                validateOrders.add(ord);
            }
        }
        
        List<Order> ordres = [SELECT Id, AccountId, Account.Customer_Type__c, (SELECT ID FROM OrderItems) FROM Order WHERE Id IN :validateOrders];

        for(Order ord : ordres){
         if((ord.Account.Customer_Type__c.contains('Particulier') && ord.OrderItems.size() < 3) ||
            (ord.Account.Customer_Type__c.contains('Professionnel') && ord.OrderItems.size() < 5)){
                Trigger.newMap.get(ord.Id).addError('L\'order doit contenir au moins 3 order items ou plus pour les particuliers et 5 order items ou plus ');
            }

        }

    }
}
