/* 
* A much smaller version of Kevin O'Hara's trigger framework.
* I have implemented only afterInsert, afterUpdate
*/
public virtual class TriggerHandler {

    public void run() {
        if(Trigger.isBefore && Trigger.isInsert) {
            beforeInsert();
        } else if (Trigger.isBefore && Trigger.isUpdate) {
            beforeUpdate();
        }
    }

    protected virtual void beforeInsert(){}
    protected virtual void beforeUpdate(){}
}