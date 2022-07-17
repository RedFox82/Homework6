public class Stack {

    private List<Object> stack_object = new List<Object>();

//Create new stack-object
    public void Stack() {
        this.stack_object = stack_object;
    }

//Add new element to up-level of stack
    public void push(Object object_Push) {
        this.stack_object.add(object_Push);
    }

//Remove element from up-level stack
    public Object pop() {
        if (!this.stack_object.isEmpty()) {
            return this.stack_object.remove(this.stack_object.size() - 1);
        }
        return null;
    }

//----------------------debug section-----------------------

//Get element from up-level stack without deleting
    public Object get_element() {
        if (!this.stack_object.isEmpty()) {
            return this.stack_object[this.stack_object.size() - 1];
        }
        return null;
    }


}