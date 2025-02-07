trigger OrderTrigger on Order (after update) {
    
    OrderTriggerHandler.checkValidateOrder(Trigger.new);
}
